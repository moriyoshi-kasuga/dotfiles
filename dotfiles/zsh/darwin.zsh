export MACOSX_DEPLOYMENT_TARGET=15.0
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
  export ANDROID_NDK_HOME=$NDK_HOME
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
  export PATH=$PATH:$ANDROID_HOME/build-tools
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi
