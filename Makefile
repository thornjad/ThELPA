EMACS ?= $(shell command -v emacs 2>/dev/null)
git ?= git
markdown ?= markdown
CASK_DIR := $(shell cask package-directory)

project_root := $(CURDIR)

cask_install_path := $(project_root)/cask-repository
cask_repository := https://github.com/cask/cask.git
cask_version := v0.9.0
cask ?= EMACS=$(EMACS) \
	EMACSLOADPATH=$(project_root):$(EMACSLOADPATH) \
	$(cask_install_path)/bin/cask
cask_emacs := $(cask) emacs
thelpa_batch_emacs := $(cask_emacs) --batch -Q --load=thelpa.el

.PHONY: all
all: build commit

.PHONY: build
build: compile
	$(thelpa_batch_emacs) -f thelpa-build

.PHONY: commit
commit:
	$(thelpa_batch_emacs) -f thelpa-commit

.PHONY: compile
compile: cask
	$(cask_emacs) -batch -L . -L test \
		--eval "(setq byte-compile-error-on-warn t)" \
	  -f batch-byte-compile $$(cask files); \
	  (ret=$$? ; cask clean-elc && exit $$ret)

### Cask

.PHONY: cask
cask: $(CASK_DIR)

$(CASK_DIR): install-cask
	$(cask) install
	@touch $(CASK_DIR)

.PHONY: install-cask
install-cask:
	test -d $(cask_install_path) || $(git) clone $(cask_repository) $(cask_install_path)
	cd $(cask_install_path) && $(git) checkout -f $(cask_version) && $(git) clean -xdf
