import { Errors } from '@cucumber/gherkin';
import { GherkinDocument } from '@cucumber/messages';
export type ParseResult = {
    gherkinDocument?: GherkinDocument;
    error?: Errors.GherkinException;
};
/**
 * Incrementally parses a Gherkin Document, allowing some syntax errors to occur.
 */
export declare function parseGherkinDocument(gherkinSource: string): ParseResult;
//# sourceMappingURL=parseGherkinDocument.d.ts.map