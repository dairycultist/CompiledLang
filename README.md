![Banner with the Sapphire programming language logo](banner.png)

sapphire - high level, strongly-typed programming language that compiles down to C. compiler written in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce C code

```
for int32 x between [0,16) {
  print(x);
}

for string x in ["cat", "dog", "fish"] {
  print(x);
}
```
