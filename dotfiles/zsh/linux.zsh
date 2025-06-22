export BROWSER=explorer.exe
export PATH="$PATH:$HOME/zsh/linux"
export LIBGL_ALWAYS_SOFTWARE=1

if [ -d "$HOME/Android/SDK" ]; then
  export ANDROID_HOME=$HOME/Android/SDK
  export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
  export PATH=$PATH:$ANDROID_HOME/build-tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi
