import { Expression } from '@cucumber/cucumber-expressions';
import { SemanticTokens, SemanticTokenTypes } from 'vscode-languageserver-types';
export declare const semanticTokenTypes: SemanticTokenTypes[];
export declare function getGherkinSemanticTokens(gherkinSource: string, expressions: readonly Expression[]): SemanticTokens;
//# sourceMappingURL=getGherkinSemanticTokens.d.ts.map