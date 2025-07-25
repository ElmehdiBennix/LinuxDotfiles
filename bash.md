```markdown
# 🐚 Shell Scripting Cheat Sheet

A quick reference for writing Bash shell scripts.

## 📦 Variables

```bash
NAME="John"
echo "Hello, $NAME"
```

```bash
readonly PI=3.14          # Constant
unset NAME                # Remove variable
```

---

## 🧮 Arithmetic

```bash
x=$((3 + 5))              # Integer arithmetic
let x=3+5
expr 3 + 5                # Legacy way
```

---

## 📂 Input / Output

```bash
read name                 # User input
echo "You entered $name"
```

```bash
echo "Hello" > file.txt   # Overwrite
echo "Again" >> file.txt  # Append
cat file.txt              # Display content
```

---

## 🔁 Conditionals

```bash
if [ "$x" -eq 5 ]; then
  echo "x is 5"
elif [ "$x" -gt 5 ]; then
  echo "x is greater than 5"
else
  echo "x is less than 5"
fi
```

### Operators

| Type       | Operators                |
|------------|--------------------------|
| Numeric    | -eq -ne -lt -le -gt -ge  |
| String     | = != -z -n               |
| File test  | -e -f -d -r -w -x        |

---

## 🔁 Loops

### For Loop

```bash
for i in 1 2 3; do
  echo "Number $i"
done
```

### While Loop

```bash
while [ $x -lt 5 ]; do
  echo "x is $x"
  x=$((x + 1))
done
```

### Until Loop

```bash
until [ $x -ge 5 ]; do
  echo "x is $x"
  x=$((x + 1))
done
```

---

## 🔀 Case Statement

```bash
case "$1" in
  start) echo "Starting";;
  stop) echo "Stopping";;
  *) echo "Usage: $0 {start|stop}";;
esac
```

---

## 🧰 Functions

```bash
greet() {
  echo "Hello, $1"
}

greet "Alice"
```

---

## 📁 File Tests

```bash
if [ -f "file.txt" ]; then
  echo "File exists"
fi
```

| Test        | Meaning                 |
|-------------|--------------------------|
| `-f`        | Regular file exists      |
| `-d`        | Directory exists         |
| `-e`        | File/directory exists    |
| `-r/-w/-x`  | Read/Write/Execute       |

---

## 🔗 Miscellaneous

```bash
$0      # Script name
$1-$9   # Positional args
$#      # Number of args
$@      # All args as separate words
$*      # All args as a single word
$$      # Script PID
$?      # Last command exit status
```

```bash
exit 0  # Exit with success
```

---

## 🔥 Useful Tips

- Use `"$(command)"` instead of backticks: `$(ls)` is better than `` `ls` ``
- Always quote variables: `"$var"` to avoid word splitting
- Use `set -e` to stop on errors

---

## 🧪 Debugging

```bash
set -x     # Enable debug (trace)
set +x     # Disable debug
```

---

## 📚 Resources

- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) — Lint your scripts!

---
