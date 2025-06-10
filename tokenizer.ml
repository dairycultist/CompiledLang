#require "re"
open Re

(* https://ocaml.org/p/re/latest/doc/Re/Str/index.html *)

(*
  eval $(opam env)
  dune runtest -f
  dune utop src
*)

exception InvalidInputException of string

type token =
  | Tok_Hostname
  | Tok_Semicolon
  | Tok_Var of string
  | Tok_Value of string
  | EOF


let re_match regex input = Re.Str.string_match (Re.Str.regexp regex) input 0
let re_remove regex input = Re.Str.substitute_first (Re.Str.regexp ("\\(" ^ regex ^ "\\)[ \t\n]*")) (fun s -> "") input

(* tokenize that takes No Initial Whitespace *)
let rec tokenize_niw input =

  if String.length input = 0 then [EOF]

  (* keywords and identifiers *)
  else if re_match "[a-zA-Z][a-zA-Z0-9]*" input then
    match Re.Str.matched_string input with
    | "true" -> (Tok_Value "true")                 ::(tokenize_niw (re_remove "true" input))
    | "false" -> (Tok_Value "false")               ::(tokenize_niw (re_remove "false" input))
    | "hostname" -> (Tok_Hostname)                 ::(tokenize_niw (re_remove "hostname" input))
    | var -> (Tok_Var var)                         ::(tokenize_niw (re_remove var input))

  (* string *)
  else if re_match "\"([^\"\\]|\\.|\\\n)*\"" input then
    (Tok_Value (Re.Str.matched_string input))      ::(tokenize_niw (re_remove "\"([^\"\\]|\\.|\\\n)*\"" input))

  (* numbers *)
  else if re_match "-?[0-9]+" input then
    (Tok_Value (Re.Str.matched_string input))      ::(tokenize_niw (re_remove "-?[0-9]+" input))
  
  (* non alphanumeric *)
  else if re_match ";" input then Tok_Semicolon    ::(tokenize_niw (re_remove ";" input))

  (* else if re_match "-" input then Tok_Sub::(tokenize_niw (re_remove "-" input))
  else if re_match "(" input then Tok_LParen::(tokenize_niw (re_remove "(" input))
  else if re_match ")" input then Tok_RParen::(tokenize_niw (re_remove ")" input))
  else if re_match "{" input then Tok_LBrace::(tokenize_niw (re_remove "{" input))
  else if re_match "}" input then Tok_RBrace::(tokenize_niw (re_remove "}" input))
  else if re_match "\\^" input then Tok_Pow::(tokenize_niw (re_remove "\\^" input))
  else if re_match "\\+" input then Tok_Add::(tokenize_niw (re_remove "\\+" input))
  else if re_match "&&" input then Tok_And::(tokenize_niw (re_remove "&&" input))
  else if re_match "||" input then Tok_Or::(tokenize_niw (re_remove "||" input))
  else if re_match "!=" input then Tok_NotEqual::(tokenize_niw (re_remove "!=" input))
  else if re_match "!" input then Tok_Not::(tokenize_niw (re_remove "!" input))
  else if re_match "\\*" input then Tok_Mult::(tokenize_niw (re_remove "\\*" input))
  else if re_match "<=" input then Tok_LessEqual::(tokenize_niw (re_remove "<=" input))
  else if re_match "<" input then Tok_Less::(tokenize_niw (re_remove "<" input))
  else if re_match ">=" input then Tok_GreaterEqual::(tokenize_niw (re_remove ">=" input))
  else if re_match ">" input then Tok_Greater::(tokenize_niw (re_remove ">" input))
  else if re_match "==" input then Tok_Equal::(tokenize_niw (re_remove "==" input))
  else if re_match "/" input then Tok_Div::(tokenize_niw (re_remove "/" input))
  else if re_match "=" input then Tok_Assign::(tokenize_niw (re_remove "=" input)) *)

  else raise (InvalidInputException("Could not tokenize: " ^ input))

let rec tokenize input =
  tokenize_niw (Re.Str.substitute_first (Re.Str.regexp ("[ \t\n]*")) (fun s -> "") input)