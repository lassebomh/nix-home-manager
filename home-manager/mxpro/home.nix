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

	programs.zsh = {
		enable = true;
	}

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
