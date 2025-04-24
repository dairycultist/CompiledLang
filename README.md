![Banner with the Sapphire programming language logo](banner.png)

sapphire - high level, strongly-typed programming language that compiles down to C. compiler written in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce C code

```
for (int x = 0->16 | int y = 0->16) {
  print(x + " " + y);
}
```

```
type Vec2(int, int);

Vec2 first = Vec2(10, 20);
* second = first;

print(first[0] + first[1]);

match (second) {
  Vec2 -> print(second[0] + second[1]);
}
```
