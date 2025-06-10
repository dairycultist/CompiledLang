let rec parse_stmt toks : stmt_result =
  if toks = [] then
    ([], [])
  else
    let (toks, stmt_list1) = (
      match lookahead toks with
      | Tok_Hostname      -> parse_stmt_hostname toks
      | _ -> raise (InvalidInputException("Came across a non-statement while parsing statements!"))
    ) in
    let (toks, stmt_list2) = parse_stmt toks in
    (toks, (stmt_list1) @ (stmt_list2))

and parse_stmt_hostname toks : stmt_result =
  let toks = match_token toks Tok_Hostname in
  let (toks, expr) = parse_expr toks in
  let toks = match_token toks Tok_Semicolon in
  (toks, [ Hostname(expr) ])