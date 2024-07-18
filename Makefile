version ?= 1.0.0

ci: deps lint

deps:
	pip3 install -r requirements.txt

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