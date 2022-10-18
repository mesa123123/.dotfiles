import { walkGherkinDocument } from '@cucumber/gherkin-utils';
export function extractStepTexts(gherkinDocument, stepTexts) {
    return walkGherkinDocument(gherkinDocument, stepTexts, {
        step(step, arr) {
            return arr.concat(step.text);
        },
    });
}
//# sourceMappingURL=extractStepTexts.js.map