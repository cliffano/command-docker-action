################################################################
# Actobat: Makefile for building GitHub Actions
# https://github.com/cliffano/actobat
################################################################

# Actobat info
ACTOBAT_VERSION = 1.2.0

UPDATE_MAKEFILE = actobat
UPDATE_GENERATOR = github-action
UPDATE_DOTFILES = .github/. .gitignore requirements.txt .rtk.json .yamllint AGENTS.md
UPDATE_PARTIALS = AVATAR BADGES BUILD_REPORTS DEVELOPERS_GUIDE

################################################################
# User configuration variables
# https://github.com/cliffano/actobat#configuration
# Configuration variables should be stored in actobat.yml config file

# PACKAGE_NAME is the name of the GitHub Action package
PACKAGE_NAME=$(shell yq .package_name actobat.yml)

# AUTHOR is the author of the GitHub Action package
AUTHOR ?= $(shell yq .author actobat.yml)

$(info ################################################################)
$(info Building GitHub Action project using Actobat...)
$(info - Package name = ${PACKAGE_NAME})
$(info - Author = ${AUTHOR})

define python_venv
	. .venv/bin/activate && $(1)
endef

################################################################
# Base targets

# CI target to be executed by CI/CD tool
all: ci
ci: clean lint test doc

# Ensure stage directory exists
stage:
	mkdir -p stage

# Remove all temporary (staged, generated, cached) files
clean:
	rm -rf stage/

################################################################
# Dependencies targets

rmdeps:
	rm -rf .venv/

deps:
	python3 -m venv .venv
	$(call python_venv,python3 -m pip install -r requirements.txt)
	gh extension install nektos/gh-act
	npm install -g action-docs
	$(call deps_extra)

deps-upgrade:
	python3 -m venv .venv
	$(call python_venv,python3 -m pip install -r requirements-dev.txt)
	$(call python_venv,pip-compile --upgrade)

deps-extra-apt:
	apt-get update
	apt-get install -y python3-venv
	apt-get install -y markdownlint

################################################################
# Test targets

lint:
	mkdir -p stage/gh-pages/lint/
	$(call python_venv,yamllint action.yml .github/workflows/*.yaml > stage/gh-pages/lint/yamllint.txt 2>&1)
	@if [ ! -s stage/gh-pages/lint/yamllint.txt ]; then echo "yamllint: no issues found" > stage/gh-pages/lint/yamllint.txt; fi
	$(call python_venv,actionlint -shellcheck= .github/workflows/*.yaml)

test:
	mkdir -p stage/gh-pages/test/
	gh act -P ubuntu-24.04=catthehacker/ubuntu:act-latest -W tests/action-workflow.yaml 2>&1 | tee stage/gh-pages/test/act.txt

test-examples:
	mkdir -p stage/test-examples/
	cd examples && \
	for f in *.sh; do \
	  bash -x "$$f"; \
	done

################################################################
# Documentation targets

doc: stage
	rm -rf stage/gh-pages/doc/action-stage/gh-pages/ stage/doc/
	mkdir -p stage/gh-pages/doc/action-stage/gh-pages/ stage/doc/
	action-docs --source action.yml > stage/doc/action-docs.md
	$(call python_venv,python3 -m markdown stage/doc/action-docs.md > stage/gh-pages/doc/action-stage/gh-pages/index.html)

################################################################
# MAKE IT SO - Utility Makefile functions and targets
################################################################

define run_hook
	@if [ -f Makefile-extras ] && grep -q "^$(1):" Makefile-extras; then \
		$(MAKE) -f Makefile-extras $(1); \
	fi
endef

define deps_extra
	@if command -v apt-get > /dev/null 2>&1; then \
		if [ "$$(id -u)" = "0" ]; then \
			$(MAKE) deps-extra-apt; \
		else \
			sudo $(MAKE) deps-extra-apt; \
		fi; \
	fi
endef

define update_dotfiles_from_generator
	cd stage/ && \
	  rm -rf generator-$(1)/ && \
	  git clone https://github.com/cliffano/generator-$(1) && \
	  cd generator-$(1) && \
	  make deps && \
	  node_modules/.bin/plop $(UPDATE_GENERATOR_COMPONENT) -- \
	    --project_id "$(UPDATE_GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(UPDATE_GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(UPDATE_GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(UPDATE_GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(UPDATE_GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(UPDATE_GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(UPDATE_GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(UPDATE_GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(UPDATE_GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"
	cd stage/generator-$(1)/stage/$(UPDATE_GENERATOR_COMPONENT) && \
	  for dotfile in $(2); do \
		cp -R "$$dotfile" ../../../../"$$dotfile"; \
	  done
endef

define update_partials_from_generator
	cd stage/ && \
	  rm -rf generator-$(1)/ && \
	  git clone https://github.com/cliffano/generator-$(1) && \
	  cd generator-$(1) && \
	  make deps && \
	  node_modules/.bin/plop $(UPDATE_GENERATOR_COMPONENT)-partials -- \
	    --project_id "$(UPDATE_GENERATOR_INPUTS_PROJECT_ID)" \
		--project_name "$(UPDATE_GENERATOR_INPUTS_PROJECT_NAME)" \
		--project_desc "$(UPDATE_GENERATOR_INPUTS_PROJECT_DESC)" \
		--author_name "$(UPDATE_GENERATOR_INPUTS_AUTHOR_NAME)" \
		--author_email "$(UPDATE_GENERATOR_INPUTS_AUTHOR_EMAIL)" \
		--author_url "$(UPDATE_GENERATOR_INPUTS_AUTHOR_URL)" \
		--github_id "$(UPDATE_GENERATOR_INPUTS_GITHUB_ID)" \
		--github_repo "$(UPDATE_GENERATOR_INPUTS_GITHUB_REPO)" \
		--github_token_prefix "$(UPDATE_GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX)"
	for block in $(2); do \
	  partial_file=$$(printf "%s" "$$block" | tr "A-Z" "a-z"); \
	  ex -s \
	    -c "/<!-- BEGIN:$$block -->/+1,/<!-- END:$$block -->/-1d" \
	    -c "/<!-- BEGIN:$$block -->/r stage/generator-$(1)/stage/$(UPDATE_GENERATOR_COMPONENT)-partials/$$partial_file.txt" \
	    -c 'wq' \
	    README.md; \
	done
endef

define set_generator_vars
$(1): UPDATE_GENERATOR_COMPONENT = $$(shell yq .generator.component $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_PROJECT_ID = $$(shell yq .generator.inputs.project_id $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_PROJECT_NAME = $$(shell yq .generator.inputs.project_name $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_PROJECT_DESC = $$(shell yq .generator.inputs.project_desc $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_AUTHOR_NAME = $$(shell yq .generator.inputs.author_name $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_AUTHOR_EMAIL = $$(shell yq .generator.inputs.author_email $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_AUTHOR_URL = $$(shell yq .generator.inputs.author_url $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_GITHUB_ID = $$(shell yq .generator.inputs.github_id $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_GITHUB_REPO = $$(shell yq .generator.inputs.github_repo $(2).yml)
$(1): UPDATE_GENERATOR_INPUTS_GITHUB_TOKEN_PREFIX = $$(shell yq .generator.inputs.github_token_prefix $(2).yml)
endef

# Update Makefile to the latest version tag
update-to-latest: UPDATE_TARGET_VERSION = $(shell curl -s https://api.github.com/repos/cliffano/$(UPDATE_MAKEFILE)/tags | jq -r '.[0].name')
update-to-latest: update-to-version

# Update Makefile to the main branch
update-to-main:
	curl https://raw.githubusercontent.com/cliffano/$(UPDATE_MAKEFILE)/main/src/Makefile-$(UPDATE_MAKEFILE) -o Makefile

# Update Makefile to the version defined in UPDATE_TARGET_VERSION parameter
update-to-version:
	curl https://raw.githubusercontent.com/cliffano/$(UPDATE_MAKEFILE)/$(UPDATE_TARGET_VERSION)/src/Makefile-$(UPDATE_MAKEFILE) -o Makefile

# Update dotfiles using the generator
$(eval $(call set_generator_vars,update-dotfiles,$(UPDATE_MAKEFILE)))
update-dotfiles: stage
	$(call update_dotfiles_from_generator,$(UPDATE_GENERATOR),$(UPDATE_DOTFILES))

# Update partial snippets using the generator
$(eval $(call set_generator_vars,update-partials,$(UPDATE_MAKEFILE)))
update-partials: stage
	$(call update_partials_from_generator,$(UPDATE_GENERATOR),$(UPDATE_PARTIALS))

################################################################

.PHONY: $(1) all ci stage clean rmdeps deps deps-upgrade deps-extra-apt update-to-latest update-to-main update-to-version update-dotfiles update-partials lint test doc