;; Inject YAML for front matter at the top of a Markdown file
;; Inject YAML for front matter at the top of a Markdown file
((front_matter) @yaml)


(fenced_code_block
(fenced_code_block_delimiter)
(info_string
(language) @_language)
(code_fence_content) @injection.content
(fenced_code_block_delimiter) (#set! injection.language "%s"))

