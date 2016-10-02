 # ~/.nixpkgs/config.nix
 
  {
    packageOverrides = super: let self = super.pkgs; in
    {
      haskellDevEnv = self.haskellPackages.ghcWithPackages (p: with p; [
        async attoparsec caseInsensitive fgl GLUT GLURaw haskellSrc
        hashable html HTTP HUnit mtl network OpenGL OpenGLRaw parallel
        parsec QuickCheck random regexBase regexCompat regexPosix split stm
        syb text transformers unorderedContainers vector /*xhtml*/ zlib
        # tools
        cabalInstall
        ghcMod
        xmonad xmonadContrib xmonadExtras xmobar
        haskintex
      ]);
 
      haskellPackages = super.haskellPackages.override {
        extension = self: super: {
          abcnotation = self.callPackage ./abcnotation.nix {};
          prettify = self.callPackage ./prettify.nix {};
        };
      };
    };
  }
