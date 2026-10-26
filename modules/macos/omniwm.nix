_:

{
  flake.modules.darwin.omniwm = _: {
    people.home.programs.omniwm = {
      enable = true;
      settings = ./omniwm.toml;
    };

    system.defaults = {
      # OmniWM の 3 本指スワイプ (横で column、縦でワークスペース) と同時に
      # macOS のフルスクリーンアプリ切り替えと Mission Control が動かないようにする
      trackpad = {
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadThreeFingerVertSwipeGesture = 0;
      };

      # macOS 側のアニメーションもできるだけ止める。
      # Reduce Motion は Space 切り替えなどをフェードに変え、OmniWM のアニメーションも止める
      universalaccess.reduceMotion = true;
      NSGlobalDomain = {
        NSAutomaticWindowAnimationsEnabled = false;
        NSUseAnimatedFocusRing = false;
        NSWindowResizeTime = 0.001;
      };
      dock = {
        autohide-time-modifier = 0.0;
        expose-animation-duration = 0.1;
      };
    };
  };
}
