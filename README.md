![Banner with the Sapphire programming language logo](banner.png)

sapphire - a low(ish) level, strongly-typed programming language that compiles down to C. compiler written in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce C code

```
print("What is your name? ");

byte[] name = read_str();
int8 name_length = bytecount(name) - 1;

print("Your name is " + name + ". It is " + name_length + " characters long.");
print("The first character is " + name[0] + ".");
print("Its unicode value is " + bytes_as_int8(name, 0) + ".");
```
