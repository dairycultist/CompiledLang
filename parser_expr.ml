type expr =
  | Var of string
  | Value of string
  (* | Add of expr * expr *)

type expr_result = token list * expr



let parse_expr toks : expr_result = (* good for now, will need to update once operators are added! *)
  let tok = lookahead toks in
  let toks = consume_token toks in
  match tok with
  | Tok_Var(var) ->     (toks, Var(var))
  | Tok_Value(value) -> (toks, Value(value))
  | _ -> raise (InvalidInputException("Came across a non-expression while parsing expressions!"))
