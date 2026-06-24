{
  description = "Mogok dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        rustPkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
        rustToolchain = rustPkgs.rust-bin.stable."1.90.0".default.override {
          extensions = [ "rust-src" "rust-analyzer" "rustfmt" "clippy" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rustToolchain
            cargo-make
            cargo-binstall
            cargo-nextest
            diesel-cli
            pkg-config
            nodejs_22
            bun
	    sccache
            # cargo-machete, taplo, ast-grep は cargo make が binstall で管理
          ];

          buildInputs = with pkgs; [
            openssl
            postgresql.lib
          ];

          shellHook = ''
            echo "🦀 Rust: $(rustc --version)"
            echo "📦 Node: $(node --version)"
            echo "🥟 Bun: $(bun --version)"
          '';
        };
      });
}
