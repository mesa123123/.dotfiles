import WasmParser from 'web-tree-sitter';
import { LanguageName, ParserAdapter } from '../language/types.js';
export declare class WasmParserAdapter implements ParserAdapter {
    private readonly wasmBaseUrl;
    parser: WasmParser;
    private languages;
    constructor(wasmBaseUrl: string);
    init(): Promise<void>;
    query(source: string): WasmParser.Query;
    setLanguageName(languageName: LanguageName): void;
}
//# sourceMappingURL=WasmParserAdapter.d.ts.map