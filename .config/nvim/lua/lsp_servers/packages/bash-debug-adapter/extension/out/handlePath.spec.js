"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const handlePath_1 = require("./handlePath");
describe("handlePath - expandPath", () => {
    it("stays undefined if path undefined", () => {
        expect(handlePath_1.expandPath(undefined, "C:\\Users\\wsh\proj0"))
            .toEqual(undefined);
    });
    it("is not replaced if path absolute", () => {
        expect(handlePath_1.expandPath("C:\\Users\\wsh\\proj0\\path\\to\\script.sh", "C:\\Users\\wsh\proj0"))
            .toEqual("C:/Users/wsh/proj0/path/to/script.sh");
    });
    it("is using {workspaceFolder}, on windows", () => {
        expect(handlePath_1.expandPath("{workspaceFolder}\\path\\to\\script.sh", "C:\\Users\\wsh\\proj0"))
            .toEqual("C:/Users/wsh/proj0/path/to/script.sh");
    });
});
describe("handlePath - getWSLPath", () => {
    it("stays undefined if path undefined", () => {
        expect(handlePath_1.getWSLPath(undefined))
            .toEqual(undefined);
    });
    it("does WSL path conversion if windows path", () => {
        expect(handlePath_1.getWSLPath("C:\\Users\\wsh\\proj0\\path\\to\\script.sh"))
            .toEqual("/mnt/c/Users/wsh/proj0/path/to/script.sh");
    });
    it("does no WSL path conversion if path starts with '/'", () => {
        expect(handlePath_1.getWSLPath("/mnt/c/Users/wsh/proj0/path/to/script.sh"))
            .toEqual("/mnt/c/Users/wsh/proj0/path/to/script.sh");
    });
});
describe("handlePath - reverseWSLPath", () => {
    it("reverses WSL path", () => {
        expect(handlePath_1.reverseWSLPath("/mnt/c/Users/wsh/proj0/path/to/script.sh"))
            .toEqual("C:\\Users\\wsh\\proj0\\path\\to\\script.sh");
    });
});
describe("handlePath - escapeCharactersInBashdbArg", () => {
    it("escapes whitespace for setting bashdb arguments with spaces", () => {
        expect(handlePath_1.escapeCharactersInBashdbArg("/pa th/to/script.sh"))
            .toEqual("/pa\\\\0040th/to/script.sh");
    });
});
//# sourceMappingURL=handlePath.spec.js.map