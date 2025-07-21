{
  lib,
  stdenv,
  glibc,
  fetchFromGitHub,
  nodejs_20,
  yarn-berry_4,
  nodePackages,
  python3,
  pkg-config,
  libsecret,
  electron_35,
}:

let
  nodejs = nodejs_20;
  yarn-berry = yarn-berry_4;
  electron = electron_35;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tonkeeper";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "tonkeeper";
    repo = "tonkeeper-web";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQqd3HTsAawZ0RMV82P/Hm1NqtfXn3AKht3hNtnwZAU=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-oCsQhn3+qtnODFNhtYyxT7mJm7KyDW2KeAjU+ERHNEA=";
    missingHashes = finalAttrs.missingHashes;
  };

  postPatch = ''
    echo "Stubbing workerd binary"
    mkdir -p node_modules/@cloudflare/workerd-linux-64/bin
    echo '#!/bin/sh' > node_modules/@cloudflare/workerd-linux-64/bin/workerd
    echo 'echo "workerd 2023-10-30"' >> node_modules/@cloudflare/workerd-linux-64/bin/workerd
    chmod +x node_modules/@cloudflare/workerd-linux-64/bin/workerd
  '';

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    nodePackages.node-gyp
    nodePackages.node-gyp-build
  ];

  buildInputs = [
    python3
    pkg-config
    libsecret
    nodejs
    glibc
    electron
  ];

  buildPhase = ''
    runHook preBuild

    LD_LIBRARY_PATH=${glibc}/lib:$LD_LIBRARY_PATH yarn build:desktop

    runHook postBuild
  '';

  meta = {
    description = "Non-custodial TON crypto wallet";
    homepage = "https://tonkeeper.com";
    license = lib.licenses.asl20;
    mainProgram = "tonkeeper";
    maintainers = with lib.maintainers; [ starius ];
  };
})
