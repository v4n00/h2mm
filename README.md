# Helldivers 2 Mod Manager CLI

Helldivers 2 Mod Manager CLI is a command line interface for managing Helldivers 2 mods. Since there is no Linux mod manager available and I like being a nerd by using CLI tools instead of GUIs, this project was born.

This script is complete, the version will always [remain at 0.x.x](https://0ver.org/)

## Installation

Pre-requisites:

- You must have the `unzip` package installed for zip archives;
- You might want to have the `unarchiver` package installed for rar archives.

> The `unzip` package comes pre-installed on most Linux distributions. If you do not know how to install packages, search for your Linux distro and package manager.

To install Helldivers 2 Mod Manager CLI run the following command in your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/v4n00/h2mm-cli/refs/heads/master/install.sh)"
```

> [!CAUTION]
> Running this script will require sudo permissions. **DO NOT TRUST** random scripts from the internet. If you want to review the script before running it, check out the mod repository for yourself.

If for some reason, the installation command doesn't work you can:

1. Go to <https://raw.githubusercontent.com/v4n00/h2mm-cli/refs/heads/master/install.sh>
1. Right click -> Save page as...
1. Open your terminal
1. Go to your downloads folders with `cd ~/Downloads`
1. Give the script execution permissions `chmod +x install.sh`
1. Run the script `./install.sh`

## Usage

The script gets added to `/usr/local/bin/h2mm` and can be used by running `h2mm` in your shell, which will show the help message explaining how to use the script.

```bash
h2mm
```

### Available commands

- `install` - Install a mod by the file provided (directory, zip, patch).
- `uninstall` - Uninstall a mod.
- `list` - List all installed mods.
- `enable` - Enable a mod.
- `disable` - Disable a mod.
- `export` - Export installed mods to a zip file.
- `import` - Import mods from a zip file.
- `order` - Change load order for a mod.
- `modpack-create` - Create a modpack from the currently installed mods.
- `modpack-switch` - Switch to a modpack.
- `modpack-list` - List all installed modpacks.
- `modpack-delete` - Delete a modpack.
- `modpack-overwrite` - Overwrite a modpack.
- `modpack-reset` - Reset all installed modpacks.
- `update` - Update h2mm to latest version.
- `reset` - Reset all installed mods.
- `help` - Display this help message.

### Basic usage

To find out how to use a command, you can run `h2mm <COMMAND> --help`.

#### Install mod(s)

```bash
h2mm install /path/to/mod.zip
h2mm install /path/to/mod/files
h2mm install /path/to/mod.zip /path/to/mod2.zip /path/to/mod/files
h2mm install -n "Example mod" mod.patch_0 mod.patch_0.stream # -n is mandatory when using files
h2mm install -n "Example mod" mod* # using a wildcard to include all files
```

#### Uninstall a mod

```bash
h2mm uninstall -n "Example mod"
h2mm uninstall -i 3
```

#### Enable/disable mods

```bash
h2mm enable -n "Example mod"
h2mm enable -i 3
h2mm disable -n "Example mod"
h2mm disable -i 3
```

#### List installed mods

```bash
h2mm list
```

#### Updating the script

```bash
h2mm update
```

## Compatibility

The script is developed and tested on Arch Linux, but it should work on other Linux distributions as well. If you encounter any issues, please open an issue on the repository.

Status of platforms:

- Linux :white_check_mark:
- Steam Deck :white_check_mark:
- Windows - WSL :white_check_mark:

> The script works on WSL, but you need to specify the path to the Helldivers 2 mods directory manually, to find your Windows partition head to `/mnt/` and from there go to your Helldivers 2 data directory, on a typical install it should be on `/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/Helldivers\ 2/data`. You also need to have `unzip` installed, which can be done by running `sudo apt install unzip`.

## Advanced usage

### Shortcuts

You can use the short form of commands to save some time. The shortcuts are:

- `i` for `install`
- `u` for `uninstall`
- `e` for `enable`
- `d` for `disable`
- `l` for `list`
- `ex` for `export`
- `im` for `import`
- `o` for `order`
- `mc` for `modpack-create`
- `ms` for `modpack-switch`
- `ml` for `modpack-list`
- `md` for `modpack-delete`
- `mo` for `modpack-overwrite`
- `mr` for `modpack-reset`
- `up` for `update`
- `r` for `reset`

### Modpacks support

You can set up modpacks by using the `modpack-*` commands. This allows you to quickly change between a set of mods. For more information, check the help message.

```bash
h2mm modpack-create -n "Modpack 1"
# install, enable, disable other mods...
h2mm modpack-create -n "Modpack 2"
h2mm modpack-switch -n "Modpack 1"
```

### Exporting and importing

You can export all installed mods to a zip file and import mods from the same file. This can be useful for sharing mods with others or for backing up your mods. The archive file (`.tar.gz`) will be saved in the current directory.

```bash
h2mm export
h2mm import /path/to/mods.tar.gz
```

### Resetting all installed mods

You can reset all installed mods by running the following command. This will remove all installed mods and the database, in case things go wild.

```bash
h2mm reset
```

### Database location and details

The database is stored in the `Helldivers 2` install directory, under the `data` folder with the name `mods.csv`, where the mods are also installed. The database is a simple CSV file which you can use to manually manage mods if needed, you can mostly use it to rename or reorder mods.

## Contributing

Feel free to contribute to this project by creating a pull request or opening an issue.
