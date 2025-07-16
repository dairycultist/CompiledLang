#use "tokenizer.ml"
#use "parser.ml"

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

let compile path = let _ = print_endline "doing stuff" in parse (tokenize (read_whole_file path))