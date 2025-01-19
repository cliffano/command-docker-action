version ?= 1.3.1-pre.0

ci: deps lint

deps:
	python3 -m venv .venv
	. .venv/bin/activate
	python3 -m pip install -r requirements.txt

lint:
	yamllint action.yml .github/workflows/*.yaml

release-major:
	rtk release --release-increment-type major

release-minor:
	rtk release --release-increment-type minor

release-patch:
	rtk release --release-increment-type patch

release: release-minor

.PHONY: ci deps lint release-major release-minor release-patch release