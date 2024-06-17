help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
init: ## Initialize dotfiles
	bash ./bin/init.sh

link: ## Link dotfiles
	bash ./bin/links.sh link

unlink: ## Unlink dotfiles
	bash ./bin/links.sh unlink

zsh: ## Install zsh
	bash ./bin/zsh.sh

brew: ## Install homebrew
	bash ./bin/brew.sh

git: ## Install git
	bash ./bin/git.sh

neovim: ## Install neovim
	bash ./bin/neovim.sh

docker: ## Install docker
	bash ./bin/docker.sh

likes: ## Install likes
	bash ./bin/likes.sh

vim: ## Install only vim
	bash ./bin/vim.sh

# lang
node: ## Install node
	bash ./bin/lang/node.sh

python: ## Install python
	bash ./bin/lang/python.sh

coursier: ## Install coursier
	bash ./bin/lang/coursier.sh

rust: ## Install rust
	bash ./bin/lang/rust.sh


# os
darwin: ## Install darwin
	bash ./bin/os/darwin.sh

linux: ## Install linux
	bash ./bin/os/linux.sh
