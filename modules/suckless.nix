{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # (st.overrideAttrs (oldAttrs: rec {
    #   patches = [
    #     # You can specify local patches
    #     # ./path/to/local.diff
    #     # Fetch them directly from `st.suckless.org`
    #     (fetchpatch {
    #       url = ""
    #       sha256 = "0n0krrrfzvhr73gnf03xkxdrcgjd6ch582mdyds1b285lnw1rxkv";
    #     })
    #     # Or from any other source
    #     # (fetchpatch {
    #     #   url = "https://raw.githubusercontent.com/fooUser/barRepo/1111111/somepatch.diff";
    #     #   sha256 = "222222222222222222222222222222222222222222";
    #     # })
    #   ];
    # }))
  ];

}
