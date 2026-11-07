makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
skills.dir := $(abspath $(dir $(makefile)))
skills := $(notdir $(patsubst %/SKILL.md,%,$(wildcard $(skills.dir)/*/SKILL.md)))

force:

# Link $(1)/<skill> -> $(skills.dir)/<skill>, refusing to clobber real directories.
define rule.template
$(1)/% : $(skills.dir)/% force
	@mkdir -p $$(@D)
	@if [ -e $$@ ] && [ ! -L $$@ ]; then \
		echo "skip $$@ (exists and is not a symlink)"; \
	else \
		ln -snf $$< $$@ && echo "$$@ -> $$<"; \
	fi
endef

rule.define = $(eval $(call rule.template,$(1)))

$(call rule.define,$(HOME)/.claude/skills)
$(call rule.define,$(HOME)/.codex/skills)

all += claude
claude : $(addprefix $(HOME)/.claude/skills/,$(skills))

all += codex
codex : $(addprefix $(HOME)/.codex/skills/,$(skills))

all : $(all)
.PHONY: all $(all) force
.DEFAULT_GOAL := all
