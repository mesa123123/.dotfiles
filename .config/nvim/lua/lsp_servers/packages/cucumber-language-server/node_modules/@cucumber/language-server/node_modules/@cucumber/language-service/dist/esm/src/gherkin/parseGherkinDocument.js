import { AstBuilder, GherkinClassicTokenMatcher, Parser } from '@cucumber/gherkin';
import { IdGenerator } from '@cucumber/messages';
const uuidFn = IdGenerator.uuid();
/**
 * Incrementally parses a Gherkin Document, allowing some syntax errors to occur.
 */
export function parseGherkinDocument(gherkinSource) {
    const builder = new AstBuilder(uuidFn);
    const matcher = new GherkinClassicTokenMatcher();
    const parser = new Parser(builder, matcher);
    try {
        return {
            gherkinDocument: parser.parse(gherkinSource),
        };
    }
    catch (error) {
        let gherkinDocument;
        for (let i = 0; i < 10; i++) {
            gherkinDocument = builder.getResult();
            if (gherkinDocument) {
                return {
                    gherkinDocument,
                    error,
                };
            }
            try {
                builder.endRule();
            }
            catch (ignore) {
                // no-op
            }
        }
        return {
            error,
        };
    }
}
//# sourceMappingURL=parseGherkinDocument.js.map