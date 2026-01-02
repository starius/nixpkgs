{
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  lib,
  gnupg,
  tags ? [
    # `RELEASE_TAGS` from https://github.com/lightningnetwork/lnd/blob/master/make/release_flags.mk
    "autopilotrpc"
    "chainrpc"
    "invoicesrpc"
    "kvdb_etcd"
    "kvdb_postgres"
    "kvdb_sqlite"
    "monitoring"
    "neutrinorpc"
    "peersrpc"
    "signrpc"
    "walletrpc"
    "watchtowerrpc"
    # Extra tags useful for testing
    "routerrpc"
  ],
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.20.0-beta";

  # Download the official release source tarball which matches manifest hash.
  src = fetchurl {
    url = "https://github.com/lightningnetwork/lnd/releases/download/v${version}/lnd-source-v${version}.tar.gz";
    hash = "sha256-rX3GzVzLJUnHfr2dYYFPn5C9++k13TjhWYTMWwm/UeI=";
  };

  # Signature verification inputs for the release manifest
  manifest = fetchurl {
    url = "https://github.com/lightningnetwork/lnd/releases/download/v${version}/manifest-v${version}.txt";
    hash = "sha256-l7GRblncBxBzmtTDJzkhs24yZAgfTdqiZaRe5z0Xxhk=";
  };

  # Signatures from the main long-term signers we enforce.
  manifestSigRoasbeef = fetchurl {
    url = "https://github.com/lightningnetwork/lnd/releases/download/v${version}/manifest-roasbeef-v${version}.sig";
    hash = "sha256-NFxkoa8fs96S1QKGn/O5WJ26LPx46V+NRiXCx/h3v90=";
  };

  manifestSigYyforyongyu = fetchurl {
    url = "https://github.com/lightningnetwork/lnd/releases/download/v${version}/manifest-yyforyongyu-v${version}.sig";
    hash = "sha256-74pfcp9FZ7Qr3x8CqEj3pAp/MEsqjrbaXhTKYHrZa/c=";
  };

  manifestSigZiggie1984 = fetchurl {
    url = "https://github.com/lightningnetwork/lnd/releases/download/v${version}/manifest-ziggie1984-v${version}.sig";
    hash = "sha256-hlt+XgS1M03A22T5Q4K0zGfjjFr+FeNzgQabYK3Utn8=";
  };

  vendorHash = "sha256-3F2ERp8gosNFzsg2QqSJpmjewf6N0zho+st+pafP8F0=";

  subPackages = [
    "cmd/lncli"
    "cmd/lnd"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ gnupg ];

  # Verify manifest signatures from trusted signers and ensure source tarball hash matches manifest.
  prePatch = ''
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    export GNUPGHOME=$tmpdir/gnupg
    mkdir -m 700 -p "$GNUPGHOME"

    # Import upstream-distributed signing keys (authoritative keys live in scripts/keys).
    gpg --batch --import \
      scripts/keys/roasbeef.asc \
      scripts/keys/yyforyongyu.asc \
      scripts/keys/ziggie1984.asc

    cp ${manifest} "$tmpdir/manifest.txt"
    cp ${manifestSigRoasbeef} "$tmpdir/roasbeef.sig"
    cp ${manifestSigYyforyongyu} "$tmpdir/yyforyongyu.sig"
    cp ${manifestSigZiggie1984} "$tmpdir/ziggie1984.sig"

    pushd "$tmpdir" > /dev/null
    for sig in roasbeef yyforyongyu ziggie1984; do
      gpg --batch --verify "$sig.sig" manifest.txt
    done

    # Confirm the manifest hash for the source tarball matches what we fetched.
    expected_src_hash=$(grep "lnd-source-v${version}.tar.gz" manifest.txt | awk '{print $1}')
    actual_src_hash=$(sha256sum ${src} | awk '{print $1}')
    test "$expected_src_hash" = "$actual_src_hash"
    popd > /dev/null
  '';

  inherit tags;

  meta = {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bleetube
      cypherpunk2140
      prusnak
    ];
  };
}
