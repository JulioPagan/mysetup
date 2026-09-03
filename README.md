# mysetup

My macOS dev environment: [Ghostty](https://ghostty.org) + [LazyVim](https://lazyvim.org),
themed Catppuccin Mocha throughout, with a [Starship](https://starship.rs) prompt.

## Layout

```
ghostty/config          -> ~/.config/ghostty/config
nvim/                   -> ~/.config/nvim
starship/starship.toml  -> ~/.config/starship.toml
git/gitconfig           -> ~/.gitconfig
git/ignore              -> ~/.config/git/ignore
zsh/zshrc               -> ~/.zshrc
zsh/zshenv              -> ~/.zshenv
Brewfile                   packages, casks and VS Code extensions
install.sh                 symlinks the above into place
```

## Fresh machine

```sh
# 1. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. This repo
git clone git@github.com:JulioPagan/mysetup.git ~/code/mysetup
cd ~/code/mysetup

# 3. Packages (installs ghostty's font, neovim, starship, fzf, ripgrep, fd, ...)
brew bundle --file=Brewfile

# 4. Symlink the configs
./install.sh
```

Then open `nvim` once — lazy.nvim bootstraps itself and installs plugins at the
versions pinned in `nvim/lazy-lock.json`.

`install.sh` never overwrites: anything already at a target path is moved to
`<path>.backup.<timestamp>` first. Run `DRY_RUN=1 ./install.sh` to preview.

## Notes

- **Ghostty** is installed outside Homebrew; grab it from
  [ghostty.org/download](https://ghostty.org/download). Its config expects
  `font-jetbrains-mono-nerd-font`, which the Brewfile installs.
- **Neovim** is the LazyVim starter. `nvim/lazyvim.json` holds the enabled
  language extras (clangd, docker, git, go, json, markdown, python, rust, sql,
  tailwind, terraform, toml, typescript) — that file is the setup, so keep it
  committed. `~/.config/nvim` is symlinked as a whole directory, so LazyVim
  writes `lazy-lock.json` updates straight into this repo; commit them after a
  `:Lazy update`.
- **Node** is managed by `fnm` (`--use-on-cd`), not Homebrew.
- `zsh/zshrc` uses `$HOME` rather than a hardcoded `/Users/jpagan`, so it works
  on any machine.
- Not tracked here: `~/.ssh`, `~/.aws`, `~/.docker` and other credential-bearing
  directories.

## Refreshing the Brewfile

```sh
brew bundle dump --file=Brewfile --force
```

Re-check afterwards — `dump` has been observed to omit tap-qualified formulae
(`sumo`, `terraform`, `stripe`) and `cmake`; those lines are maintained by hand.
