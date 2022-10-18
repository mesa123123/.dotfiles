"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const bashRuntime_1 = require("./bashRuntime");
describe("bashRuntime - validatePath", () => {
    it("returns proper error message when wrong cwd", () => {
        expect(bashRuntime_1.validatePath("non-exist-directory", "bash", "type", "type", "type", "type"))
            .toContain("Error: cwd (non-exist-directory) does not exist.\n");
    });
    it("returns empty message if correct data ", () => {
        expect(bashRuntime_1.validatePath("./", "bash", "type", "type", "type", "type"))
            .toEqual("");
    });
});
describe("bashRuntime - _validatePath", () => {
    it("returns success when all data correct", () => {
        expect(bashRuntime_1._validatePath("./", "bash", "type", "type", "type", "type"))
            .toEqual([bashRuntime_1.validatePathResult.success, ""]);
    });
    it("returns notExistCwd when cwd incorrect", () => {
        expect(bashRuntime_1._validatePath("non-exist-directory", "bash", "type", "type", "type", "type"))
            .toEqual([bashRuntime_1.validatePathResult.notExistCwd, ""]);
    });
    it("returns notFoundBash when bash path incorrect", () => {
        expect(bashRuntime_1._validatePath("./", "invalid-bash-path", "type", "type", "type", "type"))
            .toEqual([bashRuntime_1.validatePathResult.notFoundBash, ""]);
    });
    it("returns notFoundBashdb when bashdb path incorrect", () => {
        expect(bashRuntime_1._validatePath("./", "bash", "invalid-bashdb-path", "type", "type", "type"))
            .toEqual([bashRuntime_1.validatePathResult.notFoundBashdb, "bash: line 0: type: invalid-bashdb-path: not found\n"]);
    });
    it("returns notFoundCat when cat path incorrect", () => {
        expect(bashRuntime_1._validatePath("./", "bash", "type", "invalid-cat-path", "type", "type"))
            .toEqual([bashRuntime_1.validatePathResult.notFoundCat, "bash: line 0: type: invalid-cat-path: not found\n"]);
    });
    it("returns notFoundMkfifo when mkfifo path incorrect", () => {
        expect(bashRuntime_1._validatePath("./", "bash", "type", "type", "invalid-mkfifo-path", "type"))
            .toEqual([bashRuntime_1.validatePathResult.notFoundMkfifo, "bash: line 0: type: invalid-mkfifo-path: not found\n"]);
    });
    it("returns notFoundPkill when pkill path incorrect", () => {
        expect(bashRuntime_1._validatePath("./", "bash", "type", "type", "type", "invalid-pkill-path"))
            .toEqual([bashRuntime_1.validatePathResult.notFoundPkill, "bash: line 0: type: invalid-pkill-path: not found\n"]);
    });
    it("returns notFoundBash when all data incorrect", () => {
        expect(bashRuntime_1._validatePath("invalid-path", "invalid-path", "invalid-path", "invalid-path", "invalid-path", "invalid-path"))
            .toEqual([bashRuntime_1.validatePathResult.notFoundBash, ""]);
    });
    it("returns timeout when timeout", () => {
        expect(bashRuntime_1._validatePath("./", "bash", "", "", "", "", 1))
            .toEqual([bashRuntime_1.validatePathResult.timeout, ""]);
    });
});
//# sourceMappingURL=bashRuntime.spec.js.map