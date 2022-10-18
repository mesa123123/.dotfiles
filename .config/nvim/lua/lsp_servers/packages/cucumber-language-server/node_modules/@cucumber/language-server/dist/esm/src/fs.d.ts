import { LanguageName, Source } from '@cucumber/language-service';
import { Files } from './Files.js';
export declare const glueExtByLanguageName: Record<LanguageName, string[]>;
export declare function loadGlueSources(files: Files, globs: readonly string[]): Promise<readonly Source<LanguageName>[]>;
export declare function getLanguage(ext: string): LanguageName | undefined;
export declare function loadGherkinSources(files: Files, globs: readonly string[]): Promise<readonly Source<'gherkin'>[]>;
export declare function findUris(files: Files, globs: readonly string[]): Promise<readonly string[]>;
//# sourceMappingURL=fs.d.ts.map