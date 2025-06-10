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
  | Tok_Port
  | Tok_OnRequest
  | Tok_Semicolon
  | Tok_OpenCurly
  | Tok_CloseCurly
  | Tok_OpenParen
  | Tok_CloseParen
  | Tok_Equal
  | Tok_Var of string
  | Tok_Value of string
  | Tok_HTTPRequest of string
  | EOF


let re_match regex input = Re.Str.string_match (Re.Str.regexp regex) input 0
let re_remove regex input = Re.Str.substitute_first (Re.Str.regexp ("\\(" ^ regex ^ "\\)[ \t\n]*")) (fun s -> "") input

(* tokenize that takes No Initial Whitespace *)
let rec tokenize_niw input =

  if String.length input = 0 then [EOF]

  (* string literals and numbers *)
  else if re_match "\"[^\"]*\"\|-?[0-9]+\|true\|false" input then
    let x = Re.Str.matched_string input in
    (Tok_Value x)::(tokenize_niw (re_remove "\"[^\"]*\"\|-?[0-9]+\|true\|false" input))

  (* keywords and variables *)
  else if re_match "[a-zA-Z][a-zA-Z0-9]*" input then
    let x = Re.Str.matched_string input in
    (
      match x with
      | "GET" | "POST"      -> Tok_HTTPRequest x
      | "hostname"          -> Tok_Hostname
      | "port"              -> Tok_Port
      | "onrequest"         -> Tok_OnRequest
      | var                 -> Tok_Var var
    )::(tokenize_niw (re_remove x input))
  
  (* non alphanumeric *)
  else if re_match ";" input then Tok_Semicolon    ::(tokenize_niw (re_remove ";" input))
  else if re_match "{" input then Tok_OpenCurly    ::(tokenize_niw (re_remove "{" input))
  else if re_match "}" input then Tok_CloseCurly   ::(tokenize_niw (re_remove "}" input))
  else if re_match "(" input then Tok_OpenParen    ::(tokenize_niw (re_remove "(" input))
  else if re_match ")" input then Tok_CloseParen   ::(tokenize_niw (re_remove ")" input))
  else if re_match "=" input then Tok_Equal        ::(tokenize_niw (re_remove "=" input))

  else raise (InvalidInputException("Could not tokenize: " ^ input))

let rec tokenize input =
  tokenize_niw (Re.Str.substitute_first (Re.Str.regexp ("[ \t\n]*")) (fun s -> "") input)