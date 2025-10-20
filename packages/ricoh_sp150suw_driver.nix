{ lib, pkgs, stdenv }:
stdenv.mkDerivation rec {
  pname = "ricoh_sp150suw_driver";
  version = "v1.0.27";

  src = pkgs.fetchUrl {
    url = "https://support.ricoh.com/bb/pub_e/dr_ut_e/0001296/0001296582/V10_27/r76362L2.exe";
    sha256 = "0jfa9gxbqxkc21ahs8p4pibhfz7niz4llimkkhryp9m7s32j5qn3";
  };

  nativeBuildInputs = [ p7zip binutils gnutar gzip ]; 

  unpackPhase = ''
    runHook preUnpack

    7z x $src

    debPackage = $(find . -name "*.deb" | head -n1)
    if [ -z "$debPackage" ]; then
      echo "Ошибка сборки: Не найден .deb пакет в exe-архиве" >&2
      exit 1
    fi

    ar x "$debPackage"
    tar -xf data.tar.gz

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r opt usr $out/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Printing driver for Ricoh SP150SUw";
    homepage = "http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150suw/sp150suw.htm";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}