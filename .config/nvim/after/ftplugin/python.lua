vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.opt_local.colorcolumn = "90"

local injection_languages = { "html", "jinja", "sql", "json", "graphql" }

local dynamic_query = [[
;;; Match strings preceded by a comment directive "TS:%s"
(
  (comment) @_comment
  .
  [
    (block
      [
        ;; 1. Direct Assignment (x = "...")
        (expression_statement
          (assignment
            right: (string
              (string_content) @injection.content
              (#set! injection.language "%s")
            )
          )
        )
        
        ;; 2. Assignment to a Call (x = Template("..."))
        (expression_statement
          (assignment
            right: (call
              arguments: (argument_list
                (string
                  (string_content) @injection.content
                  (#set! injection.language "%s")
                )
              )
            )
          )
        )

        ;; 3. Standalone Strings (e.g., docstrings)
        (expression_statement
          (string
            (string_content) @injection.content
            (#set! injection.language "%s")
          )
        )
        
        ;; 4. Strings as function arguments (func("..."))
        (expression_statement
          (call
            arguments: (argument_list
              (string
                (string_content) @injection.content
                (#set! injection.language "%s")
              )
            )
          )
        )

        ;; 5. Strings in return statements
        (return_statement
          (string
            (string_content) @injection.content
            (#set! injection.language "%s")
          )
        )
        
        ;; 6. Strings as default parameter values
        (function_definition
          parameters: (parameters
            (default_parameter
              value: (string
                (string_content) @injection.content
                (#set! injection.language "%s")
              )
            )
          )
        )

        ;; 7. Strings as dictionary values (from previous discussion)
        (pair
          value: (string
            (string_content) @injection.content
            (#set! injection.language "%s")
          )
        )
      ]
    )
    
    ;; 8. Direct Assignment (repeated, keeping structure intact)
    (expression_statement
      (assignment
        right: (string
          (string_content) @injection.content
          (#set! injection.language "%s")
        )
      )
    )

    ;; 9. Keyword argument with direct string
    (keyword_argument
      value: (string
        (string_content) @injection.content
        (#set! injection.language "%s")
      )
    )
    
    ;; 10. Keyword argument with string inside a call
    (keyword_argument
      value: (call
        arguments: (argument_list
          (string
            (string_content) @injection.content
            (#set! injection.language "%s")
          )
        )
      )
    )
  ]
  ;; Ensure the comment matches "TS:LANG_NAME"
  (#match? @_comment "TS:%s")
)
]]

local constant_query = [[

;; Match Module Strings as Markdown
(module (expression_statement(string (string_content) @injection.content (#set! injection.language "rst")(#match? @injection.content "########"))) . (import_from_statement))
(module (expression_statement(string (string_content) @injection.content (#set! injection.language "rst")(#match? @injection.content "########"))) . (import_statement))
(module (expression_statement(string (string_content) @injection.content (#set! injection.language "rst")(#match? @injection.content "########"))) . (future_import_statement))

;; Match string content as sql
(string (string_content) @injection.content (#set! injection.language "sql")(#match? @injection.content "SELECT|INSERT|UPDATE|DELETE|FROM|WHERE|JOIN|CREATE|DROP|ALTER"))

(
 (expression_statement 
   (string 
     (string_content) @injection.content
     (#match? @injection.content "^\"\"\"[^\"]")
     )
   )
 (#set! injection.language "rst")
 (#offset! @injection.content 0 3 0 -3)  ; Trim the triple quotes
 )

(call
  function: (attribute
    object: (identifier) @_re)
  arguments: (argument_list
    .
    (string
      (string_content) @injection.content))
  (#eq? @_re "re")
  (#set! injection.language "regex"))

((binary_operator
  left: (string
    (string_content) @injection.content)
  operator: "%")
  (#set! injection.language "printf"))

((comment) @injection.content
  (#set! injection.language "comment"))

]]

local full_query =
  require("config.utils").create_treesitter_injection_query(constant_query, dynamic_query, injection_languages)
vim.treesitter.query.set("markdown", "injections", full_query)
