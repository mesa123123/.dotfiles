; extends
;; Match Module Strings as Markdown
(module (expression_statement(string (string_content) @injection.content (#set! injection.language "rst")(#match? @injection.content "########"))) . (import_from_statement))

(module (expression_statement(string (string_content) @injection.content (#set! injection.language "rst")(#match? @injection.content "########"))) . (import_statement))

;; Match string content as sql
(string (string_content) @injection.content (#set! injection.language "sql")(#match? @injection.content "SELECT|INSERT|UPDATE|DELETE|FROM|WHERE|JOIN|CREATE|DROP|ALTER"))

;;; Match strings preceded by a comment directive "TS:sql"
(_ 
  (comment) @_comment  ;; Match a comment
  . 
  ;; Match any string in various contexts
  (block
    [
      ;; Match strings in assignments
      (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "sql"))))
      ;; Match standalone strings
      (expression_statement (string (string_content) @injection.content (#set! injection.language "sql")))
      ;; Match strings as function arguments
      (expression_statement
        (call
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "sql"))
          )
        )
      )
      ;; Match strings in return statements
      (return_statement
        (string (string_content) @injection.content (#set! injection.language "sql"))
      )
      ;; Match strings as default parameter values
      (function_definition
        parameters: (parameters
          (default_parameter
            value: (string (string_content) @injection.content (#set! injection.language "sql"))
          )
        )
      )
    ]
  )
  ;; Ensure the comment matches "TS:sql"
  (#match? @_comment "TS:sql")
)

(_
  (comment) @_comment
  .
      (expression_statement 
        (assignment 
          left: (identifier) 
          right: (call 
            function: (attribute 
              object: (identifier) 
              attribute: (identifier)) 
            arguments: (argument_list 
              (string 
                (string_start) 
                (string_content)  @injection.content (#set! injection.language "sql")
                (string_end)
              )
            )
        ))) 
    (#match? @_comment "TS:sql")
)

;;; Match strings preceded by a comment directive "TS:html"
(_ 
  (comment) @_comment  ;; Match a comment
  . 
  ;; Match any string in various contexts
  (block
    [
      ;; Match strings in assignments
      (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "html"))))
      ;; Match standalone strings
      (expression_statement (string (string_content) @injection.content (#set! injection.language "html")))
      ;; Match strings as function arguments
      (expression_statement
        (call
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "html"))
          )
        )
      )
      ;; Match strings in return statements
      (return_statement
        (string (string_content) @injection.content (#set! injection.language "html"))
      )
      ;; Match strings as default parameter values
      (function_definition
        parameters: (parameters
          (default_parameter
            value: (string (string_content) @injection.content (#set! injection.language "html"))
          )
        )
      )
    ]
  )
  ;; Ensure the comment matches "TS:html"
  (#match? @_comment "TS:html")
)

(_
  (comment) @_comment
  .
      (expression_statement 
        (assignment 
          left: (identifier) 
          right: (call 
            function: (attribute 
              object: (identifier) 
              attribute: (identifier)) 
            arguments: (argument_list 
              (string 
                (string_start) 
                (string_content)  @injection.content (#set! injection.language "html")
                (string_end)
              )
            )
        ))) 
    (#match? @_comment "TS:html")
)


;;; Match strings preceded by a comment directive "TS:jinja"
(_ 
  (comment) @_comment  ;; Match a comment
  . 
  ;; Match any string in various contexts
  (block
    [
      ;; Match strings in assignments
      (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "htmldjango"))))
      ;; Match standalone strings
      (expression_statement (string (string_content) @injection.content (#set! injection.language "htmldjango")))
      ;; Match strings as function arguments
      (expression_statement
        (call
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "htmldjango"))
          )
        )
      )
      ;; Match strings in return statements
      (return_statement
        (string (string_content) @injection.content (#set! injection.language "htmldjango"))
      )
      ;; Match strings as default parameter values
      (function_definition
        parameters: (parameters
          (default_parameter
            value: (string (string_content) @injection.content (#set! injection.language "htmldjango"))
          )
        )
      )
    ]
  )
  ;; Ensure the comment matches "TS:htmldjango"
  (#match? @_comment "TS:jinja")
)

(_
  (comment) @_comment
  .
      (expression_statement 
        (assignment 
          left: (identifier) 
          right: (call 
            function: (attribute 
              object: (identifier) 
              attribute: (identifier)) 
            arguments: (argument_list 
              (string 
                (string_start) 
                (string_content)  @injection.content (#set! injection.language "htmldjango")
                (string_end)
              )
            )
        ))) 
    (#match? @_comment "TS:jinja")
)
;;; Match strings preceded by comment directive "TS:graphql"
(_ 
  (comment) @_comment  ;; match a comment
  . 
  ;; match any string in various contexts
  (block
    [
      ;; match strings in assignments
      (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "graphql"))))
      ;; match standalone strings
      (expression_statement (string (string_content) @injection.content (#set! injection.language "graphql")))
      ;; match strings as function arguments
      (expression_statement
        (call
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "graphql"))
          )
        )
      )

      ;; match strings in return statements
      (return_statement
        (string (string_content) @injection.content (#set! injection.language "graphql"))
      )
      ;; match strings as default parameter values
      (function_definition
        parameters: (parameters
          (default_parameter
            value: (string (string_content) @injection.content (#set! injection.language "graphql"))
          )
        )
      )
    ]
  )
  ;; ensure the comment matches "ts:graphql"
  (#match? @_comment "TS:graphql")
)

(_
  (comment) @_comment
  .
      (expression_statement 
        (assignment 
          left: (identifier) 
          right: (call 
            function: (attribute 
              object: (identifier) 
              attribute: (identifier)) 
            arguments: (argument_list 
              (string 
                (string_start) 
                (string_content)  @injection.content (#set! injection.language "graphql")
                (string_end)
              )
            )
        ))) 
    (#match? @_comment "TS:graphql")
)


;; 
;;; Match strings preceded by a comment directive "TS:json"
(_ 
  (comment) @_comment  ;; match a comment
  . 
  ;; match any string in various contexts
  (block
    [
      ;; match strings in assignments
      (expression_statement (assignment (string (string_content) @injection.content (#set! injection.language "json"))))
      ;; match standalone strings
      (expression_statement (string (string_content) @injection.content (#set! injection.language "json")))
      ;; match strings as function arguments
      (expression_statement
        (call
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "json"))
          )
        )
      )
      ;; match strings in return statements
      (return_statement
        (string (string_content) @injection.content (#set! injection.language "json"))
      )
      ;; match strings as default parameter values
      (function_definition
        parameters: (parameters
          (default_parameter
            value: (string (string_content) @injection.content (#set! injection.language "json"))
          )
        )
      )
    ]
  )
  ;; ensure the comment matches "ts:json"
  (#match? @_comment "TS:json")
)

(_
  (comment) @_comment
  .
      (expression_statement 
        (assignment 
          left: (identifier) 
          right: (call 
            function: (attribute 
              object: (identifier) 
              attribute: (identifier)) 
            arguments: (argument_list 
              (string 
                (string_start) 
                (string_content)  @injection.content (#set! injection.language "json")
                (string_end)
              )
            )
        ))) 
    (#match? @_comment "TS:json")
)

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
