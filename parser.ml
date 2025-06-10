#use "tokenizer.ml"

type expr =
  | Var of string
  | Value of string
  (* | Add of expr * expr *)

(* gonna use a list of statements instead of a Seq statement *)
type stmt =
  | Hostname of expr
  | Port of expr
  | OnRequest of expr * expr * expr * stmt list
  | Print of expr 

(* Return types for parse_stmt and parse_expr *)
type stmt_result = token list * stmt list
type expr_result = token list * expr






(* Return the next token in the token list, throwing an error if the list is empty *)
let lookahead (toks : token list) : token =
  match toks with
  | [] -> raise (InvalidInputException "No more tokens")
  | h::_ -> h

(* Matches (and consumes) the next token in the list, throwing an error if it doesn't match the given token *)
let match_token (toks : token list) (tok : token) : token list =
  match toks with
  | [] -> raise (InvalidInputException("Empty list given to match token"))
  | h::t when h = tok -> t
  | h::_ -> raise (InvalidInputException("Unexpected match token"))

let consume_token (toks : token list) : token list =
  match toks with
  | [] -> raise (InvalidInputException("Empty token list when attempting to consume!"))
  | _::t -> t


let parse_expr toks : expr_result = (* good for now, will need to update once operators are added! *)
  let tok = lookahead toks in
  let toks = consume_token toks in
  match tok with
  | Tok_Var(var) ->     (toks, Var(var))
  | Tok_Value(value) -> (toks, Value(value))
  | _ -> raise (InvalidInputException("Came across a non-expression while parsing expressions!"))



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