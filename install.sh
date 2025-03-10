#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

DESTINATION_PATH="/usr/local/bin"
SCRIPT_NAME="h2mm"
REPO_URL="https://raw.githubusercontent.com/v4n00/h2mm-cli/refs/heads/master"

function log() {
	local type="$1"
	shift
	case "$type" in
		INFO)
			echo -e "$*" >&2
			;;
		ERROR)
			echo -e "${RED}[ERROR]${NC} $*" >&2
			;;
		PROMPT)
			echo -ne "$*" >&2
			;;
		*)
			echo -e "$*" >&2
			;;
	esac
}

# --- Main ---

# warning

cat << EOF
!!! WARNING !!!
This script will install Helldivers 2 Mod Manager CLI for Linux to $DESTINATION_PATH/$SCRIPT_NAME.
Running this script will require sudo permissions. DO NOT TRUST random scripts from the internet.
If you want to review the script before running it, check out the mod repository for yourself:
https://github.com/v4n00/h2mm-cli
!!! WARNING !!!

EOF

# check if update

# breaking changes hash table
breaking_changes_patches=(
    ["2"]='sed -i "s/^\([0-9]\+\),/\1,ENABLED,/" "$1/mods.csv"'
    ["3"]='sed -i "1 i\\3" "$1/mods.csv"'
)

# handle breaking changes
if [[ -x "$(command -v $SCRIPT_NAME)" ]]; then
    installed_version=$($SCRIPT_NAME --version)
    # version 1 show the help message, if the first character is not a 0, store installed version as 0.1.6
    [[ ${installed_version:0:1} != "0" ]] && { installed_version="0.1.6"; }

    latest_version=$(curl -sS "$REPO_URL"/version)
    if [[ "$latest_version" == "$installed_version" ]]; then
        log INFO "You are reinstalling version ${GREEN}$installed_version${NC}."
    else
        log INFO "You are upgrading from ${ORANGE}$installed_version${NC} -> ${GREEN}$latest_version${NC}."
    fi

    # split version numbers
    installed_major=""
    latest_major=""
    IFS='.' read -r _1 installed_major _2 <<< "$installed_version"
    IFS='.' read -r _1 latest_major _2 <<< "$latest_version"

    if [[ $latest_major -gt $installed_major ]]; then
        log INFO "Major version upgrade detected."
        log INFO "Check out the changelogs here -> https://github.com/v4n00/h2mm-cli/releases"
        log INFO "The script will proceed to upgrade the database file to avoid breaking changes."

        # find hd2 path
        search_dir="${HOME}"
        target_dir="Steam/steamapps/common/Helldivers\ 2/data"
        log INFO "Searching for the Helldivers 2 data directory... (20 seconds timeout)"

        game_dir=$(timeout 20 find "$search_dir" -type d -path "*/$target_dir" 2>/dev/null | head -n 1)
        if [[ -z "$game_dir" ]]; then
			log INFO "Could not find the Helldivers 2 data directory automatically."
			log PROMPT "Please enter the path to the Helldivers 2 data directory: "
			IFS= read -e game_dir
			if [[ ! -d "$game_dir" ]]; then
				log ERROR "Provided path is not a valid directory."
				exit 1
			fi
		fi

        [[ ! -f "$game_dir/mods.csv" ]] && { log ERROR "mods.csv not found in $game_dir." ; exit 1; }

        # iterate from installed major number to latest major number
        for ((i = installed_major + 1; i <= latest_major; i++)); do
            if [[ -n "${breaking_changes_patches[$i]}" ]]; then
                eval $(echo "${breaking_changes_patches[$i]}" | sed "s:\$1:$game_dir:")
            else
                log INFO "No breaking changes for version $i."
            fi
            if [[ $? -ne 0 ]]; then
                log ERROR "Failed to apply breaking changes patch for version $i. Do you want to continue? (Y/n): "
                read -er response

                [[ "$response" != "y" && "$response" != "Y" && -n "$response" ]] && { log INFO "Exiting. Uninstall the script, then retry the install script." ; exit 1; }
            else
                log INFO "Breaking changes patch for version ${ORANGE}$i${NC} applied ${GREEN}successfully${NC}."
            fi
        done
    fi
    log INFO ""
fi

# if steam deck, set destination path to ~/.local/bin
log PROMPT "Are you installing on a Steam Deck? (y/N): "
IFS= read -e response_sd

if [[ "$response_sd" == "y" || "$response_sd" == "Y" ]]; then
    # steam deck
    DESTINATION_PATH="$HOME/.local/bin"
    mkdir -p "$DESTINATION_PATH"

    # check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        # add ~/.local/bin to PATH
        log INFO "Installing the script on a Steam Deck means adding $DESTINATION_PATH to your \$PATH."
        log INFO "If you're using a different shell than bash, you may need to add it manually."

		log PROMPT "Do you want to add $DESTINATION_PATH to your \$PATH in ~/.bashrc? (Y/n): "
        IFS= read -e response
        if [[ "$response" == "y" || "$response" = "Y" || -z "$response" ]]; then
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc"

			[[ $? -ne 0 ]] && { log ERROR "Failed to add $DESTINATION_PATH to \$PATH in ~/.bashrc." ; exit 1; }
            log INFO "Added $DESTINATION_PATH to your \$PATH in ~/.bashrc."
        fi
    fi
else
    # not steam deck
    # set another path if needed
	log PROMPT "Install the script to $DESTINATION_PATH or specify another path (must be included in \$PATH)? (Y/path): "
    IFS= read -e response

    if [[ "$response" != "y" && "$response" != "Y" && -n "$response" ]]; then
        DESTINATION_PATH="$response"
        [[ ! -d "$DESTINATION_PATH" ]] && { log ERROR "Path $DESTINATION_PATH does not exist." ; exit 1; }
    fi
fi

# install
log INFO "Installing $SCRIPT_NAME to $DESTINATION_PATH."
sudo curl "$REPO_URL"/h2mm --output "$DESTINATION_PATH/$SCRIPT_NAME"
sudo chmod +x "$DESTINATION_PATH/$SCRIPT_NAME"

[[ ! -x "$(command -v $SCRIPT_NAME)" ]] && { log ERROR "Installation failed. Mod manager was not found in \$PATH." ; exit 1; }
log INFO "Helldivers 2 Mod Manager CLI ${GREEN}successfully${NC} installed: $DESTINATION_PATH/$SCRIPT_NAME."
log INFO "Use it by running '$SCRIPT_NAME'. Made with love <3 by v4n and contributors."
