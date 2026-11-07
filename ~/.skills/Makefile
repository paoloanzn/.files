makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
skills.dir := $(abspath $(dir $(makefile)))
skills := $(notdir $(patsubst %/SKILL.md,%,$(wildcard $(skills.dir)/*/SKILL.md)))

# private-<name> is git-crypt encrypted on push; agents see it as <name>.
link.name = $(patsubst private-%,%,$(1))

force:

# Link $(1)/<name> -> $(skills.dir)/$(2). Skips real directories (never
# clobbered) and skills still encrypted (repo not git-crypt unlocked).
define rule.template
$(1)/$(call link.name,$(2)) : $(skills.dir)/$(2) force
	@mkdir -p $$(@D)
	@if [ -e $$@ ] && [ ! -L $$@ ]; then \
		echo "skip $$@ (exists and is not a symlink)"; \
	elif [ "$$$$(head -c 3 $$</SKILL.md)" != "---" ]; then \
		echo "skip $$@ (SKILL.md is encrypted, run git-crypt unlock)"; \
	else \
		ln -snf $$< $$@ && echo "$$@ -> $$<"; \
	fi
endef

rule.define = $(foreach s,$(skills),$(eval $(call rule.template,$(1),$(s))))

$(call rule.define,$(HOME)/.claude/skills)
$(call rule.define,$(HOME)/.codex/skills)

all += claude
claude : $(addprefix $(HOME)/.claude/skills/,$(foreach s,$(skills),$(call link.name,$(s))))

all += codex
codex : $(addprefix $(HOME)/.codex/skills/,$(foreach s,$(skills),$(call link.name,$(s))))

all : $(all)
.PHONY: all $(all) force
.DEFAULT_GOAL := all
