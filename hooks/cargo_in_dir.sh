#!/usr/bin/env bash

set -e

# OSX GUI apps do not pick up environment variables the same way as Terminal apps and there are no easy solutions,
# especially as Apple changes the GUI app behavior every release (see https://stackoverflow.com/q/135688/483528). As a
# workaround to allow GitHub Desktop to work, add this (hopefully harmless) setting here.
export PATH=$PATH:/usr/local/bin

# Validate supported commands and set additional arguments
validate_command() {
    case "$1" in
        check)
            additional_args=()
            ;;
        clippy)
            additional_args=("--" "-D" "warnings")
            ;;
        machete)
            additional_args=("--")
            ;;
        update)
            additional_args=("-w" "--locked")
            ;;
        *)
            echo "Error: Unsupported command '$1'"
            exit 1
            ;;
    esac
}

# Store and return last failure from validate so this can validate every directory passed before exiting
VALIDATE_ERROR=0

cargo_command="$1"
validate_command "$cargo_command"
shift
files=("$@")

# Function to find the first parent directory containing a Cargo.toml file
find_cargo_toml() {
    current_dir=$(dirname "$1")
    while [ "$current_dir" != "/" ]; do
        cargo_toml_path="$current_dir/Cargo.toml"
        if [ -f "$cargo_toml_path" ]; then
            echo "$current_dir"
            return
        fi
        current_dir=$(dirname "$current_dir")
    done
}
# Set to store unique parent directories with Cargo.toml
cargo_parent_dirs_set=()

# Iterate over each file in input and find the first parent directory with Cargo.toml
for file_path in "${files[@]}"; do
    parent_dir_with_cargo_toml=$(find_cargo_toml "$file_path")
    if [ -n "$parent_dir_with_cargo_toml" ]; then
        cargo_parent_dirs_set+=("$parent_dir_with_cargo_toml")
    fi
done

# Remove duplicates from the set
cargo_parent_dirs_set=($(echo "${cargo_parent_dirs_set[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Iterate over unique parent directories and run a command in each
for dir in "${cargo_parent_dirs_set[@]}"; do
  echo "--> Running 'cargo $cargo_cargo_command $additional_args[*]' in directory '$dir'"
  pushd "$dir" >/dev/null
  cargo $cargo_command ${additional_args[@]} || VALIDATE_ERROR=$?
  popd >/dev/null
done
exit ${VALIDATE_ERROR}
