import ./generic.nix {
  version = "13.21";
  rev = "refs/tags/REL_13_21";
  hash = "sha256-je3nC8zymK9pIISWSv/hMNeloYuiB7ulLinWFzqAWFc=";
  muslPatches = {
    disable-test-collate-icu-utf8 = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql13/disable-test-collate.icu.utf8.patch?id=69faa146ec9fff3b981511068f17f9e629d4688b";
      hash = "sha256-jS/qxezaiaKhkWeMCXwpz1SDJwUWn9tzN0uKaZ3Ph2Y=";
    };
    dont-use-locale-a = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql13/dont-use-locale-a-on-musl.patch?id=69faa146ec9fff3b981511068f17f9e629d4688b";
      hash = "sha256-fk+y/SvyA4Tt8OIvDl7rje5dLs3Zw+Ln1oddyYzerOo=";
    };
  };
}
