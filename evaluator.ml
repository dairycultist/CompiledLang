exception DeclareException of string

type environment = (string * string) list (* var * value, such as the hostname/port *)

let rec throw_if_bound env id : unit =
  match env with
  | [] -> ()
  | (s, v)::t -> if s = id then raise (DeclareException("Binding exists (but shouldn't) for: " ^ id)) else throw_if_bound t id

let rec throw_if_unbound env id : unit =
  match env with
  | [] -> raise (DeclareException("Binding doesn't exist (but should) for: " ^ id))
  | (s, v)::t -> if s = id then () else throw_if_unbound t id



let rec eval_expr env t : string =
  ""

let rec eval_stmt_list env s : environment * string =
  ([], "")

(*
  s: stmt list
  return: string representing the corresponding final node.js output
*)
let eval s : string =
  let _ = eval_stmt_list () s in "hi"