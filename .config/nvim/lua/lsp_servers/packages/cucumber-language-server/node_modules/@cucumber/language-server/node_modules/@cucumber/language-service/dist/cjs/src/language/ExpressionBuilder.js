"use strict";
var __values = (this && this.__values) || function(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExpressionBuilder = void 0;
var cucumber_expressions_1 = require("@cucumber/cucumber-expressions");
var helpers_js_1 = require("./helpers.js");
var SourceAnalyzer_js_1 = require("./SourceAnalyzer.js");
var ExpressionBuilder = /** @class */ (function () {
    function ExpressionBuilder(parserAdapter) {
        this.parserAdapter = parserAdapter;
    }
    ExpressionBuilder.prototype.build = function (sources, parameterTypes) {
        var e_1, _a;
        var errors = [];
        var registry = new cucumber_expressions_1.ParameterTypeRegistry();
        var expressionFactory = new cucumber_expressions_1.ExpressionFactory(registry);
        function defineParameterType(parameterType) {
            try {
                registry.defineParameterType(parameterType);
            }
            catch (err) {
                errors.push(err);
            }
        }
        try {
            for (var parameterTypes_1 = __values(parameterTypes), parameterTypes_1_1 = parameterTypes_1.next(); !parameterTypes_1_1.done; parameterTypes_1_1 = parameterTypes_1.next()) {
                var parameterType = parameterTypes_1_1.value;
                defineParameterType((0, helpers_js_1.makeParameterType)(parameterType.name, new RegExp(parameterType.regexp)));
            }
        }
        catch (e_1_1) { e_1 = { error: e_1_1 }; }
        finally {
            try {
                if (parameterTypes_1_1 && !parameterTypes_1_1.done && (_a = parameterTypes_1.return)) _a.call(parameterTypes_1);
            }
            finally { if (e_1) throw e_1.error; }
        }
        var sourceAnalyser = new SourceAnalyzer_js_1.SourceAnalyzer(this.parserAdapter, sources);
        var parameterTypeLinks = [];
        sourceAnalyser.eachParameterTypeLink(function (parameterTypeLink) {
            defineParameterType(parameterTypeLink.parameterType);
            parameterTypeLinks.push(parameterTypeLink);
        });
        var expressionLinks = [];
        sourceAnalyser.eachStepDefinitionExpression(function (stepDefinitionExpression, rootNode, expressionNode, source) {
            try {
                var expression = expressionFactory.createExpression(stepDefinitionExpression);
                var locationLink = (0, helpers_js_1.createLocationLink)(rootNode, expressionNode, source.uri);
                expressionLinks.push({ expression: expression, locationLink: locationLink });
            }
            catch (err) {
                errors.push(err);
            }
        });
        return {
            expressionLinks: (0, helpers_js_1.sortLinks)(expressionLinks),
            parameterTypeLinks: (0, helpers_js_1.sortLinks)(parameterTypeLinks),
            errors: sourceAnalyser.getErrors().concat(errors),
            registry: registry,
        };
    };
    return ExpressionBuilder;
}());
exports.ExpressionBuilder = ExpressionBuilder;
//# sourceMappingURL=ExpressionBuilder.js.map