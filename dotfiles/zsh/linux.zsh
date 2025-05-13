alias pbcopy="win32yank.exe -i"
alias pbpaste='win32yank.exe -o'
export LIBGL_ALWAYS_SOFTWARE=1

export ANDROID_HOME=$HOME/Android/SDK
export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/build-tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
