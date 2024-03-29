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

###############################################################################
#
# Slides
#
###############################################################################
.PHONY: marp-server
marp-server: ## Start marp-cli in server mode
	$(info * Starting marp server)
	$(PIPENV) marp -p --server .

.PHONY: marp-pdf
marp-pdf: ## Convert marp slides to pdf
	$(info * Running marp conversion)
	$(PIPENV) marp PITCHME.md --allow-local-files -o sa-pre-commit-hooks.pdf

###############################################################################
#
# patch files
#
# diff -u file1.html file2.html > patchfile.patch
###############################################################################
.PHONY: patch_docker
patch_docker: ##  Apply Docker patch
	$(info * Patch for Docker)
	$(PIPENV) patch --verbose .pre-commit-config.yaml docker.patch

.PHONY: patch_terraform
patch_terraform: ##  Apply Terraform patch
	$(info * Patch for Terraform)
	$(PIPENV) patch --verbose .pre-commit-config.yaml terraform.patch
