#use "tokenizer.ml"
#use "parser.ml"
#use "evaluator.ml"

(*
  eval $(opam env)
  dune utop .
  node temp.js

  gotta find out how to compile the program
*)

let read_whole_file path : string =
    let ch = open_in_bin path in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s

(* let save_str_to_file path str = *)

let compile in_path out_path : unit =
    let _ = print_endline ("Compiled to " ^ out_path) in
    let _ = print_endline (eval (parse (tokenize (read_whole_file in_path)))) in 
    ()

(* run when compiled program is run through the commandline *)
let () =
  if Array.length Sys.argv = 3
    then compile Sys.argv.(1) Sys.argv.(2)
    else print_endline ("Invalid arguments.\nArguments: <in_path>.wsas <out_path>.js")