#use "tokenizer.ml"
#use "parser.ml"
#use "evaluator.ml"

(*
  eval $(opam env)
  dune runtest -f
  dune utop src
*)

let read_whole_file path =
    let ch = open_in_bin path in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s

let compile path = eval (parse (tokenize (read_whole_file path)))