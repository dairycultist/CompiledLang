exception DeclareException of string

type environment = string list

let rec throw_if_bound env id =
  match env with
  | [] -> ()
  | (s, v)::t -> if s = id then raise (DeclareException("Binding exists (but shouldn't) for: " ^ id)) else throw_if_bound t id

let rec throw_if_unbound env id =
  match env with
  | [] -> raise (DeclareException("Binding doesn't exist (but should) for: " ^ id))
  | (s, v)::t -> if s = id then () else throw_if_unbound t id

let rec eval_expr env t = ()
let rec eval_stmt_list env s : environment = []