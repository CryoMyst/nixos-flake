{pkgs, ...}: let
  pname = "pyfa";
  version = "2.57.3";

  src = pkgs.fetchurl {
    url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/pyfa-v${version}-linux.AppImage";
    sha256 = "sha256-IS+yYYn+aRh8QxCMmlQjV1ysR1rSmPgRSa+2+gKtw5c=";
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs:
      with pkgs; [
        libnotify
        pcre2
      ];

    extraInstallCommands = let
      appimageContents = pkgs.appimageTools.extractType2 {inherit pname version src;};
    in ''
      # Remove version from entrypoint
      mv $out/bin/pyfa-"${version}" $out/bin/pyfa

      # Install .desktop files
      install -Dm444 ${appimageContents}/pyfa.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/pyfa.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/pyfa.desktop \
        --replace 'Exec=usr/bin/python3.11' 'Exec=pyfa'
    '';
  }
