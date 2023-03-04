import { CucumberExpressions, ParserAdapter, Suggestion } from '@cucumber/language-service';
import { Connection, ServerCapabilities, TextDocuments } from 'vscode-languageserver';
import { TextDocument } from 'vscode-languageserver-textdocument';
import { Files } from './Files.js';
type ServerInfo = {
    name: string;
    version: string;
};
export declare class CucumberLanguageServer {
    private readonly connection;
    private readonly documents;
    private readonly makeFiles;
    private readonly onReindexed;
    private readonly expressionBuilder;
    private searchIndex;
    private expressionBuilderResult;
    private reindexingTimeout;
    private rootUri;
    private files;
    registry: CucumberExpressions.ParameterTypeRegistry;
    expressions: readonly CucumberExpressions.Expression[];
    suggestions: readonly Suggestion[];
    constructor(connection: Connection, documents: TextDocuments<TextDocument>, parserAdapter: ParserAdapter, makeFiles: (rootUri: string) => Files, onReindexed: (registry: CucumberExpressions.ParameterTypeRegistry, expressions: readonly CucumberExpressions.Expression[], suggestions: readonly Suggestion[]) => void);
    capabilities(): ServerCapabilities;
    info(): ServerInfo;
    private sendDiagnostics;
    private scheduleReindexing;
    private getSettings;
    private reindex;
}
export {};
//# sourceMappingURL=CucumberLanguageServer.d.ts.map