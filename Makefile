include make/*.mk

dev: ## Start rojo and any other dev necessary process
	rojo serve

docs: docs-api ## Build all docs locally
	mkdocs build

docs-clean:
	rm -r docs/ldoc || true
	rm -r site || true

docs-deploy: docs-api ## Build and deploy docs from current repo [DEPRACTED]
	mkdocs gh-deploy

docs-api: docs-clean ## Build Lua API docs
	ldoc -v .

lint: ## Lint
	luacheck src

test: ## Test
	lua -lluacov spec.lua
