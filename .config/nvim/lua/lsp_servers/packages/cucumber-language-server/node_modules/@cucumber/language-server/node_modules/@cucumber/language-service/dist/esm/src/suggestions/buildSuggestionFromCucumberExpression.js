import { NodeType, } from '@cucumber/cucumber-expressions';
import { makeKey } from './helpers.js';
export function buildSuggestionFromCucumberExpression(expression, registry, parameterChoices) {
    try {
        const compiledSegments = compile(expression.ast, registry, parameterChoices);
        const segments = flatten(compiledSegments);
        return {
            label: expression.source,
            segments,
            matched: true,
        };
    }
    catch (err) {
        err.message += `
Unable to compile Cucumber Expression "${expression.source}"
Please submit an issue at https://github.com/cucumber/language-service/issues
`;
        throw err;
    }
}
function flatten(cr) {
    if (typeof cr === 'string')
        return [cr];
    return cr.reduce((prev, curr) => {
        const last = prev[prev.length - 1];
        if (typeof curr === 'string') {
            if (typeof last === 'string') {
                return prev.slice(0, prev.length - 1).concat([last + curr]);
            }
            else {
                return prev.concat(curr);
            }
        }
        else {
            const x = curr.flatMap((e) => {
                if (typeof e === 'string')
                    return e;
                const e0 = e[0];
                if (!(typeof e0 === 'string'))
                    throw new Error('Unexpected array: ' + JSON.stringify(e));
                return e0;
            });
            return prev.concat([x]);
        }
    }, []);
}
function compile(node, registry, parameterChoices) {
    switch (node.type) {
        case NodeType.text:
            return node.text();
        case NodeType.optional:
            return compileOptional(node);
        case NodeType.alternation:
            return compileAlternation(node, registry, parameterChoices);
        case NodeType.alternative:
            return compileAlternative(node, registry, parameterChoices);
        case NodeType.parameter:
            return compileParameter(node, registry, parameterChoices);
        case NodeType.expression:
            return compileExpression(node, registry, parameterChoices);
        default:
            // Can't happen as long as the switch case is exhaustive
            throw new Error(node.type);
    }
}
function compileOptional(node) {
    if (node.nodes === undefined)
        throw new Error('No optional');
    return [node.nodes.map((node) => node.text()).join('')];
}
function compileAlternation(node, registry, parameterChoices) {
    return (node.nodes || []).map((node) => compile(node, registry, parameterChoices));
}
function compileAlternative(node, registry, parameterChoices) {
    return (node.nodes || []).map((node) => compile(node, registry, parameterChoices));
}
function compileParameter(node, registry, parameterChoices) {
    const parameterType = registry.lookupByTypeName(node.text());
    if (parameterType === undefined)
        throw new Error(`No parameter type named ${node.text()}`);
    const key = makeKey(parameterType);
    return parameterChoices[key] || defaultParameterChoices(parameterType) || [''];
}
function compileExpression(node, registry, parameterChoices) {
    return (node.nodes || []).reduce((prev, curr) => {
        const child = compile(curr, registry, parameterChoices);
        // If we have an optional, we'll create two choice segments - one with and one without the optional
        if (curr.type === NodeType.optional) {
            const last = prev[prev.length - 1];
            if (!Array.isArray(child)) {
                throw new Error(`Expected an array, but was ${JSON.stringify(child)}`);
            }
            if (typeof last !== 'string' || last.trim() === '') {
                return prev.concat(child[0]);
            }
            return prev.slice(0, prev.length - 1).concat([[last, last + child[0]]]);
        }
        else {
            return prev.concat([child]);
        }
    }, []);
}
function defaultParameterChoices(parameterType) {
    // @ts-ignore
    if (parameterType.type === Number) {
        return ['0'];
    }
    return ['?'];
}
//# sourceMappingURL=buildSuggestionFromCucumberExpression.js.map