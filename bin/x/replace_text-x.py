import sys
import re

# Define ANSI escape codes for colors
PY_GREEN = "\x1b[32m"
PY_RESET = "\x1b[0m"
PY_DIM = "\x1b[2m"


def process_file(file_path, target, replacement) -> None:
    with open(file_path, "r") as file:
        content = file.read()

    # Add color codes
    content = content.replace(target, replacement)
    with open(file_path, "w") as file:
        file.write(content)


if __name__ == "__main__":
    file_path = sys.argv[1]
    target = sys.argv[2]
    replacement = sys.argv[3]
    print("fp", file_path)
    print("t", target)
    print("r", replacement)
    process_file(file_path, target, replacement)
