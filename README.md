# Nikolas' LazyVim configuration

Personal [LazyVim](https://www.lazyvim.org/) configuration for macOS, Linux, and Windows.

## Install on Windows

Install Neovim and Git, then open PowerShell and run:

```powershell
git clone https://github.com/nikolasknapik/lazyvim-config.git "$env:LOCALAPPDATA\nvim"
nvim
```

LazyVim installs its plugins automatically during the first start. After installation, run `:LazyHealth` inside Neovim.

## Install on a Linux server (Debian/Ubuntu)

The commands below use Neovim 0.11.6, the version used with this configuration on macOS. Run them as your normal user, except for `apt`:

```sh
sudo apt update
sudo apt install -y git curl tar build-essential ripgrep fd-find unzip python3

arch=$(uname -m) # x86_64 or aarch64
case "$arch" in
  x86_64) nvim_arch=x86_64 ;;
  aarch64) nvim_arch=arm64 ;;
  *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
esac
mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
curl -fL "https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-${nvim_arch}.tar.gz" -o /tmp/nvim-linux.tar.gz
tar -C "$HOME/.local/opt" -xzf /tmp/nvim-linux.tar.gz
ln -sfn "$HOME/.local/opt/nvim-linux-${nvim_arch}/bin/nvim" "$HOME/.local/bin/nvim"
export PATH="$HOME/.local/bin:$PATH"
nvim --version | head -1
```

Add `export PATH="$HOME/.local/bin:$PATH"` to your server shell's `~/.bashrc` or `~/.zshrc` for future sessions. On Debian/Ubuntu, `fd-find` supplies `fdfind`; make the `fd` command available for file finding:

```sh
ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
```

Install the Tree-sitter CLI for parser installation (the current LazyVim requirement is version 0.26.1 or newer):

```sh
case "$(uname -m)" in x86_64) ts_arch=x64 ;; aarch64) ts_arch=arm64 ;; esac
curl -fL "https://github.com/tree-sitter/tree-sitter/releases/download/v0.27.1/tree-sitter-cli-linux-${ts_arch}.zip" -o /tmp/tree-sitter-cli.zip
unzip -o /tmp/tree-sitter-cli.zip -d "$HOME/.local/bin"
chmod u+x "$HOME/.local/bin/tree-sitter"
tree-sitter --version
```

If Neovim is already configured on the server, back up its config first. Then clone this repository and start Neovim:

```sh
test ! -e "$HOME/.config/nvim" || mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%Y%m%d-%H%M%S)"
git clone https://github.com/nikolasknapik/lazyvim-config.git "$HOME/.config/nvim"
nvim
```

The first start downloads the plugins. Inside Neovim, run `:LazyHealth` and `:checkhealth`. The committed `lazy-lock.json` pins plugin revisions; language servers, parsers, formatters, and other tools are installed separately on the server. Install only the language toolchains you use there (for example, `clang` for `<leader>rc` or Maven and Java for `<leader>rj`). Copilot needs a separate `:Copilot auth` on the server. A Nerd Font must be installed in your **local** terminal to display all icons.

On a headless server, Markdown live preview (`<leader>cp`) serves port 5500 on the server and cannot open a local browser automatically. Use SSH forwarding (`ssh -L 5500:127.0.0.1:5500 user@server`) and open `http://127.0.0.1:5500` locally.

To get later configuration changes, run `git -C "$HOME/.config/nvim" pull --ff-only`. Check [LazyVim's requirements](https://www.lazyvim.org/) if health reports a missing dependency.

## Install on macOS

```sh
git clone https://github.com/nikolasknapik/lazyvim-config.git ~/.config/nvim
nvim
```

## Custom project locations

The project picker defaults to `~/PERSONAL/projects`. To use another parent directory, set the `NVIM_PROJECTS_ROOT` environment variable before starting Neovim.

PowerShell example:

```powershell
[Environment]::SetEnvironmentVariable("NVIM_PROJECTS_ROOT", "D:\Projects", "User")
```
