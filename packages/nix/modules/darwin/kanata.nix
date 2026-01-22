# Kanata with cmd_allowed feature enabled
# Downloads pre-built binary from GitHub releases since Homebrew version lacks cmd support
{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "1.10.1";
  
  # Platform-specific binary selection
  platform = if stdenv.hostPlatform.isAarch64 then {
    name = "kanata_macos_cmd_allowed_arm64";
    hash = "sha256-0KlECUGSb+ajxGB1K1GGmAAjfrC8rwphjDF7CLEH+f0=";
  } else {
    name = "kanata_macos_cmd_allowed_x86_64";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Update if needed for Intel
  };
in
stdenv.mkDerivation {
  pname = "kanata-cmd";
  inherit version;

  src = fetchurl {
    url = "https://github.com/jtroo/kanata/releases/download/v${version}/${platform.name}";
    inherit (platform) hash;
  };

  # Skip unpack since it's a single binary
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/kanata
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
