# Pre-commit hooks

This repo defines Git pre-commit hooks intended for use with [pre-commit](http://pre-commit.com/) by ForesightMiningSoftwareCorporation. The currently
supported hooks are:

* **cargo-fmt**: Check if code is formatted using `cargo fmt` on staged Rust code (`*.rs` files).
* **cargo-check**: Check if code is valid using `cargo check` on staged Rust code (`*.rs` files).
* **cargo-clippy**: Check if code is valid using `cargo clippy` on staged Rust code (`*.rs` files).
* **cargo-machete**: Check for unused dependencies using `cargo machete` on staged Rust code (`*.rs` files).
* **cargo-lock**: Check if the `Cargo.lock` file is up to date using `cargo update -w --locked` on staged Rust code (`*.rs*` files).

## General Usage

In each of your repos, add a file called `.pre-commit-config.yaml` with the following contents:

```yaml
repos:
  - repo: https://github.com/ForesightMiningSoftwareCorporation/pre-commit
    rev: <VERSION> # Get the latest from: https://github.com/ForesightMiningSoftwareCorporation/pre-commit/releases
    hooks:
      - id: cargo-fmt
      - id: cargo-check
      - id: cargo-clippy
      - id: cargo-machete
```

Next, have every developer: 

1. Install [pre-commit](http://pre-commit.com/). 
1. Run `pre-commit install` in the repo.

That’s it! Now every time you commit a code change, the hooks in the `hooks:` config will execute.
