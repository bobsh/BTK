include make/*.mk

rojo: ## Start rojo and any other dev necessary process
	rojo serve

hererocks: ## Install a local copy of lua
	pip install hererocks
	hererocks lua_install -r^ --$(LUA)

deps-lua: ## Install dependencies for lua
	luarocks install luafilesystem
	luarocks install busted
	luarocks install luacov
	luarocks install luacov-coveralls
	luarocks install luacheck
	luarocks install ldoc

docs: docs-api ## Build all docs locally
	mkdocs build

docs-clean:
	rm -r docs/ldoc || true
	rm -r site || true

docs-api: docs-clean ## Build Lua API docs
	ldoc -v .

lint: ## Lint
	luacheck src

test: ## Test
	lua -lluacov spec.lua
