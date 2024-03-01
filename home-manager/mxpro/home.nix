# My home manager config
{ pkgs, config, ... }:
let
	configDir = "${config.home.homeDirectory}/.system-configuration";
	username = "lasse";
	machine = "mxpro";
in {
	kirk = {
		homeManagerScripts = { enable = true; configDir = configDir; machine = machine; };
		fonts.enable = true;
		foot = {
			enable = true;
			alpha = 1.0;
		};
	};

	home.username = username;
	home.homeDirectory = "/home/${username}";

	home.stateVersion = "22.11";

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	
	targets.genericLinux.enable = true;

	nix = {
		package = pkgs.nix;
		settings.experimental-features = [ "nix-command" "flakes" ];
	};

	programs.zsh = {
		enable = true;

		localVariables = { LD_LIBRARY = "${pkgs.zlib}/lib:$LD_LIBRARY_PATH"; };
		
		enableAutosuggestions = true;
		syntaxHighlighting.enable = true;
		oh-my-zsh.enable = true;

		profileExtra = ''

		# Enable gnome discovery of nix installed programs
		export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

		# Fix nix path, see: https://github.com/nix-community/home-manager/issues/2564#issuecomment-994943471
		export NIX_PATH=''${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
		'';

		initExtra = ''
		#alias ls="exa --icons"

		alias nix-shell="nix-shell --run 'zsh'"
		alias rustfmt="cargo +nightly fmt"
		alias todo="$EDITOR ~/.local/share/todo.md"
		alias g="git"
		# TODO: this is bad, generalize...
		alias t="foot </dev/null &>/dev/null zsh &"

		gc() {
			git clone --recursive $(wl-paste)
		}

		# What is this?
		if [[ $1 == eval ]]
		then
			"$@"
		set --
		fi
		'';

		plugins = [
		{
		  name = "gruvbox-powerline";
		  file = "gruvbox.zsh-theme";
		  src = pkgs.fetchFromGitHub {
		    owner = "rasmus-kirk";
		    repo = "gruvbox-powerline";
		    rev = "bf5d9422acadfa7b4e834e7117bc8dbc1947004e";
		    sha256 = "sha256-bEVR0bKcUBLM8QdyyIWnmnxNl9aCusS8BS6D/qbnIig=";
		  };
		}
		{
		  name = "zsh-completions";
		  src = pkgs.fetchFromGitHub {
		    owner = "zsh-users";
		    repo = "zsh-completions";
		    rev = "0.34.0";
		    sha256 = "1c2xx9bkkvyy0c6aq9vv3fjw7snlm0m5bjygfk5391qgjpvchd29";
		  };
		}
		];
	};

	programs.bash = {
		enable = true;
		profileExtra = ''
			# Fix programs not showing up
			export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

			export NIX_PATH=''${NIX_PATH:+$NIX_PATH:}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
		'';

		initExtra = "exec zsh";
	};

	programs.vscode = {
		enable = true;
		extensions = with pkgs.vscode-extensions; [
			bbenoist.nix
			nonylene.dark-molokai-theme
			christian-kohler.path-intellisense
			ms-toolsai.jupyter
			ms-python.python
			ritwickdey.liveserver
			svelte.svelte-vscode
			astro-build.astro-vscode
			golang.go
		];
		userSettings = {
			"workbench.colorTheme" = "Dark (Molokai)";
			"extensions.ignoreRecommendations" = true;
			"jupyter.askForKernelRestart" = false;
			"editor.cursorSurroundingLines" = 6;
			"editor.cursorSurroundingLinesStyle" = "default";
			"editor.fontFamily" = "Fira Code";
			"editor.fontLigatures" = true;
			"editor.semanticHighlighting.enabled" = true;
			"editor.minimap.showSlider" = "always";
			"editor.stickyTabStops" = true;
			"explorer.confirmDragAndDrop" = false;
			"explorer.autoReveal" = false;
			"explorer.confirmDelete" = false;
			"task.allowAutomaticTasks" = "on";
			"notebook.output.wordWrap" = true;
			"notebook.lineNumbers" = "on";
			"git.ignoreMissingGitWarning" = true;
			"git.openRepositoryInParentFolders" = "never";
			"security.workspace.trust.untrustedFiles" = "open";
			"security.workspace.trust.enabled" = false;
			"svelte.enable-ts-plugin" = true;
			"liveServer.settings.donotVerifyTags" = true;
			"liveServer.settings.donotShowInfoMsg" = true;
		};
		keybindings = [
			{
				key = "ctrl+up";
				command = "cursorMove";
				args = {
					to = "up";
					by = "line";
					value = 5;
				};
			}
			{
				key = "ctrl+shift+up";
				command = "cursorMove";
				args = {
					to = "up";
					by = "line";
					value = 5;
					select = true;
				};
			}
			{
				key = "ctrl+down";
				command = "cursorMove";
				args = {
					to = "down";
					by = "line";
					value = 5;
				};
			}
			{
				key = "ctrl+shift+down";
				command = "cursorMove";
				args = {
					to = "down";
					by = "line";
					value = 5;
					select = true;
				};
			}
			{
				key = "alt+left";
				command = "cursorHome";
				when = "editorTextFocus";
			}
			{
				key = "alt+right";
				command = "cursorEnd";
				when = "editorTextFocus";
			}
			{
				key = "shift+alt+right";
				command = "cursorEndSelect";
				when = "editorTextFocus";
			}
			{
				key = "shift+alt+left";
				command = "cursorHomeSelect";
				when = "editorTextFocus";
			}
			{
				key = "ctrl+tab";
				command = "workbench.action.nextEditor";
			}
			{
				key = "ctrl+shift+tab";
				command = "workbench.action.previousEditor";
			}
			{
				key = "ctrl+;";
				command = "python-brackets.nest";
			}
		];
	};

	home.packages = with pkgs; [
		# Dev
		python310
		python310Packages.virtualenv
		nodejs_18
		github-desktop

		# Tools
		yt-dlp
		pandoc

		# General
		thunderbird
		chromium
		qbittorrent
		mpv

		# Chat
		slack
		signal-desktop
		discord

		# Misc
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
		fira-code
		gnome.gnome-tweaks
		texlive.combined.scheme-full
		inotify-tools
	];
}
