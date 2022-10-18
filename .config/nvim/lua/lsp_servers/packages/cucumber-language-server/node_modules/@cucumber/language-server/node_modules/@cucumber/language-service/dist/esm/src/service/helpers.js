import { walkGherkinDocument } from '@cucumber/gherkin-utils';
import { Range } from 'vscode-languageserver-types';
import { parseGherkinDocument } from '../gherkin/parseGherkinDocument.js';
export function getStepRange(gherkinSource, position) {
    const { gherkinDocument } = parseGherkinDocument(gherkinSource);
    if (!gherkinDocument) {
        return undefined;
    }
    let stepKeyword = undefined;
    let stepText = undefined;
    let range = undefined;
    walkGherkinDocument(gherkinDocument, undefined, {
        step(step) {
            if (step.location.line === position.line + 1 && step.location.column !== undefined) {
                stepText = step.text;
                stepKeyword = step.keyword;
                const startCharacter = step.location.column + step.keyword.length - 1;
                const endCharacter = startCharacter + stepText.length;
                range = Range.create(position.line, startCharacter, position.line, endCharacter);
            }
        },
    });
    if (stepKeyword && stepText && range) {
        return {
            stepKeyword,
            stepText,
            range,
        };
    }
}
//# sourceMappingURL=helpers.js.map