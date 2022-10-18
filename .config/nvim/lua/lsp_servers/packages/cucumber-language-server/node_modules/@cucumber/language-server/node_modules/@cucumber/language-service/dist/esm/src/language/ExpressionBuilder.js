import { ExpressionFactory, ParameterTypeRegistry, } from '@cucumber/cucumber-expressions';
import { createLocationLink, makeParameterType, sortLinks } from './helpers.js';
import { SourceAnalyzer } from './SourceAnalyzer.js';
export class ExpressionBuilder {
    constructor(parserAdapter) {
        this.parserAdapter = parserAdapter;
    }
    build(sources, parameterTypes) {
        const errors = [];
        const registry = new ParameterTypeRegistry();
        const expressionFactory = new ExpressionFactory(registry);
        function defineParameterType(parameterType) {
            try {
                registry.defineParameterType(parameterType);
            }
            catch (err) {
                errors.push(err);
            }
        }
        for (const parameterType of parameterTypes) {
            defineParameterType(makeParameterType(parameterType.name, new RegExp(parameterType.regexp)));
        }
        const sourceAnalyser = new SourceAnalyzer(this.parserAdapter, sources);
        const parameterTypeLinks = [];
        sourceAnalyser.eachParameterTypeLink((parameterTypeLink) => {
            defineParameterType(parameterTypeLink.parameterType);
            parameterTypeLinks.push(parameterTypeLink);
        });
        const expressionLinks = [];
        sourceAnalyser.eachStepDefinitionExpression((stepDefinitionExpression, rootNode, expressionNode, source) => {
            try {
                const expression = expressionFactory.createExpression(stepDefinitionExpression);
                const locationLink = createLocationLink(rootNode, expressionNode, source.uri);
                expressionLinks.push({ expression, locationLink });
            }
            catch (err) {
                errors.push(err);
            }
        });
        return {
            expressionLinks: sortLinks(expressionLinks),
            parameterTypeLinks: sortLinks(parameterTypeLinks),
            errors: sourceAnalyser.getErrors().concat(errors),
            registry,
        };
    }
}
//# sourceMappingURL=ExpressionBuilder.js.map