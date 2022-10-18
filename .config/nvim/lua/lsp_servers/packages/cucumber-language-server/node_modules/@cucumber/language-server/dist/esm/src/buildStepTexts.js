import { walkGherkinDocument } from '@cucumber/gherkin-utils';
import { parseGherkinDocument } from '@cucumber/language-service';
export function buildStepTexts(gherkinSource) {
    const { gherkinDocument } = parseGherkinDocument(gherkinSource);
    if (!gherkinDocument) {
        return [];
    }
    const stepTexts = [];
    walkGherkinDocument(gherkinDocument, undefined, {
        step(step) {
            stepTexts.push(step.text);
        },
    });
    return stepTexts;
}
//# sourceMappingURL=buildStepTexts.js.map