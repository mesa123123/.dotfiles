"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MessagesBuilder = void 0;
var cucumber_expressions_1 = require("@cucumber/cucumber-expressions");
var messages_1 = require("@cucumber/messages");
var extractStepTexts_js_1 = require("../gherkin/extractStepTexts.js");
var buildSuggestions_js_1 = require("../suggestions/buildSuggestions.js");
/**
 * Builds MessagesBuilderResult from Cucumber Messages.
 */
var MessagesBuilder = /** @class */ (function () {
    function MessagesBuilder() {
        this.parameterTypeRegistry = new cucumber_expressions_1.ParameterTypeRegistry();
        this.expressionFactory = new cucumber_expressions_1.ExpressionFactory(this.parameterTypeRegistry);
        this.expressions = [];
        this.stepTexts = [];
    }
    MessagesBuilder.prototype.processEnvelope = function (envelope, errorHandler) {
        if (errorHandler === void 0) { errorHandler = function () { return undefined; }; }
        if (envelope.parameterType) {
            var _a = envelope.parameterType, name_1 = _a.name, regularExpressions = _a.regularExpressions, useForSnippets = _a.useForSnippets, preferForRegularExpressionMatch = _a.preferForRegularExpressionMatch;
            try {
                // TODO: Check if the type exists before registering. Because Cucumber-JVM emits them several times
                this.parameterTypeRegistry.defineParameterType(new cucumber_expressions_1.ParameterType(name_1, regularExpressions, Object, function () { return undefined; }, useForSnippets, preferForRegularExpressionMatch));
            }
            catch (err) {
                errorHandler(err);
            }
        }
        if (envelope.stepDefinition) {
            var expr = envelope.stepDefinition.pattern.type === messages_1.StepDefinitionPatternType.CUCUMBER_EXPRESSION
                ? envelope.stepDefinition.pattern.source
                : new RegExp(envelope.stepDefinition.pattern.source);
            try {
                var expression = this.expressionFactory.createExpression(expr);
                this.expressions.push(expression);
            }
            catch (err) {
                errorHandler(err);
            }
        }
        if (envelope.gherkinDocument) {
            this.stepTexts = (0, extractStepTexts_js_1.extractStepTexts)(envelope.gherkinDocument, this.stepTexts);
        }
    };
    MessagesBuilder.prototype.build = function () {
        return {
            suggestions: (0, buildSuggestions_js_1.buildSuggestions)(this.parameterTypeRegistry, this.stepTexts, this.expressions),
            expressions: this.expressions,
        };
    };
    return MessagesBuilder;
}());
exports.MessagesBuilder = MessagesBuilder;
//# sourceMappingURL=MessagesBuilder.js.map