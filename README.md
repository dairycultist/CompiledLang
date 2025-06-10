web content serving language (WCSL)

designed to easily process [HTTP Requests](https://www.w3schools.com/tags/ref_httpmethods.asp) (for now just GET and POST)

```
onrequest GET(query = "/*.html") {

  return FILE(query);
}

onrequest GET(query = "/endpoint?value1=*&value2=*") {

  return HTML("<body>you entered " + value1 + "</body>");
}
```

written in OCaml and compiles down to a [C webserver](https://gist.github.com/laobubu/d6d0e9beb934b60b2e552c2d03e1409e)

![Banner with the Sapphire programming language logo](banner.png)

sapphire - a high(ish) level, strongly-typed programming language that compiles down to C. compiler written in OCaml (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce C code

garbage collection -- gotta store how many references to an object there are, and whenever it decrements see if we should free the memory

```
print("What is your name? >");

string name = read_str();
int name_length = strlen(name);

print("Your name is [#]. It is [#] characters long.\n", name, name_length);
```

```
<type> ::= int | string | bool

<variable> ::= /[a-zA-Z0-9_]+/g

<declaration> ::= <type> <variable> = <expression>; | <type> <variable>;

<assignment> ::= <variable> = <expression>;

<print> ::= (print <expression>)

<statement> ::= <declaration> | <assignment> | <print>

<expression> ::= (/[+-*/]|and|or/g <expression> <expression>) | (not <expression>) | /"[^"]*"/g | /[0-9]+/g | /true|false/g
```
