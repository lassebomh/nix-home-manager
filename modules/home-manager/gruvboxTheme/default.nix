{ config, pkgs, lib, ... }:

with lib;

let
	cfg = config.kirk.git;
in {
	options.kirk.git = {
		#enable = mkEnableOption "git";

		colorscheme = {
			bg = "282828";
			fg = "ebdbb2";

			black  = "1d2021";
			white  = "d5c4a1";
			orange = "d65d0e";
			red    = "cc241d";
			green  = "98971a";
			yellow = "d79921";
			blue   = "458588";
			purple = "b16286";
			teal   = "689d6a";

			bright = {
				black  = "928374";
				white  = "fbf1c7";
				orange = "fe8019";
				red    = "fb4934";
				green  = "b8bb26";
				yellow = "fabd2f";
				blue   = "83a598";
				purple = "d3869b";
				teal   = "8ec07c";
			};
		};
	};
}
