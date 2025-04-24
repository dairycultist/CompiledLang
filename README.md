![Banner with the Sapphire programming language logo](banner.png)

sapphire - a high(ish) level, strongly-typed programming language that compiles down to C. compiler written in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce C code

```
print("What is your name? >");

string name = read_str();
int name_length = strlen(name);

print("Your name is [#]. It is [#] characters long.\n", name, name_length);
```

<type> ::= `int` | `string` | `bool`

<variable> ::= `/[a-zA-Z0-9_]+/g`

<declaration> ::= <type> <variable> = <expression>; | <type> <variable>;

<statement> ::= <declaration> | ...

<expression> ::= ...
