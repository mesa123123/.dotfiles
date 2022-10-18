export function lspCompletionSnippet(segments) {
    let n = 1;
    return segments
        .map((segment) => (Array.isArray(segment) ? lspPlaceholder(n++, segment) : segment))
        .join('');
}
function lspPlaceholder(i, choices) {
    // Escape $ } \ , | in choices
    // https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#grammar
    const escapedChoices = choices
        .filter((choice) => choice !== '')
        .map((choice) => choice.replace(/([$\\},|])/g, '\\$1'));
    return `\${${i}|${escapedChoices.join(',')}|}`;
}
//# sourceMappingURL=lspCompletionSnippet.js.map