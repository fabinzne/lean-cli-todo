import Lean.Data.Json

open Lean Json ToJson FromJson

structure Todo where
  make ::
  name : String
  done : Bool
deriving ToJson, FromJson

def writeTodosFile (todos : List Todo): IO Unit := do
  let jsonContent := toJson todos
  IO.FS.writeFile "todos.json" (toString jsonContent)

def readTodoListFromFile: IO (Except String (List Todo)) := do
  let content <- IO.FS.readFile "todos.json"
  match Lean.Json.parse content with
  | .ok json =>
    match fromJson? json with
    | .ok value => return .ok value
    | .error err => return .error err
  | .error err => return .error err

def listTodos: IO (Except String (List Todo)) := do
  try
    let result <- readTodoListFromFile
    match result with
    | .ok todos => return .ok todos
    | .error err => return .error err
  catch e =>
    return .error s!"Error on listTodos function: {e.toString}"

def readTodo (name : String): IO (Except String Todo) := do
  try
    let result <- readTodoListFromFile
    match result with
    | .ok todos =>
      match List.find? (fun (todo) => todo.name == name) todos with
        | some todo => return .ok todo
        | none => return .error s!"No todo found on this list."
    | .error err => return .error err
  catch e =>
    return .error s!"Error on readTodo function: {e.toString}"

def createTodo (name : String): IO (Except String (List Todo)) := do
  try
    let newTodo := Todo.make name false
    let result <- readTodoListFromFile
    match result with
    | .ok todos =>
      let updatedTodos := newTodo :: todos
      writeTodosFile updatedTodos
      return .ok updatedTodos
    | .error err => return .error err
  catch e =>
    return .error s!"Error on createTodo function: {e.toString}"

def updateTodo (name : String) (status : Bool): IO (Except String (List Todo)) := do
  try
    let result <- readTodoListFromFile
    match result with
    | .ok todos =>
      let updatedTodos := List.map (fun (todo) => if todo.name == name then Todo.make todo.name status else todo) todos
      writeTodosFile updatedTodos
      return .ok updatedTodos
    | .error err => return .error err
  catch e =>
    return .error s!"Error on updateTodo function: {e.toString}"
