import Parser from 'tree-sitter';
import { LanguageName, ParserAdapter } from '../language/types.js';
export declare class NodeParserAdapter implements ParserAdapter {
    readonly parser: Parser;
    query(source: string): Parser.Query;
    setLanguageName(languageName: LanguageName): void;
    init(): Promise<void>;
}
//# sourceMappingURL=NodeParserAdapter.d.ts.map