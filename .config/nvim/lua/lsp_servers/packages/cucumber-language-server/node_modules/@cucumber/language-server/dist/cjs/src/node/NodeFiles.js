"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NodeFiles = void 0;
const fast_glob_1 = __importDefault(require("fast-glob"));
const promises_1 = __importDefault(require("fs/promises"));
const path_1 = require("path");
const url_1 = __importDefault(require("url"));
class NodeFiles {
    constructor(rootUri) {
        this.rootUri = rootUri;
    }
    exists(uri) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                yield promises_1.default.stat(new URL(uri));
                return true;
            }
            catch (_a) {
                return false;
            }
        });
    }
    readFile(uri) {
        const path = url_1.default.fileURLToPath(uri);
        return promises_1.default.readFile(path, 'utf-8');
    }
    findUris(glob) {
        return __awaiter(this, void 0, void 0, function* () {
            const cwd = url_1.default.fileURLToPath(this.rootUri);
            const paths = yield (0, fast_glob_1.default)(glob, { cwd, caseSensitiveMatch: false, onlyFiles: true });
            return paths.map((path) => url_1.default.pathToFileURL(path).href);
        });
    }
    relativePath(uri) {
        return (0, path_1.relative)(new URL(this.rootUri).pathname, new URL(uri).pathname);
    }
}
exports.NodeFiles = NodeFiles;
//# sourceMappingURL=NodeFiles.js.map