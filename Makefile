include make/*.mk

rojo: ## Start rojo and any other dev necessary process
	rojo serve

hererocks: ## Install a local copy of lua
	pip install hererocks
	hererocks lua_install -r^ --$(LUA)

deps-lua: ## Install dependencies for lua
	luarocks show luafilesystem || luarocks install luafilesystem
	luarocks show busted || luarocks install busted
	luarocks show luacov || luarocks install luacov
	luarocks show luacov-coveralls || luarocks install luacov-coveralls
	luarocks show luacov-console || luarocks install luacov-console
	luarocks show luacheck || luarocks install luacheck
	luarocks show ldoc || luarocks install ldoc

docs: docs-api ## Build all docs locally
	mkdocs build

docs-clean: ## Remove all docs builds
	rm -r docs/ldoc || true
	rm -r site || true

docs-api: docs-clean ## Build Lua API docs
	ldoc -v .

lint: ## Lint
	luacheck src

test: ## Test
	lua -lluacov spec.lua
	luacov-console src
	luacov-console -s

report-coveralls: ## Report to coveralls
	luacov-coveralls -e $(TRAVIS_BUILD_DIR)/lua_install -e src/Models/Core/MainModule/lib/Roact