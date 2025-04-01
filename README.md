# Neovim Config

All my config for neovim

## Installation

Of corse first of all clone this repository on your `.config` directory

```bash
git clone https://github.com/Tanque40/nvim.git ~/.config/nvim
```

After clone the packer with the given instruction:

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Enter in `nvim` and run `:PackerSync`

## Remaps

| Old key    | Remap        | Use                                              |
| ---------- | ------------ | ------------------------------------------------ |
| \<leader\> | \<spacebar\> | Spacebar has now the leader use for instructions |
| :Ex        | \<leader\>pv | Back to explorer                                 |

## Cheatsheet

| Key          | Use                                                     |
| ------------ | ------------------------------------------------------- |
| %            | Create file                                             |
| d            | Create directory                                        |
| :w           | Write changes                                           |
| :q           | Quite editor                                            |
| :Ex          | Explorer                                                |
| \<leader\>pf | Find files with telescope                               |
| \<leader\>ps | Find project source files with telescope                |
| Cntrl-p      | Find git managed repository source files with telescope |
