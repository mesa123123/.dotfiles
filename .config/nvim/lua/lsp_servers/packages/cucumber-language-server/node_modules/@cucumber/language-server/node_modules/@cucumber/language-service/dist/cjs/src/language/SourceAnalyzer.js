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
var __read = (this && this.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SourceAnalyzer = exports.NO_EXPRESSION = void 0;
var helpers_js_1 = require("./helpers.js");
var languages_js_1 = require("./languages.js");
exports.NO_EXPRESSION = '';
var SourceAnalyzer = /** @class */ (function () {
    function SourceAnalyzer(parserAdapter, sources) {
        this.parserAdapter = parserAdapter;
        this.sources = sources;
        this.errors = [];
        this.treeByContent = new Map();
    }
    SourceAnalyzer.prototype.eachParameterTypeLink = function (callback) {
        var e_1, _a, e_2, _b, e_3, _c;
        var parameterTypeMatches = this.getSourceMatches(function (language) { return language.defineParameterTypeQueries; });
        try {
            for (var _d = __values(parameterTypeMatches.entries()), _e = _d.next(); !_e.done; _e = _d.next()) {
                var _f = __read(_e.value, 2), sourceMatches = _f[1];
                var propsByName = {};
                try {
                    for (var sourceMatches_1 = (e_2 = void 0, __values(sourceMatches)), sourceMatches_1_1 = sourceMatches_1.next(); !sourceMatches_1_1.done; sourceMatches_1_1 = sourceMatches_1.next()) {
                        var _g = sourceMatches_1_1.value, source = _g.source, match = _g.match;
                        var nameNode = (0, helpers_js_1.syntaxNode)(match, 'name');
                        var rootNode = (0, helpers_js_1.syntaxNode)(match, 'root');
                        var expressionNode = (0, helpers_js_1.syntaxNode)(match, 'expression');
                        if (nameNode && rootNode) {
                            var language = (0, languages_js_1.getLanguage)(source.languageName);
                            var parameterTypeName = language.toParameterTypeName(nameNode);
                            var regExps = language.toParameterTypeRegExps(expressionNode);
                            var selectionNode = expressionNode || nameNode;
                            var locationLink = (0, helpers_js_1.createLocationLink)(rootNode, selectionNode, source.uri);
                            var props = (propsByName[parameterTypeName] = propsByName[parameterTypeName] || { locationLink: locationLink, regexpsList: [] });
                            props.regexpsList.push(regExps);
                        }
                    }
                }
                catch (e_2_1) { e_2 = { error: e_2_1 }; }
                finally {
                    try {
                        if (sourceMatches_1_1 && !sourceMatches_1_1.done && (_b = sourceMatches_1.return)) _b.call(sourceMatches_1);
                    }
                    finally { if (e_2) throw e_2.error; }
                }
                try {
                    for (var _h = (e_3 = void 0, __values(Object.entries(propsByName))), _j = _h.next(); !_j.done; _j = _h.next()) {
                        var _k = __read(_j.value, 2), name_1 = _k[0], _l = _k[1], regexpsList = _l.regexpsList, locationLink = _l.locationLink;
                        var regexps = regexpsList.reduce(function (prev, current) {
                            if (Array.isArray(current)) {
                                return prev.concat.apply(prev, __spreadArray([], __read(current), false));
                            }
                            else {
                                return prev.concat(current);
                            }
                        }, []);
                        var parameterType = (0, helpers_js_1.makeParameterType)(name_1, regexps);
                        var parameterTypeLink = { parameterType: parameterType, locationLink: locationLink };
                        callback(parameterTypeLink);
                    }
                }
                catch (e_3_1) { e_3 = { error: e_3_1 }; }
                finally {
                    try {
                        if (_j && !_j.done && (_c = _h.return)) _c.call(_h);
                    }
                    finally { if (e_3) throw e_3.error; }
                }
            }
        }
        catch (e_1_1) { e_1 = { error: e_1_1 }; }
        finally {
            try {
                if (_e && !_e.done && (_a = _d.return)) _a.call(_d);
            }
            finally { if (e_1) throw e_1.error; }
        }
    };
    SourceAnalyzer.prototype.eachStepDefinitionExpression = function (callback) {
        var e_4, _a, e_5, _b;
        var stepDefinitionMatches = this.getSourceMatches(function (language) { return language.defineStepDefinitionQueries; });
        try {
            for (var _c = __values(stepDefinitionMatches.entries()), _d = _c.next(); !_d.done; _d = _c.next()) {
                var _e = __read(_d.value, 2), sourceMatches = _e[1];
                try {
                    for (var sourceMatches_2 = (e_5 = void 0, __values(sourceMatches)), sourceMatches_2_1 = sourceMatches_2.next(); !sourceMatches_2_1.done; sourceMatches_2_1 = sourceMatches_2.next()) {
                        var _f = sourceMatches_2_1.value, source = _f.source, match = _f.match;
                        var expressionNode = (0, helpers_js_1.syntaxNode)(match, 'expression');
                        var rootNode = (0, helpers_js_1.syntaxNode)(match, 'root');
                        if (expressionNode && rootNode) {
                            var language = (0, languages_js_1.getLanguage)(source.languageName);
                            var stepDefinitionExpression = language.toStepDefinitionExpression(expressionNode);
                            if (stepDefinitionExpression !== exports.NO_EXPRESSION) {
                                callback(stepDefinitionExpression, rootNode, expressionNode, source);
                            }
                        }
                    }
                }
                catch (e_5_1) { e_5 = { error: e_5_1 }; }
                finally {
                    try {
                        if (sourceMatches_2_1 && !sourceMatches_2_1.done && (_b = sourceMatches_2.return)) _b.call(sourceMatches_2);
                    }
                    finally { if (e_5) throw e_5.error; }
                }
            }
        }
        catch (e_4_1) { e_4 = { error: e_4_1 }; }
        finally {
            try {
                if (_d && !_d.done && (_a = _c.return)) _a.call(_c);
            }
            finally { if (e_4) throw e_4.error; }
        }
    };
    SourceAnalyzer.prototype.getSourceMatches = function (getQueryStrings) {
        var e_6, _a, e_7, _b, e_8, _c;
        var result = new Map();
        try {
            for (var _d = __values(this.sources), _e = _d.next(); !_e.done; _e = _d.next()) {
                var source = _e.value;
                this.parserAdapter.setLanguageName(source.languageName);
                var tree = void 0;
                try {
                    tree = this.parse(source);
                }
                catch (err) {
                    err.message += "\nuri: ".concat(source.uri, "\nlanguage: ").concat(source.languageName, "\n");
                    this.errors.push(err);
                    continue;
                }
                var language = (0, languages_js_1.getLanguage)(source.languageName);
                var queryStrings = getQueryStrings(language);
                try {
                    for (var queryStrings_1 = (e_7 = void 0, __values(queryStrings)), queryStrings_1_1 = queryStrings_1.next(); !queryStrings_1_1.done; queryStrings_1_1 = queryStrings_1.next()) {
                        var queryString = queryStrings_1_1.value;
                        var query = this.parserAdapter.query(queryString);
                        var matches = query.matches(tree.rootNode);
                        try {
                            for (var matches_1 = (e_8 = void 0, __values(matches)), matches_1_1 = matches_1.next(); !matches_1_1.done; matches_1_1 = matches_1.next()) {
                                var match = matches_1_1.value;
                                var sourceMatches = result.get(language) || [];
                                result.set(language, sourceMatches);
                                sourceMatches.push({ source: source, match: match });
                            }
                        }
                        catch (e_8_1) { e_8 = { error: e_8_1 }; }
                        finally {
                            try {
                                if (matches_1_1 && !matches_1_1.done && (_c = matches_1.return)) _c.call(matches_1);
                            }
                            finally { if (e_8) throw e_8.error; }
                        }
                    }
                }
                catch (e_7_1) { e_7 = { error: e_7_1 }; }
                finally {
                    try {
                        if (queryStrings_1_1 && !queryStrings_1_1.done && (_b = queryStrings_1.return)) _b.call(queryStrings_1);
                    }
                    finally { if (e_7) throw e_7.error; }
                }
            }
        }
        catch (e_6_1) { e_6 = { error: e_6_1 }; }
        finally {
            try {
                if (_e && !_e.done && (_a = _d.return)) _a.call(_d);
            }
            finally { if (e_6) throw e_6.error; }
        }
        return result;
    };
    SourceAnalyzer.prototype.getErrors = function () {
        return this.errors;
    };
    SourceAnalyzer.prototype.parse = function (source) {
        var tree = this.treeByContent.get(source);
        if (!tree) {
            this.treeByContent.set(source, (tree = this.parserAdapter.parser.parse(source.content)));
        }
        return tree;
    };
    return SourceAnalyzer;
}());
exports.SourceAnalyzer = SourceAnalyzer;
//# sourceMappingURL=SourceAnalyzer.js.map