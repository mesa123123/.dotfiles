export function extname(uri) {
    // Roughly-enough implements https://nodejs.org/dist/latest-v18.x/docs/api/path.html#pathextnamepath
    return uri.substring(uri.lastIndexOf('.'), uri.length) || '';
}
//# sourceMappingURL=Files.js.map