var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
import fg from 'fast-glob';
import fs from 'fs/promises';
import { relative } from 'path';
import url from 'url';
export class NodeFiles {
    constructor(rootUri) {
        this.rootUri = rootUri;
    }
    exists(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                yield fs.stat(new URL(uri));
                return true;
            }
            catch (_a) {
                return false;
            }
        });
    }
    readFile(uri) {
        const path = url.fileURLToPath(uri);
        return fs.readFile(path, 'utf-8');
    }
    findUris(glob) {
        return __awaiter(this, void 0, void 0, function* () {
            const cwd = url.fileURLToPath(this.rootUri);
            const paths = yield fg(glob, { cwd, caseSensitiveMatch: false, onlyFiles: true });
            return paths.map((path) => url.pathToFileURL(path).href);
        });
    }
    relativePath(uri) {
        return relative(new URL(this.rootUri).pathname, new URL(uri).pathname);
    }
}
//# sourceMappingURL=NodeFiles.js.map