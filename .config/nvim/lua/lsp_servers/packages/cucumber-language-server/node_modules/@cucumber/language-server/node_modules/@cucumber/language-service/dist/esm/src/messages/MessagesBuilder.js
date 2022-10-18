import { ExpressionFactory, ParameterType, ParameterTypeRegistry, } from '@cucumber/cucumber-expressions';
import { StepDefinitionPatternType } from '@cucumber/messages';
import { extractStepTexts } from '../gherkin/extractStepTexts.js';
import { buildSuggestions } from '../suggestions/buildSuggestions.js';
/**
 * Builds MessagesBuilderResult from Cucumber Messages.
 */
export class MessagesBuilder {
    constructor() {
        this.parameterTypeRegistry = new ParameterTypeRegistry();
        this.expressionFactory = new ExpressionFactory(this.parameterTypeRegistry);
        this.expressions = [];
        this.stepTexts = [];
    }
    processEnvelope(envelope, errorHandler = () => undefined) {
        if (envelope.parameterType) {
            const { name, regularExpressions, useForSnippets, preferForRegularExpressionMatch } = envelope.parameterType;
            try {
                // TODO: Check if the type exists before registering. Because Cucumber-JVM emits them several times
                this.parameterTypeRegistry.defineParameterType(new ParameterType(name, regularExpressions, Object, () => undefined, useForSnippets, preferForRegularExpressionMatch));
            }
            catch (err) {
                errorHandler(err);
            }
        }
        if (envelope.stepDefinition) {
            const expr = envelope.stepDefinition.pattern.type === StepDefinitionPatternType.CUCUMBER_EXPRESSION
                ? envelope.stepDefinition.pattern.source
                : new RegExp(envelope.stepDefinition.pattern.source);
            try {
                const expression = this.expressionFactory.createExpression(expr);
                this.expressions.push(expression);
            }
            catch (err) {
                errorHandler(err);
            }
        }
        if (envelope.gherkinDocument) {
            this.stepTexts = extractStepTexts(envelope.gherkinDocument, this.stepTexts);
        }
    }
    build() {
        return {
            suggestions: buildSuggestions(this.parameterTypeRegistry, this.stepTexts, this.expressions),
            expressions: this.expressions,
        };
    }
}
//# sourceMappingURL=MessagesBuilder.js.map