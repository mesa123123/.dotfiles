import { getStepRange } from './helpers.js';
export function getStepDefinitionLocationLinks(gherkinSource, position, expressionLinks) {
    const stepRange = getStepRange(gherkinSource, position);
    if (!stepRange)
        return [];
    const locationLinks = [];
    for (const expressionLink of expressionLinks) {
        if (expressionLink.expression.match(stepRange.stepText)) {
            const locationLink = Object.assign(Object.assign({}, expressionLink.locationLink), { originSelectionRange: stepRange.range });
            locationLinks.push(locationLink);
        }
    }
    return locationLinks;
}
//# sourceMappingURL=getStepDefinitionLocationLinks.js.map