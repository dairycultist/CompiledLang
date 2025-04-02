# CompiledLang

I should write this in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to a parse tree, interprets that tree to produce NASM code (Mac assembly), assembles it to a binary, and runs it.

[NASM tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)

ASM functions just assume stuff is where it should be, which means you have to set it up so that what it assumes is there *is* there

registers are used for calculations and return values, the stack is used for storing stuff like variables

```
(* data *)
uint8 x = 10;

(* code *)
x = add(x, x);
print(x);
```

```
push 10
push 20
;compiled code inserted for the function call
;accesses x and y by referencing positions in stack relative to stack pointer
pop
pop
```
