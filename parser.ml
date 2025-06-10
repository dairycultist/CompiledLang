(*
 * This file contains helper functions for the files parser_stmt.ml and parser_expr.ml,
 * as well as a parse function that takes in a list of tokens and returns a list of statements
 * in order of execution.
 *)

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
;;


#use "parser_expr.ml"
#use "parser_stmt.ml"

let parse toks : stmt list = let (_, stmt_list) = parse_stmt toks in stmt_list