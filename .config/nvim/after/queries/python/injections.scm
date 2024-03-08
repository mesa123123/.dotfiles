; extends
(_ (comment) @_comment . (block (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "html")))))(#match? @_comment "TS:html"))
(_ (comment) @_comment . (expression_statement (assignment (string(string_content) @injection.content (#set! injection.language "html"))))(#match? @_comment "TS:html"))

(_ (comment) @_comment . (block (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "sql")))))(#match? @_comment "TS:sql"))
(_ (comment) @_comment . (expression_statement (assignment (string(string_content) @injection.content (#set! injection.language "sql"))))(#match? @_comment "TS:sql"))
