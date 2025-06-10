web content serving language (WCSL)

designed to easily process [HTTP Requests](https://www.w3schools.com/tags/ref_httpmethods.asp) (for now just GET and POST)

```
hostname "127.0.0.1";
port 3000;
auto_serve_files false; (* treats file requests as endpoints that must be manually processed by the programmer, rather than just responding with the file *)

onrequest GET "(filename).html" {

  respond 200 as "text/html" with readfile("src/" + filename + ".html");
}

onrequest GET(query = "/endpoint?value1=(msg)&value2=()") {

  if (msg == "I hate cats") {
    respond 404 as "text/plain" with "You can't say that!";
  }

  respond 200 as "text/plain" with "Cat here! You said " + msg;
}
```

`(name)` in a request description is a wildcard that matches to a variable named `name`. You can also use `()` for a wildcard that doesn't need to be assigned to a variable.

compiler written in OCaml which compiles code down to a [node.js webserver](https://www.geeksforgeeks.org/node-js/node-js-web-server/) (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce node.js code
