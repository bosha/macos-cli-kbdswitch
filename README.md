# MacOS keyboard switch cli utility

A small Swift script that allows you to list configured keyboard layouts in macOS and switch between them. I use this script in Neovim to automatically switch the language to English when returning to 'Normal' mode.

**WARNING: I'm not a Swift developer, and this script is provided as-is. It may break at any time. Use at your own risk.**

## Installation

- Ensure you have development tools installed on macOS (this includes the Swift compiler and Git).
- Clone the repository.
- Run `make compile` to compile the script and save the binary in the current directory (`./kbdswitch`). You can also run `make move` to move the binary to the `~/bin/` directory. The script will prompt you to create the directory if it doesn't already exist.

```bash
git clone https://github.com/bosha/macos-cli-kbdswitch.git
cd macos-cli-kbdswitch
make compile
```

## Usage

### List Available Layouts

To list all configured keyboard layouts, use the `list` command:

```bash
➜ ~  kbdswitch list
com.apple.keylayout.ABC
com.apple.CharacterPaletteIM
com.apple.PressAndHold
com.apple.keylayout.RussianWin
com.apple.inputmethod.ironwood
```

### Get Current Active Layout

To get current layout, use the `get` command:

```bash
➜ ~  kbdswitch get
com.apple.keylayout.ABC
```

### Switch Layouts

To switch to a specific layout, use the `set` command followed by the layout ID:

```bash
kbdswitch set com.apple.keylayout.ABC
```

## Automatic Layout Switching in Neovim

You can automatically switch the keyboard layout when entering Neovim's '_Normal_' mode by adding the following Lua snippet to your Neovim configuration file:

```lua
if vim.fn.executable("kbdswitch") == 1 then
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			vim.api.nvim_command("silent !kbdswitch set com.apple.keylayout.ABC")
		end,
	})
end
```

- Use the `kbdswitch list` command to find the layout ID you want to switch to.
- Replace `com.apple.keylayout.ABC` in the snippet with your desired layout ID.
- This snippet registers an autocommand in Neovim if `kbdswitch` is found in your `$PATH`. The autocommand will switch the keyboard layout when you enter Neovim's '_Normal_' mode.
