{
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "hello";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner  = "hello";
    repo   = "hello";
    rev    = "v${version}";
    sha256 = "sha256-VS7UQsTAhWEUqPdTeZTY7Hvp6MRRxsDVD1OxKS81Efx=";
  };
}
