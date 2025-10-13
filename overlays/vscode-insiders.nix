final: prev: {
  vscode = (prev.vscode.override { isInsiders = true; }).overrideAttrs(oldAttrs: rec {
  src = (builtins.fetchTarball {
    url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    sha256 = "0idq1km80qcfvasz9i9a6mdqhlpzswd8wkb1ayxlk8shiq22kjws";
  });
  version = "latest";

  buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
});
}