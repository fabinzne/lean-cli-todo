import TodoList

def padString (s : String) (width : Nat) : String :=
  let len := s.length
  if len >= width then s.take width
  else s ++ String.mk (List.replicate (width - len) ' ')

def printTableHeader : IO Unit := do
  IO.println s!"┌─────┬──────────────────────────────────┬────────────┐"
  IO.println s!"│ #   │ Name                             │ Status     │"
  IO.println s!"├─────┼──────────────────────────────────┼────────────┤"

def printTableFooter : IO Unit := do
  IO.println "└─────┴──────────────────────────────────┴────────────┘"

def printTodoRow (index: Nat) (todo : Todo) : IO Unit := do
  let indexStr := padString (toString index) 3
  let nameStr := padString todo.name 32
  let statusStr := if todo.done then "✓ Done    " else "○ Pending "
  IO.println s!"│ {indexStr} │ {nameStr} │ {statusStr} │"

def printTodosTable (todos : List Todo) : IO Unit := do
  if todos.isEmpty then
    IO.println s!"No todos found."
  else
    printTableHeader
    for (todo, i) in todos.zipIdx do
      printTodoRow (i + 1) todo
    printTableFooter
    IO.println s!"Total: {todos.length} todo(s)"

def main(args : List String): IO Unit := do
  match args with
  | ["help"] => do
    IO.println "Todo CLI"
    IO.println "Usage:"
    IO.println "  list                    - List all todos in table format"
    IO.println "  read <name>            - Show specific todo in table format"
    IO.println "  create <name>          - Create a new todo"
    IO.println "  update <name> <status> - Update todo status (true/false)"
    IO.println ""
    IO.println "Examples:"
    IO.println "  ./todo list"
    IO.println "  ./todo create \"Learn Lean 4\""
    IO.println "  ./todo read \"Learn Lean 4\""
    IO.println "  ./todo update \"Learn Lean 4\" true"

  | ["list"] => do
    let result <- listTodos
    match result with
    | .ok todos => printTodosTable todos
    | .error err => IO.println s!"Error listing todos: {err}"

  | ["read", name] => do
    let result <- readTodo name
    match result with
    | .ok todo => printTodosTable [todo]
    | .error err => IO.println s!"Error reading todo: {err}"

  | ["create", name] => do
    let result <- createTodo name
    match result with
    | .ok todos => printTodosTable todos
    | .error err => IO.println s!"Error creating todo: {err}"

  | ["update", name, status] => do
    let boolStatus := status == "true"
    let result <- updateTodo name boolStatus
    match result with
    | .ok todos => printTodosTable todos
    | .error err => IO.println s!"Error updating todo: {err}"

  | [] => do
    IO.println s!"No command provided. Use 'help' for usage information."
  | _ => do
    IO.println s!"Invalid command. Use 'help' for usage information."
