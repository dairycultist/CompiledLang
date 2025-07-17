exception DeclareException of string

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
let rec eval_stmt_list env s : environment * string =
  match s with
  | [] -> (env, "")
  | h::t ->
    let (env, js1) = (

      match h with
      | Hostname(expr) ->                                         throw_if_bound env "hostname"; (("hostname", eval_expr expr)::env, "")
      | Port(expr) ->                                             throw_if_bound env "port"; (("port", eval_expr expr)::env, "")
      | OnRequest(httpMethod, urlTemplate, s) ->                  (env, "onrequest\n")
      | Print(expr) ->                                            (env, "print\n")
      | Respond(statusCode, contentType, content, logMessage) ->  (env, "respond\n")

    )
    in let (env, js2) = eval_stmt_list env t
    in (env, js1 ^ js2)

(*
  s: stmt list
  return: string representing the corresponding final node.js output
*)
let eval s : string =
  let (env, js) = eval_stmt_list [] s in

{|const { createServer } = require('node:http');

const colorDim = "\x1b[2m";
const colorReset = "\x1b[0m";
const colorValue = "\x1b[32m";
const colorError = "\x1b[31m";
|} ^
  ("const hostname = " ^ (get_env_value env "hostname" "localhost") ^ ";\n") ^
  ("const port = " ^ (get_env_value env "port" "3000") ^ ";\n\n") ^
  js