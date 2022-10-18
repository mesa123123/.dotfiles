import { walkGherkinDocument } from '@cucumber/gherkin-utils';
import { Position, Range, SymbolKind } from 'vscode-languageserver-types';
import { parseGherkinDocument } from '../gherkin/parseGherkinDocument.js';
export function getGherkinDocumentFeatureSymbol(gherkinSource) {
    const { gherkinDocument } = parseGherkinDocument(gherkinSource);
    if (!gherkinDocument) {
        return null;
    }
    const symbols = {};
    const data = walkGherkinDocument(gherkinDocument, symbols, {
        feature(feature, symbols) {
            const prefix = `${feature.keyword}: `;
            const name = `${prefix}${feature.name}`;
            const range = makeRange(feature.location, prefix, name);
            const sym = {
                name,
                range,
                selectionRange: range,
                kind: SymbolKind.File,
                children: [],
            };
            return Object.assign(Object.assign({}, symbols), { feature: sym, parent: sym });
        },
        rule(rule, symbols) {
            var _a, _b;
            const prefix = `${rule.keyword}: `;
            const name = `${prefix}${rule.name}`;
            const range = makeRange(rule.location, prefix, name);
            const sym = {
                name,
                range,
                selectionRange: range,
                kind: SymbolKind.Interface,
                children: [],
            };
            (_b = (_a = symbols.parent) === null || _a === void 0 ? void 0 : _a.children) === null || _b === void 0 ? void 0 : _b.push(sym);
            return Object.assign(Object.assign({}, symbols), { parent: sym });
        },
        background(background, symbols) {
            var _a, _b;
            const prefix = `${background.keyword}: `;
            const name = `${prefix}${background.name}`;
            const range = makeRange(background.location, prefix, name);
            const sym = {
                name,
                range,
                selectionRange: range,
                kind: SymbolKind.Constructor,
                children: [],
            };
            (_b = (_a = symbols.parent) === null || _a === void 0 ? void 0 : _a.children) === null || _b === void 0 ? void 0 : _b.push(sym);
            return symbols;
        },
        scenario(scenario, symbols) {
            var _a, _b;
            const prefix = `${scenario.keyword}: `;
            const name = `${prefix}${scenario.name}`;
            const range = makeRange(scenario.location, prefix, name);
            const sym = {
                name,
                range,
                selectionRange: range,
                kind: SymbolKind.Event,
                children: [],
            };
            (_b = (_a = symbols.parent) === null || _a === void 0 ? void 0 : _a.children) === null || _b === void 0 ? void 0 : _b.push(sym);
            return symbols;
        },
    });
    return data.feature || null;
}
function makeRange(location, prefix, name) {
    const line = location.line - 1;
    const col = (location.column || 0) - 1;
    return Range.create(Position.create(line, col + prefix.length), Position.create(line, col + name.length));
}
//# sourceMappingURL=getGherkinDocumentFeatureSymbol.js.map