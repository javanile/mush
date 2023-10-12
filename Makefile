
## ====
## Mush
## ====

.DEFAULT:
	@mush $@

build-dist:
	@mush build -v --target dist

release:
	@mush build -v --release

## ====
## Prod
## ====

install:
	@install -m 0755 target/dist/mush /usr/local/bin/

sudo-install:
	@sudo install -m 0755 target/dist/mush /usr/local/bin/

publish:
	@git add .
	@git commit -am "Nightly Release" || true
	@git push
	@mush publish

## ====
## Docs
## ====

serve-docs:
	@echo 'source "https://rubygems.org"' > docs/Gemfile
	@echo 'gem "github-pages", "~> 219", group: :jekyll_plugins' >> docs/Gemfile
	@echo 'gem "kramdown-parser-gfm"' >> docs/Gemfile
	@echo 'gem "jekyll-include-cache"' >> docs/Gemfile
	@echo 'baseurl: ""' > docs/_config_dev.yml
	@echo 'repository: "javanile/mush"' >> docs/_config_dev.yml
	@mkdir -p "docs/.bundles_cache"
	@docker run --rm -it \
		-v "$$PWD/docs:/srv/jekyll" \
		-e BUNDLE_PATH="/srv/jekyll/.bundles_cache" \
		-p 4000:4000 \
		jekyll/builder:3.8 \
		bash -c "gem install bundler && bundle install && bundle exec jekyll serve --host 0.0.0.0 --verbose --config _config.yml,_config_dev.yml"

## ====
## Test
## ====

test-legacy-fetch-debug:
	@bash tests/bare/legacy/debug-fetch-test.sh

test-build-debug:
	@bash tests/bare/build/debug-test.sh

test-build-dist:
	@bash tests/bare/build/dist-test.sh

test-task-build-dist:
	@bash tests/bare/tasks/build-dist-test.sh

test-task-manifest-lookup:
	@bash tests/bare/tasks/manifest-lookup-test.sh

test-task-legacy-build:
	@bash tests/bare/tasks/legacy-build-test.sh

test-task-legacy-fetch:
	@bash tests/bare/tasks/legacy-fetch-test.sh

test-usage-debug:
	@bash tests/bare/usage-debug-test.sh

test-rust:
	@cd tests/rust && cargo build

test-init: build
	@bash tests/bare/init-test.sh

test-install:
	@bash tests/bare/install-test.sh

test-run:
	@bash tests/bare/run-test.sh

test-new: build
	@bash tests/bare/new-test.sh

test-build-debug-basic-app:
	@bash tests/bare/build/debug-basic-app-test.sh

test-api-embed:
	@bash tests/bare/api/embed-test.sh

test-cross-build:
	@bash tests/bare/build/cross-test.sh

test-auto-build-debug-debug:
	@bash tests/bare/build/auto-debug-debug-test.sh

test-auto-build-debug-dist: test-auto-build-debug-debug
	@bash tests/bare/build/auto-debug-dist-test.sh

test-auto-build-dist-debug:
	@bash tests/bare/build/auto-dist-debug-test.sh

test-auto-build-dist-dist:
	@bash tests/bare/build/auto-dist-dist-test.sh

test-console:
	@bash tests/bare/console-test.sh

test-publish:
	@bash tests/bare/publish-test.sh

test-registry-github:
	@bash tests/bare/registry/github-test.sh

test-package-manager-git:
	@bash tests/bare/package_managers/git-test.sh

test-basic-app:
	@bash tests/bare/basic-app-test.sh

test-build-rust-app:
	@bash tests/bare/build/rust-app-test.sh

test-build-rust-lib:
	@bash tests/bare/build/rust-lib-test.sh

test-build-console-lib: build-dist sudo-install
	@cd packages/console && mush build --release --lib

test-build-empty-app:
	@bash tests/bare/build/empty-app-test.sh

test-build-basic-app:
	@bash tests/bare/build/basic-app-test.sh

test-legacy:
	@bash tests/bare/legacy-test.sh

test-command:
	@bash tests/bare/command-test.sh

test-commands:
	@bash tests/bare/commands-test.sh

test-demo:
	@bash tests/bare/demo-test.sh

test-docs:
	@bash tests/bare/docs-test.sh

test-sysinfo:
	@bash tests/bare/sysinfo-test.sh

test-install-help:
	@bash tests/bare/help/install-test.sh

test-command-options:
	@bash tests/bare/command-options-test.sh

test-syntax-build:
	@bash tests/bare/syntax/build-test.sh

test-syntax-command-not-found:
	@bash tests/bare/syntax/command-not-found-test.sh

test-test:
	@bash tests/bare/test-test.sh
