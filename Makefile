makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
dotfiles := $(abspath $(dir $(makefile)))
~ := $(abspath $(dotfiles)/~)

force:

define rule.template
$(1)/% : $(2)/% force
	mkdir -p $$(@D)
	ln -snf $$< $$@
endef

rule.define = $(eval $(call rule.template,$(1),$(2)))

$(call rule.define,~,$(~))

all += zsh
zsh : ~/.zshrc ~/.zprofile

all += git
git : ~/.gitconfig

all += emacs
emacs: ~/.emacs.d/init.el ~/.emacs.d/custom.el ~/.emacs.d/themes/leuven-zen-theme.el

all += vim
vim : ~/.vimrc

all += tmux
tmux: ~/.tmux.conf

all : $(all)
.PHONY: all $(all)
.DEFAULT_GOAL := all



all : $(all)
.PHONY: all $(all)
.DEFAULT_GOAL := all



