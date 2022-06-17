# Define on Github Actions as "true"
ifeq ($(GITHUB_ACTIONS), true)
	PIPENV ?=
else
	PIPENV ?= pipenv run
endif

help: ## show this help
	@fgrep -h " ## " $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:|/' | \
		fgrep -v fgrep | sed -e 's/\\$$//' | column -t -s '|'

###############################################################################
#
# Setup
#
###############################################################################
.PHONY: init
init: ## Init pre-commit hooks
	$(info * Preparing project)
	pipenv sync
	$(PIPENV) pre-commit autoupdate
	$(PIPENV) pre-commit install --install-hooks

###############################################################################
#
# Validation
#
###############################################################################
.PHONY: validate
validate: ## Run Pre-commit against all files
	$(info * Pre-commit run)
	$(PIPENV) pre-commit run --all-files
