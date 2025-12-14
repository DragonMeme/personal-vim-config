# My VIM setup.

The file structure being used to make my vim setup.

## Requirements.

* vim (should be available in many linux distributions)

## Setup.

1. If permission issues occur, run this command:
```bash
chmod u+x setup.sh
```
2. Run the command (The `--backup` flag is optional so you can restore your current vim setup.):
```bash
./setup.sh --backup
```
3. Open `vim` via the command and execute:
```vim
:PlugUpdate
```
