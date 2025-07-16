type stmt =
  | Hostname of expr
  | Port of expr
  | OnRequest of expr * expr * stmt list
  | Print of expr
  | Respond of expr * expr * expr * expr

type stmt_result = token list * stmt list



let rec parse_stmt toks : stmt_result =

  if toks = [] then (* EOF *)
    ([], [])
  else

  if lookahead toks = Tok_CloseCurly then (* closing a block *)
    (toks, [])
  else

  (* use upcoming token to anticipate next stmt type *)
  let (toks, stmt_list1) = (
    match lookahead toks with
    | Tok_Hostname      -> parse_stmt_hostname toks
    | Tok_Port          -> parse_stmt_port toks
    | Tok_OnRequest     -> parse_stmt_on_request toks
    | Tok_Respond       -> parse_stmt_respond toks
    | _ -> raise (InvalidInputException("Came across a non-statement while parsing statements!"))
  ) in
  let (toks, stmt_list2) = parse_stmt toks in
  (toks, (stmt_list1) @ (stmt_list2))



and parse_stmt_hostname toks : stmt_result =
  let toks = match_token toks Tok_Hostname in
  let (toks, expr) = parse_expr toks in
  let toks = match_token toks Tok_Semicolon in
  (toks, [ Hostname(expr) ])

and parse_stmt_port toks : stmt_result =
  let toks = match_token toks Tok_Port in
  let (toks, expr) = parse_expr toks in
  let toks = match_token toks Tok_Semicolon in
  (toks, [ Port(expr) ])

and parse_stmt_on_request toks : stmt_result =
  let toks = match_token toks Tok_OnRequest in
  let (toks, expr1) = parse_expr toks in (* GET/POST *)
  let (toks, expr2) = parse_expr toks in (* query string *)
  let toks = match_token toks Tok_OpenCurly in
  let (toks, stmt_list) = parse_stmt toks in
  let toks = match_token toks Tok_CloseCurly in
  (toks, [ OnRequest(expr1, expr2, stmt_list) ])

and parse_stmt_respond toks : stmt_result =
  let toks = match_token toks Tok_Respond in
  let (toks, statusCode) = parse_expr toks in
  let toks = match_token toks Tok_RespondAs in
  let (toks, contentType) = parse_expr toks in
  let toks = match_token toks Tok_RespondWith in
  let (toks, content) = parse_expr toks in
  let toks = match_token toks Tok_RespondLog in (* should be optional! *)
  let (toks, logMessage) = parse_expr toks in
  let toks = match_token toks Tok_Semicolon in
  (toks, [ Respond(statusCode, contentType, content, logMessage) ])