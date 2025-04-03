# CompiledLang

I should write this in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, interprets that tree to produce NASM code (Mac assembly), assembles it to a binary, and runs it.

```
(* data *)
uint8 x = 10;

(* code *)
x = add(x, x);
print(x);
```