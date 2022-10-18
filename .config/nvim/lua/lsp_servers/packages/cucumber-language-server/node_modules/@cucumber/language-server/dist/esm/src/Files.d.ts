export interface Files {
    exists(uri: string): Promise<boolean>;
    readFile(uri: string): Promise<string>;
    findUris(glob: string): Promise<readonly string[]>;
    relativePath(uri: string): string;
}
export declare function extname(uri: string): string;
//# sourceMappingURL=Files.d.ts.map