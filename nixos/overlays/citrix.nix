final: prev:

{
  citrix-workspace =
    let
      originalVersion = prev.citrix-workspace.version; # current nixpkgs version
      expectedVersion = "26.04.0.73"; # this was the last version on nixpkgs when I created the overlay
      overlayVersion = "26.04.0.105"; # this is the version I downloaded (newer)
    in

    builtins.trace
      (
        if originalVersion != expectedVersion then
          ''
            ⚠️ Citrix Workspace overlay warning:

            nixpkgs citrix-workspace version changed:
              expected: ${expectedVersion}
              current:  ${originalVersion}

            Consider removing overlays/citrix.nix
          ''
        else
          ''
            ✓ Citrix Workspace overlay active:
              nixpkgs version: ${originalVersion}
              using overlay version: ${overlayVersion}
          ''
      )

      (
        prev.citrix-workspace.overrideAttrs (oldAttrs: rec {
          version = overlayVersion;

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
        })
      );
}
