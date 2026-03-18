# Makefile for snippet tool
# Installation prefix
PREFIX ?= $(HOME)/.local

# Detect shell - try multiple methods
# Priority: 1) Explicitly set DETECTED_SHELL env var, 2) Parent process name
DETECTED_SHELL ?= $(shell ps -o comm= -p `ps -o ppid= -p $$PPID 2>/dev/null | tr -d ' '` 2>/dev/null | sed 's/^-//' | xargs basename 2>/dev/null || echo unknown)
SHELL_NAME := $(DETECTED_SHELL)

# Directories
BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share
SNIPPETDIR = $(SHAREDIR)/snippet
BASH_COMPLETION_DIR = $(SHAREDIR)/bash-completion/completions
ZSH_COMPLETION_DIR = $(SHAREDIR)/zsh/site-functions
FISH_COMPLETION_DIR = $(SHAREDIR)/fish/vendor_completions.d

# Source files
BIN_SRC = bin/snippet
SNIPPET_DATA_SRC = share/snippet
BASH_COMPLETION_SRC = share/bash-completion/completions/snippet.bash
ZSH_COMPLETION_SRC = share/zsh/site-functions/_snippet
FISH_COMPLETION_SRC = share/fish/vendor_completions.d/snippet.fish

.PHONY: all install install-bin install-data install-bash-completion install-zsh-completion install-fish-completion install-completions install-shell-completion help

# Default target shows help
help:
	@echo "snippet tool - Makefile targets"
	@echo ""
	@echo "Usage: make [target] [PREFIX=<path>]"
	@echo ""
	@echo "Default PREFIX: \$$HOME/.local"
	@echo "Detected shell: $(SHELL_NAME)"
	@echo ""
	@echo "Targets:"
	@echo "  help                     Show this help message (DEFAULT)"
	@echo "  all                      Install everything"
	@echo "  install                  Same as 'all'"
	@echo "  install-bin              Install snippet binary only"
	@echo "  install-data             Install snippet data files only"
	@echo "  install-shell-completion Install completion for current shell only"
	@echo "  install-bash-completion  Install bash completion script"
	@echo "  install-zsh-completion   Install zsh completion script"
	@echo "  install-fish-completion  Install fish completion script"
	@echo "  install-completions      Install all completion scripts"
	@echo ""
	@echo "Example:"
	@echo "  make install"
	@echo "  make install PREFIX=/usr/local"
	@echo "  make install-bin install-completions"

# Install everything
all: install

install: install-bin install-data install-shell-completion

# Install completion for the current shell only
install-shell-completion:
	@echo "Detected shell: $(SHELL_NAME)"
	@case "$(SHELL_NAME)" in \
		bash) \
			$(MAKE) install-bash-completion PREFIX=$(PREFIX) ;; \
		zsh) \
			$(MAKE) install-zsh-completion PREFIX=$(PREFIX) ;; \
		fish) \
			$(MAKE) install-fish-completion PREFIX=$(PREFIX) ;; \
		*) \
			echo "Warning: Unknown shell '$(SHELL_NAME)'. Skipping completion installation."; \
			echo "To install completions manually, run one of:"; \
			echo "  make install-bash-completion"; \
			echo "  make install-zsh-completion"; \
			echo "  make install-fish-completion" ;; \
	esac

# Install the binary
install-bin:
	@echo "Installing snippet binary to $(BINDIR)..."
	install -d $(BINDIR)
	install -m 755 $(BIN_SRC) $(BINDIR)/snippet
	@echo "Binary installed to $(BINDIR)/snippet"

# Install snippet data files
install-data:
	@echo "Installing snippet data to $(SNIPPETDIR)..."
	install -d $(SNIPPETDIR)
	cp -r $(SNIPPET_DATA_SRC)/* $(SNIPPETDIR)/
	chmod 600 $(SNIPPETDIR)/*
	@echo "Data files installed to $(SNIPPETDIR)/"

# Install bash completion
install-bash-completion:
	@echo "Installing bash completion to $(BASH_COMPLETION_DIR)..."
	install -d $(BASH_COMPLETION_DIR)
	install -m 644 $(BASH_COMPLETION_SRC) $(BASH_COMPLETION_DIR)/snippet.bash
	@echo "Bash completion installed to $(BASH_COMPLETION_DIR)/snippet.bash"
	@echo ""
	@echo "============================================"
	@echo "Bash Completion Setup Instructions"
	@echo "============================================"
	@echo ""
	@echo "The bash completion script has been installed. To enable it:"
	@echo ""
	@echo "1. If you have bash-completion package installed (recommended):"
	@echo "   - Most systems will automatically load completions from:"
	@echo "       $(BASH_COMPLETION_DIR)"
	@echo "   - Simply restart your shell or run: source ~/.bashrc"
	@echo ""
	@echo "2. If bash-completion is not installed:"
	@echo "   - Install it using your package manager:"
	@echo "     * Arch           pacman -S bash-completion"
	@echo "     * Debian/Ubuntu: apt-get install bash-completion"
	@echo "     * RHEL/CentOS:   yum install bash-completion"
	@echo "     * macOS:         brew install bash-completion@2"
	@echo ""
	@echo "3. Manual loading (if auto-loading doesn't work):"
	@echo "   - Add this line to your ~/.bashrc:"
	@echo "       source $(BASH_COMPLETION_DIR)/snippet.bash"
	@echo ""
	@echo "============================================"

# Install zsh completion
install-zsh-completion:
	@echo "Installing zsh completion to $(ZSH_COMPLETION_DIR)..."
	install -d $(ZSH_COMPLETION_DIR)
	install -m 644 $(ZSH_COMPLETION_SRC) $(ZSH_COMPLETION_DIR)/_snippet
	@echo "Zsh completion installed to $(ZSH_COMPLETION_DIR)/_snippet"
	@echo ""
	@echo "============================================"
	@echo "Zsh Completion Setup Instructions"
	@echo "============================================"
	@echo ""
	@echo "The zsh completion script has been installed. To enable it:"
	@echo ""
	@echo "1. Ensure the completion directory is in your fpath."
	@echo "   Add this to your ~/.zshrc (before compinit):"
	@echo "     fpath=($(ZSH_COMPLETION_DIR) \$$fpath)"
	@echo ""
	@echo "2. Initialize the completion system (if not already done):"
	@echo "   Add these lines to your ~/.zshrc:"
	@echo "     autoload -Uz compinit"
	@echo "     compinit"
	@echo ""
	@echo "3. Restart your shell or run: source ~/.zshrc"
	@echo ""
	@echo "4. If completions don't update, rebuild the cache:"
	@echo "   hash -r"
	@echo "     (or)"
	@echo "   rm -f ~/.zcompdump && compinit"
	@echo ""
	@echo "============================================"

# Install fish completion
install-fish-completion:
	@echo "Installing fish completion to $(FISH_COMPLETION_DIR)..."
	install -d $(FISH_COMPLETION_DIR)
	install -m 644 $(FISH_COMPLETION_SRC) $(FISH_COMPLETION_DIR)/snippet.fish
	@echo "Fish completion installed to $(FISH_COMPLETION_DIR)/snippet.fish"
	@echo ""
	@echo "============================================"
	@echo "Fish Completion Setup Instructions"
	@echo "============================================"
	@echo ""
	@echo "The fish completion script has been installed. To enable it:"
	@echo ""
	@echo "1. Fish automatically loads completions from:"
	@echo "   - $(FISH_COMPLETION_DIR)"
	@echo "   - ~/.config/fish/completions/"
	@echo "   - /usr/share/fish/vendor_completions.d/"
	@echo ""
	@echo "2. If installed to a standard location, completions should work"
	@echo "   immediately in new fish shells."
	@echo ""
	@echo "3. If installed to a non-standard PREFIX, add this to"
	@echo "   ~/.config/fish/config.fish:"
	@echo "     set -gx fish_complete_path $(FISH_COMPLETION_DIR) \$$fish_complete_path"
	@echo ""
	@echo "4. Restart fish or run: source ~/.config/fish/config.fish"
	@echo ""
	@echo "============================================"

# Install all completion scripts
install-completions: install-bash-completion install-zsh-completion install-fish-completion
	@echo ""
	@echo "All completion scripts installed successfully!"
