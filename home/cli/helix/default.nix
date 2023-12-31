{ pkgs, ... }: {
  home.packages = [
    pkgs.helix
    pkgs.alejandra

    pkgs.nodePackages.bash-language-server
    pkgs.cmake-language-server

    pkgs.zellij
    pkgs.lazygit
    pkgs.nil
    pkgs.rnix-lsp
    pkgs.rust-analyzer
    pkgs.lldb
    pkgs.clang-tools
    pkgs.ocamlPackages.ocaml-lsp
    pkgs.vscode-langservers-extracted
    pkgs.dockerfile-language-server-nodejs
    pkgs.haskellPackages.haskell-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.texlab
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.nodePackages.pyright
    pkgs.python310Packages.python-lsp-server
    pkgs.nodePackages.vue-language-server
    pkgs.yaml-language-server
    pkgs.taplo

    pkgs.vimPlugins.copilot-vim
    pkgs.tree-sitter
    (pkgs.tree-sitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    pkgs.nixpkgs-fmt
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        # line-number = "relative";
        bufferline = "always";
        mouse = true;
        true-color = true;
        color-modes = true;
        cursorline = true;
        auto-completion = true;
        completion-trigger-len = 1;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
          git-ignore = true;
        };
        soft-wrap = {
          enable = true;
        };
        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" "position-percentage" ];
          right = [ "version-control" "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
          separator = "│";
        };
        lsp = {
          enable = true;
          display-messages = true;
          auto-signature-help = true;
          # display-inlay-hints = true;
          display-signature-help-docs = true;
          snippets = true;
          goto-reference-include-declaration = true;
        };
        whitespace = {
          render = "all";
          characters = {
            space = " ";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";

            tabpad = "·"; # Tabs will look like "→···" (depending on tab width)
          };
        };
        indent-guides = {
          render = true;
          character = "╎";
        };
      };
      keys.normal = {
        esc = [ "collapse_selection" "keep_primary_selection" ];
        J = [ "delete_selection" "paste_after" ];
        K = [ "delete_selection" "move_line_up" "paste_before" ];
        C-u = [ "half_page_up" "align_view_center" ];
        C-d = [ "half_page_down" "align_view_center" ];

        "[" = "goto_previous_buffer";
        "]" = "goto_next_buffer";

        g = {
          x = ":buffer-close";
          j = "jump_backward";
          k = "jump_forward";
        };
        space = {
          l = ":toggle lsp.display-inlay-hints";
          n = ":toggle lsp.auto-signature_help";

          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
        };

        backspace = {
          b = {
            r = ":run-shell-command zellij run -fc -- cargo build";
            n = ":run-shell-command zellij run -f -- nix build";
          };

          d = {
            d = ":run-shell-command zellij run -fc -- watch --color -n 0.2 lsd /dev/ttyACM* -h --color always";
            b = ":run-shell-command zellij run -fc -- btop";
          };

          r = {
            n = ":run-shell-command zellij run -f -- nix run";
            r = ":run-shell-command zellij run -fc -- cargo run";
          };

          t = {
            n = ":run-shell-command zellij run -f -- nix test";
            r = ":run-shell-command zellij run -fc -- cargo test";
          };

          g = ":run-shell-command zellij run -fc -- lazygit";
          f = ":run-shell-command zellij run -fc -- broot";
        };
      };
    };
    languages = {

      language-server = with pkgs; with pkgs.nodePackages_latest; {
        typescript-language-server = {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
        svelteserver.command = "${svelte-language-server}/bin/svelteserver";
        tailwindcss-ls.command = "${tailwindcss-language-server}/bin/tailwindcss-language-server";
        nixd = {
          command = "${nixd}/bin/nixd";
        };
        eslint = {
          command = "${eslint}/bin/eslint";
          args = [ "--stdin" ];
        };
        # copilot = {
        #   command = "${copilot-lsp}/copilot";
        #   language-id = "copilot";
        #   args = ["--stdio"];
        # };
        nil.command = "${nil}/bin/nil";
        rust-analyzer.command = "${rust-analyzer-unwrapped}/bin/rust-analyzer";
        rust-analyzer.config = {
          "inlayHints.bindingModeHints.enable" = true;
          "inlayHints.closingBraceHints.minLines" = 10;
          "inlayHints.closureReturnTypeHints.enable" = "with_block";
          "inlayHints.discrimiinantHints.enable" = "skip_trivial";
          "inlayHints.typeHints.hideClosureInitialization" = false;
        };
      };

      #https://github.com/helix-editor/helix/blob/master/languages.toml
      language = [
        # {
        #   name = "json5";
        #   scope = "*";
        #   # shebangs = ["json"];
        # }
        {
          name = "javascript";
          formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
          language-servers = [ "typescript-language-server" "eslint" ];
          auto-format = true;
        }
        {
          name = "typescript";
          formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
          language-servers = [ "typescript-language-server" "eslint" ];
          auto-format = true;
        }
        {
          name = "svelte";
          formatter = { command = "prettier"; args = [ "--plugin" "prettier-plugin-svelte" ]; };
          language-servers = [ "tailwindcss-ls" "svelteserver" "eslint" ];
          auto-format = true;
        }
        {

          name = "nix";
          auto-format = true;
          formatter = { command = "nixpkgs-fmt"; };
          language-servers = [ "nixd" "nil" ];
        }
        {
          name = "python";
          language-servers = [ "pylsp" "pyright" ];
          formatter = { command = "black"; args = [ "--quiet" "-" ]; };
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
      ];
    };
  };
}
