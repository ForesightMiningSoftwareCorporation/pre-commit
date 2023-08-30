.PHONY: precommit_setup precommit_install precommit_update precommit_run precommit_staged
# Install pre-commit tooling
precommit_setup:
	@echo "Setting up pre-commit..."
	pip install pre-commit

# Install the hooks
precommit_install: precommit_setup
	@echo "Installing pre-commit hooks..."
	pre-commit install

# Update the hooks to the latest versions
precommit_update: precommit_setup
	@echo "Updating pre-commit hooks..."
	pre-commit autoupdate

# Run all hooks against all the files
precommit_run:
	@echo "Running pre-commit hooks..."
	pre-commit run --all-files

# Run all hooks against staged files
precommit_staged:
	@echo "Running pre-commit hooks against staged files..."
	pre-commit run --files $$(git diff --name-only --cached)

# Your other Makefile targets
# ...
setup: precommit_setup precommit_update precommit_install
