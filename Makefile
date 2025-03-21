help: ## 🌟 Display help
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	

init: ## 🚀 Initialize the dotfiles environment
	bash ./bin/init.sh

link: ## 🔗 Create symbolic links for dotfiles
	bash ./bin/links.sh link

unlink: ## 🔗 Remove symbolic links for dotfiles
	bash ./bin/links.sh unlink

zsh: ## 🐚 Install and configure Zsh shell
	bash ./bin/zsh.sh

brew: ## 🍺 Install Homebrew package manager
	bash ./bin/brew.sh

bat: ## 🦇 Configure Bat, a cat clone with wings
	bash ./bin/bat.sh

git: ## 🌱 Install and setup Git version control
	bash ./bin/git.sh

neovim: ## ✨ Install Neovim, a modern and extensible text editor
	bash ./bin/neovim.sh

docker: ## 🐳 Install Docker for containerized applications
	bash ./bin/docker.sh

likes: ## 👍 Install Likes, a tool for managing preferences
	bash ./bin/likes.sh

vim: ## 📝 Install Vim, the ubiquitous text editor
	bash ./bin/vim.sh

# lang
node: ## 🟢 Install Node.js, JavaScript runtime
	bash ./bin/lang/node.sh

python: ## 🐍 Install Python programming language
	bash ./bin/lang/python.sh

coursier: ## 🚀 Install Coursier, a Scala artifact fetcher
	bash ./bin/lang/coursier.sh

rust: ## 🦀 Install Rust programming language
	bash ./bin/lang/rust.sh


# os
darwin: ## 🍏 Setup macOS (Darwin) specific configurations
	bash ./bin/os/darwin.sh

linux: ## 🐧 Setup Linux specific configurations
	bash ./bin/os/linux.sh
