final: prev:

{
  citrix-workspace = prev.citrix-workspace.overrideAttrs (oldAttrs: rec {
    version = "26.04.0.105";

    src = final.requireFile {
      name = "linuxx64-${version}.tar.gz";

      sha256 = "1kl6b1ldjd9gb6cmvhxf6ggvc3amq1kz0qwjlb1fp6dxx0pivwm8";

      message = ''
        The Citrix Workspace tarball is not automatically downloaded.

        Please download:

          linuxx64-${version}.tar.gz

        from Citrix Workspace App for Linux and add it to the Nix store:

          nix-prefetch-url --type sha256 file://$PWD/linuxx64-${version}.tar.gz
      '';
    };
  });
}
