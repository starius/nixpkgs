{ callPackage }:
callPackage ../../../development/compilers/go/binary.nix {
  version = "1.23.9";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "50200cba5173100a6e880098cf3b2db4063394beaf7374e9766b6c19bb18012d";
    darwin-arm64 = "2bf624b6399e41248255858b2d61abae2703eecafad39808449951f3f1ab3766";
    freebsd-386 = "2ec88ecebd609768d0b2a19f5ae6df333f60e7ae1b06dab3562d21ac41d2f837";
    freebsd-amd64 = "d939dd297a4ced4999147be03c22e3b667cee5479078373ed7bf7ccd1a777c83";
    freebsd-arm = "790e8b5d83b509ee3b5c3abd1dbc90aa72348ade2b1e10fb702242ee4e42f3ac";
    freebsd-arm64 = "a2d01870891f9bd531e3ac4b9a1a0768fb9c3aeab69986f79d965ddb618b5c1a";
    freebsd-riscv64 = "eec460900861c9386556e56ac256ba0e86ed87dfe00930ed1a0a485871e1f1ae";
    linux-386 = "9145095dead1209fd4ce554cd5a18ac42861b168efcd849faf85b8639782f0f9";
    linux-amd64 = "de03e45d7a076c06baaa9618d42b3b6a0561125b87f6041c6397680a71e5bb26";
    linux-arm64 = "3dc4dd64bdb0275e3ec65a55ecfc2597009c7c46a1b256eefab2f2172a53a602";
    linux-armv6l = "ade33880caacb8919b48767e0957e9880f2cdf634e137402a6f22552504136dd";
    linux-loong64 = "50b08d8b3a7fb027608db01ff63152001b33710b2ec9acad995adbb63bd8a02a";
    linux-mips = "f467012d9ce5e43744f3dd1a351c71e3f9990c543c7ab5e6775846cedd09e0b6";
    linux-mips64 = "23486ac0530ea88e8ca88a3e286c51922fdc21a40ac9f0eeed1ee2b35acce940";
    linux-mips64le = "fef65b253a2339453249bb90c65b02a2eb7a2c3c788b941fbc2a10a0eb9f41b2";
    linux-mipsle = "d29059c2e82d4a655c5e4135436358ea41cc98e5584a18bb6085404950c65cd4";
    linux-ppc64 = "ed52941d8779cbea9579eccc20fc16e03de9f1b4a78ac3dded4d1fa61d87cff7";
    linux-ppc64le = "4e23059029552ece0f37e626208caacfe088b7178409797be75280f6e850e98b";
    linux-riscv64 = "e9027dfeb00a482271c2d068d2d0fd5d75aa5b49fa86542d8409cac3cd0c977f";
    linux-s390x = "25e7cb524f97f52369b6162e2440c87be128ed8e9ad9bd076e0706bba4f73817";
  };
}
