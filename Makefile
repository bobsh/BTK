include make/*.mk

rojo: deps-rust ## Start rojo and any other dev necessary process
	rojo serve

deps-hererocks: deps-py ## Install a local copy of lua
	hererocks lua_install -r^ --$(LUA)

deps-rust: ## Install rust based tools
	cargo update

deps-py: ## Installs all python requirements
	pip install -r requirements.txt

deps-lua: deps-hererocks ## Install dependencies for lua
	luarocks build --only-deps btk-scm-1.rockspec

docs: docs-ldoc docs-mkdocs ## Build all docs locally

docs-mkdocs: deps-py docs-mkdocs-clean ## Build mkdocs output
	mkdocs build

docs-mkdocs-clean: ## Remove all docs builds
	rm -r site || true

docs-ldoc: deps-lua docs-ldoc-clean ## Build Lua API docs
	ldoc -v .

docs-ldoc-clean: ## Remove all ldoc build files
	rm -r docs/ldoc || true

lint: lint-rock lint-lua ## Lint

lint-lua: deps-lua ## Lint lua code
	luacheck src

lint-rock: deps-lua ## Lint rockspec
	luarocks lint btk-scm-1.rockspec

test: deps-lua ## Test
	lua -lluacov spec.lua
	luacov-console src
	luacov-console -s

report-coveralls: deps-lua ## Report to coveralls
	luacov-coveralls -e $(TRAVIS_BUILD_DIR)/lua_install -e src/Models/Core/MainModule/lib/Roact

travis-script: lint test docs report-coveralls ## Install step for travis