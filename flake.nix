{
  description = "Gtk greeter for greetd";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      version =
        if (self ? rev)
        then self.rev
        else "dev";

      nativeBuildInputs = with pkgs; [pkg-config meson ninja cmake];
      buildInputs = with pkgs; [gtk3 gtk-layer-shell json_c scdoc];
    in {
      packages = rec {
        default = gtkgreet;

        gtkgreet = pkgs.stdenv.mkDerivation {
          inherit version buildInputs nativeBuildInputs;
          pname = "gtkgreet";
          mesonFlags = ["-Dlayershell=enabled"];
          env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";
          src = ./.;
        };
      };

      devShell = pkgs.mkShell {
        name = "gtkgreet-shell";
        inherit nativeBuildInputs buildInputs;
      };
    });
}
