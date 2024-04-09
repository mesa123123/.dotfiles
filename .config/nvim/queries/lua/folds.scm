; extends
[  
((
  (comment (comment_content) @content1 (#contains? @content1 "Section"))
  .(comment (comment_content) @content2 (#match?  @content2 "--------"))
  .(_)+
  .(comment (comment_content) @content3 (#match? @content3 "--------"))
)) 
(assignment_statement)
 ] @fold

