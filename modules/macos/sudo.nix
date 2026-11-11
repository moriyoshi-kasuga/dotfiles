_:

{
  flake.modules.darwin.pc = {
    security.pam.services.sudo_local = {
      touchIdAuth = true;
      # tmux の中では Touch ID の認証を呼び出せないので、pam_reattach で GUI セッションに繋ぎ直す
      reattach = true;
    };
  };
}
