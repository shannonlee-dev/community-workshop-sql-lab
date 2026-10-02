.PHONY: setup check format test smoke run

setup:
	uv sync --frozen

check:
	uv run --frozen python scripts/check.py
	uv run --frozen ruff check .
	uv run --frozen ruff format --check .

format:
	uv run --frozen ruff check --fix .
	uv run --frozen ruff format .

test:
	uv run --frozen pytest -q

smoke:
	uv run --frozen pytest -q -m smoke

run:
	uv run --frozen python scripts/reproduce.py
