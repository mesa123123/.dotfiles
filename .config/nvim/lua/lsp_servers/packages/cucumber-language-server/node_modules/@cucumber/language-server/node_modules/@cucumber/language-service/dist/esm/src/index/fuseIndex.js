import Fuse from 'fuse.js';
export function fuseIndex(suggestions) {
    const docs = suggestions.map((suggestion) => {
        return {
            text: suggestion.segments
                .map((segment) => (typeof segment === 'string' ? segment : segment.join(' ')))
                .join(''),
        };
    });
    const fuse = new Fuse(docs, {
        keys: ['text'],
        minMatchCharLength: 2,
        threshold: 0.1,
        ignoreLocation: true,
        fieldNormWeight: 1,
        shouldSort: true,
    });
    return (text) => {
        if (!text)
            return [];
        const results = fuse.search(text, { limit: 10 });
        return results.map((result) => suggestions[result.refIndex]);
    };
}
//# sourceMappingURL=fuseIndex.js.map