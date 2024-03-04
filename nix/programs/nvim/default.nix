{
  lib,
  pkgs,
  config,
  home-manager,
  ...
}: let
  inherit (config) cryo;
  cfg = config.cryo.programs.nvim;
  isEnabled = cfg.enable && cryo.enable;
in {
  options.cryo.programs.nvim = {
    enable = lib.mkEnableOption "Enable neovim configuration";
  };

  config = lib.mkIf isEnabled {
    home-manager.users = {
      ${cryo.username} = {
        xdg.configFile.nvim = {
          source = ./nvim;
          recursive = true;
        };

        home = {
          packages = with pkgs; [
            ripgrep
          ];
        };

        programs = {
          neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

            # Overrides init.lua, source from $XDG_CONFIG_HOME/nvim/source.lua
            extraLuaConfig = ''
              vim.g.nix = {
                paths = {
                  omnisharp_roslyn = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
                  rust_analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
                  clippy = "${pkgs.clippy}/bin/clippy-driver";
                  netcoredbg = "${pkgs.netcoredbg}/bin/netcoredbg";
                };
              };
              require('source')
            '';

            plugins = with pkgs.vimPlugins; [
              telescope-nvim
              nvim-treesitter.withAllGrammars
              harpoon
              playground
              undotree
              vim-fugitive
              direnv-vim
              copilot-vim

              # https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
              lsp-zero-nvim
              nvim-lspconfig
              nvim-cmp
              cmp-nvim-lsp
              cmp-nvim-lsp-signature-help
              cmp-nvim-lsp-document-symbol
              luasnip

              # https://aaronbos.dev/posts/debugging-csharp-neovim-nvim-dap
              nvim-dap
              nvim-dap-ui

              nvim-tree-lua
              nvim-web-devicons

              rose-pine
              dracula-nvim

              vim-be-good
            ];

            extraPackages = with pkgs; [
              omnisharp-roslyn
              rust-analyzer
              clippy
              netcoredbg
            ];
          };
        };
      };
    };
  };
}
