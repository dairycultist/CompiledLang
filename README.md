web content serving language (WCSL)

designed to easily process [HTTP Requests](https://www.w3schools.com/tags/ref_httpmethods.asp) (for now just GET and POST)

```
hostname "127.0.0.1";
port 3000;
serve_files_normally false; (* treats files as endpoints that must be manually processed by the programmer *)

onrequest GET(query = "/*.html") {

  respond 200 as "text/html" with readfile(query);
}

onrequest GET(query = "/endpoint?value1=*&value2=*") {

  if (query["value2"] != "cat") {
    respond 404 as "text/plain" with "invalid!";
  }

  respond 200 as "text/plain" with "cat here! you entered " + query["value1"];
}
```

compiler written in OCaml which compiles code down to a [node.js webserver](https://www.geeksforgeeks.org/node-js/node-js-web-server/) (by stealing code from a previous project, hehe)

Compiler that takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce C code
