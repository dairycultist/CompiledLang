exception DeclareException of string

let rec tabbing tab =
  if tab == 0 then
    ""
  else "    " ^ tabbing (tab - 1)

(*
 * environment declaration and environment helpers
 *)
type environment = (string * string) list (* var * value, such as the hostname/port *)

let rec throw_if_bound env id : unit =
  match env with
  | [] -> ()
  | (s, v)::t -> if s = id then raise (DeclareException("Binding exists (but shouldn't) for: " ^ id)) else throw_if_bound t id

let rec throw_if_unbound env id : unit =
  match env with
  | [] -> raise (DeclareException("Binding doesn't exist (but should) for: " ^ id))
  | (s, v)::t -> if s = id then () else throw_if_unbound t id

let rec get_env_value env id fallback : string =
  match env with
  | [] -> fallback
  | (s, v)::t -> if s = id then v else get_env_value t id fallback

(*
 * return: string representing the corresponding final node.js output for the input expression
 *)
let rec eval_expr expr : string =
  match expr with
  | Var(str) -> str
  | Value(str) -> str

(*
 * return: environment * string representing:
 *         1) all environmental declarations and assignments, such as hostname and port
 *         2) the corresponding final node.js output for the input statement list
 *)
let rec eval_stmt_list env s tab : environment * string =
  match s with
  | [] -> (env, "")
  | h::t ->
    let (env, js1) = (

      match h with
      | Hostname(expr) ->                                         throw_if_bound env "hostname"; (("hostname", eval_expr expr)::env, "")
      | Port(expr) ->                                             throw_if_bound env "port"; (("port", eval_expr expr)::env, "")

      | OnRequest(httpMethod, urlTemplate, body) ->
        let (env, body_str) = (eval_stmt_list env body (tab + 1)) in
        (env, (tabbing tab) ^ "if (req.method == \"" ^ (eval_expr httpMethod) ^ "\" && urlMatchesTemplate(req.url, " ^ (eval_expr urlTemplate) ^ ")) {\n\n" ^ body_str ^ (tabbing tab) ^ "}\n\n")

      | Print(expr) ->                                            (env, (tabbing tab) ^ "console.log(\" · \" + " ^ (eval_expr expr) ^ ");\n")
      | Respond(statusCode, contentType, content, logMessage) ->  (env, (tabbing tab) ^ "respond(res, " ^ (eval_expr statusCode) ^ ", " ^ (eval_expr contentType) ^ ", " ^ (eval_expr content) ^ ", " ^ (eval_expr logMessage) ^ ");\n" ^ (tabbing tab) ^ "return;\n")

    )
    in let (env, js2) = eval_stmt_list env t tab
    in (env, js1 ^ js2)

(*
  s: stmt list
  return: string representing the corresponding final node.js output
*)
let eval s : string =
  let (env, js) = eval_stmt_list [] s 1 in

{|const { createServer } = require('node:http');

const colorDim = "\x1b[2m";
const colorReset = "\x1b[0m";
const colorValue = "\x1b[32m";
const colorError = "\x1b[31m";

|} ^
  ("const hostname = " ^ (get_env_value env "hostname" "localhost") ^ ";\n") ^
  ("const port = " ^ (get_env_value env "port" "3000") ^ ";\n") ^
{|
/*
 * helper functions
 */
function urlMatchesTemplate(url, template) {

    if (url == template) {

        console.log(`${colorDim} · Matches "${template}"`);
        return true;

    } else {
        return false;
    }
}

function respond(res, statusCode, contentType, content, logMessage) {

    // respond
    res.writeHead(statusCode, { "Content-Type": contentType });
    res.end(content);

    // log response
    if (res.statusCode == 200) {

        console.log(`${colorDim}<= [200]: ${logMessage}${colorReset}`);
    } else {
        console.log(`${colorDim}<= [${colorReset + colorError}${res.statusCode}${colorReset + colorDim}]: ${colorReset + colorError}${logMessage}${colorReset}`);
    }
}

/*
 * actual servercode
 */
const server = createServer((req, res) => {

    // log request
    console.log(`${colorDim}=> ${colorReset + colorValue}${req.method} ${req.url}${colorReset}`);
    
    // generated from WSAS
|} ^ js ^ {|    // default response if all else fails
    respond(res, 400, "text/plain", "Error 400: Bad request.", "Bad request.");
});

server.listen(port, hostname, () => {

    console.log(`${colorDim}Started WSAS (a1.0) server @ ${colorReset + colorValue}http://${hostname}:${port}/${colorReset}`);
});
|}