export function makeKey(parameterType) {
    return parameterType.name || parameterType.regexpStrings.join('|');
}
//# sourceMappingURL=helpers.js.map