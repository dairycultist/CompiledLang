# Web Server Architecture Script (WSAS)

Designed to easily process [HTTP requests](https://www.w3schools.com/tags/ref_httpmethods.asp) (for now just GET and POST) and perform routine (scheduled) actions.

Compiler written in OCaml which takes in a text file, tokenizes it, parses it to an AST, and interprets that tree to produce [node.js webserver code](https://www.geeksforgeeks.org/node-js/node-js-web-server/).

## Meta statements

The following are meta statements, which inform your server on how it should run. For tidiness, these should be placed at the very top of your file.

```
hostname "127.0.0.1";
port 3000;
auto_serve_files false;
```

- `hostname` is the IP of your server. This defaults to `localhost` if unspecified.
- `port` is the port of your server. This defaults to `443` (the standard for HTTPS) if unspecified.
- If `auto_serve_files` is true, any requests for files will respond with the file instead of passing onto an `onrequest` function. If false, file requests are treated as endpoints that must be manually processed by the programmer. `auto_serve_files` defaults to true if unspecified.

## On Request functions

```
onrequest GET "(filename).html" {

  respond 200 as "text/html" with readfile("src/" + filename + ".html");
}

onrequest GET "/endpoint?value1=(msg)&value2=()" {

  if (msg == "I hate cats") {
    respond 404 as "text/plain" with "You can't say that!";
  }

  respond 200 as "text/plain" with "Cat here! You said " + msg;
}

onrequest GET "()" {

  respond 404 as "text/html" with replace(readfile("src/404.html"), "<message>", "Get request did not match any endpoint.");
}
```

`(name)` in a request description is a wildcard that matches to a variable named `name`. You can also use `()` for a wildcard that doesn't need to be assigned to a variable.

If a request would be accepted by multiple `onrequest` functions, the topmost one is selected.

Any request that is not accepted by any `onrequest` function is responded to with `404.html`, if it exists.

## On Schedule functions
