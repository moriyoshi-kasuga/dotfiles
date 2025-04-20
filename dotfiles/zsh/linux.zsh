alias pbcopy="win32yank.exe -i"
alias pbpaste='win32yank.exe -o'
export LIBGL_ALWAYS_SOFTWARE=1

export ANDROID_HOME=$HOME/Android/SDK
export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/build-tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

export FFMPEG_DIR=$(ls -d /home/linuxbrew/.linuxbrew/Cellar/ffmpeg/* | sort -V | tail -n1)
export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/home/linuxbrew/.linuxbrew/lib/pkgconfig
