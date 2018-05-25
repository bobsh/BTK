include make/*.mk

dev: ## Start rojo and any other dev necessary process
	rojo serve

docs-deploy: docs-api ## Build and deploy docs from current repo
	mkdocs gh-deploy

docs-api: ## Build Lua API docs
	ldoc -v .

lint: ## Lint
	luacheck src

test: ## Test
	lua -lluacov spec.lua