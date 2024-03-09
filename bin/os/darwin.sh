#!/usr/bin/env bash

is_mac=$(uname -s | grep -qi "darwin" && echo true || echo false)

if ! "${is_mac}"; then
	error "This can only be called on mac"
	exit 1
fi

script_root=$(cd "$(dirname "$0")" && cd .. && pwd)
. "${script_root}"/common.sh
require_password

setup_start "Mac"

# ====================
#
# Other
#
# ====================
# ネットからインストールしたアプリを実行できるように
sudo spctl --master-disable

# ネットワークドライブ上への.DS_Storeファイルの作成抑制
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# USB上への.DS_Storeファイルの作成抑制
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# スクリーンショットのファイル名変更
defaults write com.apple.screencapture name Screenshot

# Vsocde の キー押しっぱなしを有効にする
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# ====================
#
# Dock
#
# ====================

# Disable animation at application launch
defaults write com.apple.dock launchanim -bool false

# ====================
#
# Finder
#
# ====================

# Disable animation
defaults write com.apple.finder DisableAllAnimations -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show files with all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display the status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Display the path bar
defaults write com.apple.finder ShowPathbar -bool true

# ====================
#
# SystemUIServer
#
# ====================

# Display date, day, and time in the menu bar
defaults write com.apple.menuextra.clock DateFormat -string 'EEE d MMM HH:mm'

# Display battery level in the menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

for app in "Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &>/dev/null
done

setup_end "Mac"
