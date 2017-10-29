# Deployment flags
FLAGS = $(ROLLBACK_FLAG) $(POLICY_FLAG) $(DEBUG_FLAG) $(VERBOSE_FLAG) $(CODEBUILD_FLAG)
ROLLBACK_FLAG = $(if $(findstring /disable_rollback,$(ARGS)),-e 'Stack.DisableRollback=true',)
POLICY_FLAG = $(if $(findstring /disable_policy,$(ARGS)),-e 'Stack.DisablePolicy=true',)
DEBUG_FLAG = $(if $(findstring /debug,$(ARGS)),-e 'debug=true',)
VERBOSE_FLAG = $(if $(findstring /verbose,$(ARGS)),-vvv,)
CODEBUILD_FLAG = $(if $(findstring /codebuild,$(ARGS)),-e 'Stack.BuildFolder=build',)

include Makefile.settings

.PHONY: roles environment generate deploy delete

roles:
	${INFO} "Installing Ansible roles from roles/requirements.yml..."
	@ ansible-galaxy install -r roles/requirements.yml --force
	${INFO} "Installation complete"

environment/%:
	@ mkdir -p group_vars/$*
	@ touch group_vars/$*/vars.yml
	@ echo >> inventory
	@ echo '[$*]' >> inventory
	@ echo '$* ansible_connection=local' >> inventory
	${INFO} "Created environment $*"

generate/%:
	${INFO} "Generating templates for $*..."
	@ ansible-playbook site.yml -e 'Sts.Disable=true' -e env=$* $(FLAGS) --tags generate
	${INFO} "Generation complete"

deploy/%:
	${INFO} "Deploying environment $*..."
	@ ansible-playbook site.yml -e env=$* $(FLAGS)
	${INFO} "Deployment complete"

delete/%:
	${INFO} "Deleting environment $*..."
	@ ansible-playbook site.yml -e env=$* -e 'Stack.Delete=true' $(FLAGS)
	${INFO} "Delete complete"