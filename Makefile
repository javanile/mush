
## ====
## Mush
## ====

.DEFAULT:
	@mush $@

build-release:
	@mush build -v --target bash5

release:
	@mush build -v --release

## ====
## Lint
## ====

shellcheck:
	@find src -name '*.sh' -type f -exec shellcheck \
		-e SC2148 -e SC2155 -e SC2034 {} \;

## ====
## Prod
## ====

install:
	@install -m 0755 target/releasemush $(HOME)/.mush/bin/

sudo-install:
	@sudo install -m 0755 target/releasemush /usr/local/bin/

mush-install:
	@bash ./bin/mush build --release
	@bash ./bin/mush install --path .

publish:
	@git add .
	@git commit -am "Nightly Release" || true
	@git push
	@mush publish --allow-dirty

publish-stable:
	@git add .
	@git commit -am "Stable Release" || true
	@git checkout stable
	@git pull
	@echo "========[ Publish Stable ]==================================="
	@mush build --release || true
	@mush publish --allow-dirty || true
	@echo "============================================================="
	@rm -fr bin lib target
	@git add .
	@git commit -am "Stable Release" || true
	@git push
	@git checkout main

## ====
## Docs
## ====

serve-docs:
	@echo 'source "https://rubygems.org"' > docs/Gemfile
	@echo 'gem "github-pages", "~> 219", group: :jekyll_plugins' >> docs/Gemfile
	@echo 'gem "kramdown-parser-gfm"' >> docs/Gemfile
	@echo 'gem "jekyll-include-cache"' >> docs/Gemfile
	@echo 'gem "jekyll-sitemap"' >> docs/Gemfile
	@echo 'baseurl: ""' > docs/_config_dev.yml
	@echo 'repository: "javanile/mush"' >> docs/_config_dev.yml
	@docker run --rm -it \
		-v $$PWD/docs:/srv/jekyll \
		-v $$PWD/.bundles_cache:/tmp/.bundles_cache \
		-e BUNDLE_PATH=/tmp/.bundles_cache \
		-p 4000:4000 \
		jekyll/builder:3.8 bash -c "\
			gem install bundler -v 2.4.22 && bundle install && \
			bundle exec jekyll serve --host 0.0.0.0 --verbose --config _config.yml,_config_dev.yml"

## =====
## CI/CD
## =====

ci-shellcheck:
	@rm -fr lib/shellspec target/release/packages/getoptions target/debug/packages/getoptions
	@git add .
	@git commit -am "shellcheck"
	@git push


## ====
## Test
## ====

test-docker:
	@docker build -q -t mush-test-docker-ubuntu tests/docker/ubuntu

test-legacy-fetch-debug:
	@bash tests/bare/legacy/debug-fetch-test.sh

test-build-debug:
	@bash tests/bare/build/debug-test.sh

test-build-release:
	@bash tests/bare/build/releasetest.sh

test-task-build-release:
	@bash tests/bare/tasks/build-release-test.sh

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

test-auto-build-debug-release: test-auto-build-debug-debug
	@bash tests/bare/build/auto-debug-releasetest.sh

test-auto-build-release-debug:
	@bash tests/bare/build/auto-release-debug-test.sh

test-auto-build-release-release:
	@bash tests/bare/build/auto-release-release-test.sh

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

test-build-console-lib: build-releasesudo-install
	@cd packages/console && mush build --release --lib

test-build-empty-app:
	@bash tests/bare/build/empty-app-test.sh

test-build-basic-app:
	@bash tests/bare/build/basic-app-test.sh

test-legacy:
	@bash tests/bare/legacy-test.sh

test-getoptions-legacy:
	@bash tests/bare/legacy/getoptions-test.sh

test-command:
	@bash tests/bare/command-test.sh

test-commands:
	@bash tests/bare/commands-test.sh

test-demo:
	@bash tests/bare/demo-test.sh

test-docs:
	@bash tests/bare/docs/docs-test.sh

test-docs-compliance:
	@bash tests/bare/docs/docs-compliance-test.sh

test-sysinfo:
	@bash tests/bare/sysinfo-test.sh

test-install-help:
	@bash tests/bare/help/install-help-test.sh

test-help:
	@bash tests/bare/help/help-test.sh

test-command-options:
	@bash tests/bare/command-options-test.sh

test-syntax-build:
	@bash tests/bare/syntax/build-test.sh

test-syntax-command-not-found:
	@bash tests/bare/syntax/command-not-found-test.sh

test-test:
	@bash tests/bare/test-test.sh

test-bashunit:
	@bash tests/bare/testing/bashunit-test.sh

test-getoptions:
	@bash tests/bare/packages/getoptions-test.sh

test-simple-feature:
	@bash tests/bare/features/simple-test.sh

test-print:
	@bash tests/bare/print-test.sh

test-system-ubuntu: test-docker
	@docker run --rm -v $${PWD}:/mush -w /mush mush-test-docker-ubuntu bash tests/bare/system/ubuntu-test.sh

test-ui:
	@bash tests/ui/test-runner.sh

test-coverage:
	@bash tests/coverage/test-runner.sh

test-environment-variable-target-dir:
	@bash tests/bare/environment_variables/target-dir-test.sh

test-run-example:
	@bash tests/bare/examples/run-example-test.sh

test-fix:
	@bash tests/bare/fix-test.sh

test-metadata:
	@bash tests/bare/info/metadata-test.sh
