BASHRC := ~/.bashrc
ZSHRC := ~/.zshrc
FISHCONF := ~/.config/fish/config.fish

deps:
	@$(MAKE) nodenv
	@$(MAKE) npm

nodenv:
	@which anyenv >/dev/null 2>&1 || $(MAKE) anyenv-install
	@which nodenv >/dev/null 2>&1 || $(MAKE) nodenv-install
	@$(MAKE) anyenv-update
	@$(MAKE) nodenv-update
	@$(MAKE) nodenv-info

anyenv-install:
	@echo "$(INFO_COLOR)==> 🎡 $(RESET)$(BOLD)Installing anyenv$(RESET)"
	@which anyenv >/dev/null 2>&1 || brew install anyenv
	@! test -e $$(anyenv root)/plugins/anyenv-update && mkdir -p $$(anyenv root)/plugins && git clone https://github.com/znz/anyenv-update.git $$(anyenv root)/plugins/anyenv-update || true
	@! grep -q '# anyenv' $(BASHRC) && echo '\n# anyenv\neval "$$(anyenv init -)"' >> $(BASHRC) || true
	@! grep -q '# anyenv' $(ZSHRC) && echo '\n# anyenv\neval "$$(anyenv init -)"' >> $(ZSHRC) || true
	@! grep -q '# anyenv' $(FISHCONF) && echo '\n# anyenv\nstatus --is-interactive; and source (anyenv init -|psub)' >> $(FISHCONF) || true

nodenv-install:
	@echo "$(INFO_COLOR)==> 🏝 $(RESET)$(BOLD)Installing nodenv$(RESET)"
	@eval "$$(anyenv init - sh)" && anyenv install nodenv -s

anyenv-update:
	@echo "$(INFO_COLOR)==> ⛳️ $(RESET)$(BOLD)Updating anyenv$(RESET)"
	@eval "$$(anyenv init - sh)" && anyenv update

nodenv-update:
	@echo "$(INFO_COLOR)==> 🌽 $(RESET)$(BOLD)Updating nodenv$(RESET)"
	@eval "$$(anyenv init - sh)" && nodenv install -s
	@eval "$$(anyenv init - sh)" && npm install -g npm@latest npm-check-updates@latest typesync@latest && nodenv rehash

nodenv-info:
	@echo "$(INFO_COLOR)==> 🍀 $(RESET)$(BOLD)Showing node and npm information$(RESET)"
	@eval "$$(anyenv init - sh)" && type node && node -v
	@eval "$$(anyenv init - sh)" && type npm && npm -v

npm:
	@echo "$(INFO_COLOR)==> 🍿 $(RESET)$(BOLD)Installing node packages$(RESET)"
	@git checkout package-lock.json
	@eval "$$(anyenv init - sh)" && npm ci -s

