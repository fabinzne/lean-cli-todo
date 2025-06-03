# Todo CLI

A simple command-line todo list application built with Lean 4.

## Features

- Create, read, update, and list todos
- Beautiful table-formatted output
- JSON file persistence
- Simple command-line interface

## Installation

Make sure you have Lean 4 installed on your system.

1. Clone or download this project
2. Build the project:
   ```bash
   lake build
   ```

## Usage

### Commands

- `.lake/build/bin/todo-list help` - Show help information
- `.lake/build/bin/todo-list list` - List all todos in table format
- `.lake/build/bin/todo-list read <name>` - Show a specific todo
- `.lake/build/bin/todo-list create <name>` - Create a new todo
- `.lake/build/bin/todo-list update <name> <status>` - Update todo status (true/false)

### Examples

```bash
# Create a new todo
.lake/build/bin/todo-list create "Learn Lean 4"

# List all todos
.lake/build/bin/todo-list list

# Read a specific todo
.lake/build/bin/todo-list read "Learn Lean 4"

# Mark a todo as done
.lake/build/bin/todo-list update "Learn Lean 4" true

# Mark a todo as pending
.lake/build/bin/todo-list update "Learn Lean 4" false

# Show help
.lake/build/bin/todo-list help
```

### Sample Output

```
┌─────┬──────────────────────────────────┬────────────┐
│ #   │ Name                             │ Status     │
├─────┼──────────────────────────────────┼────────────┤
│ 1   │ Learn Lean 4                     │ ✓ Done     │
│ 2   │ Build a CLI app                  │ ○ Pending  │
└─────┴──────────────────────────────────┴────────────┘
Total: 2 todo(s)
```

## File Structure

- `Main.lean` - Main application entry point and CLI interface
- `Basic.lean` - Core todo functionality and JSON persistence
- `todos.json` - JSON file where todos are stored (auto-created)

## How it Works

The application stores todos in a JSON file (`todos.json`) with the following structure:

```json
[
  {
    "name": "Learn Lean 4",
    "done": true
  },
  {
    "name": "Build a CLI app",
    "done": false
  }
]
```

Each todo has a name and a done status. The CLI provides a user-friendly interface to interact with this data.

## Error Handling

The application includes comprehensive error handling for:

- File I/O operations
- JSON parsing
- Invalid commands
- Missing todos

All errors are displayed with helpful messages to guide the user.
