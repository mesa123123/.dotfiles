import { Search } from 'js-search';
export function jsSearchIndex(suggestions) {
    const docs = suggestions.map((suggestion, id) => {
        return {
            id,
            text: suggestion.segments
                .map((segment) => (typeof segment === 'string' ? segment : segment.join(' ')))
                .join(''),
        };
    });
    const search = new Search('id');
    search.addIndex('text');
    search.addDocuments(docs);
    return (text) => {
        if (!text)
            return [];
        const results = search.search(text);
        return results.map((result) => suggestions[result.id]);
    };
}
//# sourceMappingURL=jsSearchIndex.js.map