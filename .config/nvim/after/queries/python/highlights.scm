; extends

(module (expression_statement(string) @injection.content (#set! injection.language "markdown")) . (import_from_statement))
(
  (identifier) @constant
  (#match? @constant "^_?[A-Z][A-Z0-9_]*$")
) @constant.python
