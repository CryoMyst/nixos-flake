{
  lib,
  python3Packages,
  fetchPypi,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "LGWebOSRemote";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "klattimer";
    repo = "LGWebOSRemote";
    rev = "0ff499b50a83051f4837669662f11f958411f029";
    sha256 = "sha256-AFs7l5OFquEOAq2JfnrHXcSvZaVjK3B94DixvNCTCVI=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    wakeonlan
    ws4py
    requests
    getmac
  ];

  meta = with lib; {
    description = "Command line webOS remote for LG TVs";
    homepage = "https://github.com/klattimer/LGWebOSRemote";
  };
}
