import { Expression } from '@cucumber/cucumber-expressions';
import { Diagnostic } from 'vscode-languageserver-types';
export declare function getGherkinDiagnostics(gherkinSource: string, expressions: readonly Expression[]): Diagnostic[];
export declare function makeUndefinedStepDiagnostic(line: number, character: number, stepKeyword: string, stepText: string, snippetKeyword: string): Diagnostic;
//# sourceMappingURL=getGherkinDiagnostics.d.ts.map