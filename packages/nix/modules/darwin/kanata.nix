# Kanata with cmd_allowed feature enabled
# Downloads pre-built binary from GitHub releases since Homebrew version lacks cmd support
{
  lib,
  stdenv,
  fetchzip,
}:
let
  version = "1.10.1";

  # Platform-specific binary and zip selection
  platform =
    if stdenv.hostPlatform.isAarch64
    then {
      zip = "kanata-macos-binaries-arm64-v${version}.zip";
      binary = "kanata_macos_cmd_allowed_arm64";
      hash = "sha256-4gg2sruylr5IdZtANJ1e/AfxbFTRDXKs6e8orls1tkc=";
    }
    else {
      zip = "kanata-macos-binaries-x64-v${version}.zip";
      binary = "kanata_macos_cmd_allowed_x86_64";
      # Hash for x86_64 - update if needed
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
in
stdenv.mkDerivation {
  pname = "kanata-cmd";
  inherit version;

  src = fetchzip {
    url = "https://github.com/jtroo/kanata/releases/download/v${version}/${platform.zip}";
    inherit (platform) hash;
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/${platform.binary} $out/bin/kanata
    chmod +x $out/bin/kanata
    runHook postInstall
  '';

  meta = with lib; {
    description = "Kanata keyboard remapper with cmd feature enabled";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    platforms = platforms.darwin;
    mainProgram = "kanata";
  };
}
