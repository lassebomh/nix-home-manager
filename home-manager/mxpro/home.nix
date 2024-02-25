# My home manager config
{ pkgs, config, ... }:
let
	configDir = "${config.home.homeDirectory}/.system-configuration";
	username = "lasse";
	machine = "mxpro";
in {
	kirk = {
		homeManagerScripts = { enable = true; configDir = configDir; machine = machine; };
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

	kirk.foot.enable = true;

	programs.zsh = {
		enable = true;

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

	home.packages = with pkgs; [
		# Misc
		gnome.gnome-tweaks
		thunderbird

		# Browsers
		chromium

		# Media
		qbittorrent
		#mpv

		# Chat
		slack
		signal-desktop

		# Fonts
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
		fira-code

		# Document handling
		texlive.combined.scheme-full
		pandoc
		inotify-tools

		# Misc Terminal Tools
		yt-dlp
	];
}
