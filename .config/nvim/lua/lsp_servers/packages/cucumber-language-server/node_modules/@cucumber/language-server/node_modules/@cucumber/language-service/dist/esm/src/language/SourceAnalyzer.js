import { createLocationLink, makeParameterType, syntaxNode } from './helpers.js';
import { getLanguage } from './languages.js';
export const NO_EXPRESSION = '';
export class SourceAnalyzer {
    constructor(parserAdapter, sources) {
        this.parserAdapter = parserAdapter;
        this.sources = sources;
        this.errors = [];
        this.treeByContent = new Map();
    }
    eachParameterTypeLink(callback) {
        const parameterTypeMatches = this.getSourceMatches((language) => language.defineParameterTypeQueries);
        for (const [, sourceMatches] of parameterTypeMatches.entries()) {
            const propsByName = {};
            for (const { source, match } of sourceMatches) {
                const nameNode = syntaxNode(match, 'name');
                const rootNode = syntaxNode(match, 'root');
                const expressionNode = syntaxNode(match, 'expression');
                if (nameNode && rootNode) {
                    const language = getLanguage(source.languageName);
                    const parameterTypeName = language.toParameterTypeName(nameNode);
                    const regExps = language.toParameterTypeRegExps(expressionNode);
                    const selectionNode = expressionNode || nameNode;
                    const locationLink = createLocationLink(rootNode, selectionNode, source.uri);
                    const props = (propsByName[parameterTypeName] = propsByName[parameterTypeName] || { locationLink, regexpsList: [] });
                    props.regexpsList.push(regExps);
                }
            }
            for (const [name, { regexpsList, locationLink }] of Object.entries(propsByName)) {
                const regexps = regexpsList.reduce((prev, current) => {
                    if (Array.isArray(current)) {
                        return prev.concat(...current);
                    }
                    else {
                        return prev.concat(current);
                    }
                }, []);
                const parameterType = makeParameterType(name, regexps);
                const parameterTypeLink = { parameterType, locationLink };
                callback(parameterTypeLink);
            }
        }
    }
    eachStepDefinitionExpression(callback) {
        const stepDefinitionMatches = this.getSourceMatches((language) => language.defineStepDefinitionQueries);
        for (const [, sourceMatches] of stepDefinitionMatches.entries()) {
            for (const { source, match } of sourceMatches) {
                const expressionNode = syntaxNode(match, 'expression');
                const rootNode = syntaxNode(match, 'root');
                if (expressionNode && rootNode) {
                    const language = getLanguage(source.languageName);
                    const stepDefinitionExpression = language.toStepDefinitionExpression(expressionNode);
                    if (stepDefinitionExpression !== NO_EXPRESSION) {
                        callback(stepDefinitionExpression, rootNode, expressionNode, source);
                    }
                }
            }
        }
    }
    getSourceMatches(getQueryStrings) {
        const result = new Map();
        for (const source of this.sources) {
            this.parserAdapter.setLanguageName(source.languageName);
            let tree;
            try {
                tree = this.parse(source);
            }
            catch (err) {
                err.message += `
uri: ${source.uri}
language: ${source.languageName}
`;
                this.errors.push(err);
                continue;
            }
            const language = getLanguage(source.languageName);
            const queryStrings = getQueryStrings(language);
            for (const queryString of queryStrings) {
                const query = this.parserAdapter.query(queryString);
                const matches = query.matches(tree.rootNode);
                for (const match of matches) {
                    const sourceMatches = result.get(language) || [];
                    result.set(language, sourceMatches);
                    sourceMatches.push({ source, match });
                }
            }
        }
        return result;
    }
    getErrors() {
        return this.errors;
    }
    parse(source) {
        let tree = this.treeByContent.get(source);
        if (!tree) {
            this.treeByContent.set(source, (tree = this.parserAdapter.parser.parse(source.content)));
        }
        return tree;
    }
}
//# sourceMappingURL=SourceAnalyzer.js.map