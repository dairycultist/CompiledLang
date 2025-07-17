#require "re"
open Re (* https://ocaml.org/p/re/latest/doc/Re/Str/index.html *)

exception InvalidInputException of string

type token =
  | Tok_Hostname
  | Tok_Port
  | Tok_OnRequest
  | Tok_Respond
  | Tok_RespondAs
  | Tok_RespondWith
  | Tok_RespondLog
  | Tok_Semicolon
  | Tok_OpenCurly
  | Tok_CloseCurly
  | Tok_OpenParen
  | Tok_CloseParen
  | Tok_Assign
  | Tok_Var of string
  | Tok_Value of string (* includes all strings literals, numbers, booleans, and keywords GET and POST *)

(* let string_of_token (t : token) : string = match t with
  | Tok_For -> "Tok_For" *)

let re_match regex input = Re.Str.string_match (Re.Str.regexp regex) input 0
let re_remove regex input = Re.Str.substitute_first (Re.Str.regexp ("\\(" ^ regex ^ "\\)[ \t\n]*")) (fun s -> "") input

(* tokenize that takes No Initial Whitespace *)
let rec tokenize_niw input =

  if String.length input = 0 then []

  (* values *)
  else if re_match "\"[^\"]*\"\|-?[0-9]+\|true\|false\|GET\|POST" input then
    let x = Re.Str.matched_string input in
    (Tok_Value x)::(tokenize_niw (re_remove "\"[^\"]*\"\|-?[0-9]+\|true\|false\|GET\|POST" input))

  (* keywords and variables *)
  else if re_match "[a-zA-Z][a-zA-Z0-9]*" input then
    let x = Re.Str.matched_string input in
    (
      match x with
      | "hostname"          -> Tok_Hostname
      | "port"              -> Tok_Port
      | "onrequest"         -> Tok_OnRequest
      | "respond"           -> Tok_Respond
      | "as"                -> Tok_RespondAs
      | "with"              -> Tok_RespondWith
      | "log"               -> Tok_RespondLog
      | var                 -> Tok_Var var
    )::(tokenize_niw (re_remove x input))
  
  (* non alphanumeric *)
  else if re_match ";" input then Tok_Semicolon    ::(tokenize_niw (re_remove ";" input))
  else if re_match "{" input then Tok_OpenCurly    ::(tokenize_niw (re_remove "{" input))
  else if re_match "}" input then Tok_CloseCurly   ::(tokenize_niw (re_remove "}" input))
  else if re_match "(" input then Tok_OpenParen    ::(tokenize_niw (re_remove "(" input))
  else if re_match ")" input then Tok_CloseParen   ::(tokenize_niw (re_remove ")" input))
  else if re_match "=" input then Tok_Assign       ::(tokenize_niw (re_remove "=" input))

  else raise (InvalidInputException("Could not tokenize: " ^ input))

let rec tokenize input =
  tokenize_niw (Re.Str.substitute_first (Re.Str.regexp ("[ \t\n]*")) (fun s -> "") input)