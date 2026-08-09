# Nikolas' LazyVim configuration

Personal, cross-platform [LazyVim](https://www.lazyvim.org/) configuration for macOS and Windows.

## Install on Windows

Install Neovim and Git, then open PowerShell and run:

```powershell
git clone https://github.com/nikolasknapik/lazyvim-config.git "$env:LOCALAPPDATA\nvim"
nvim
```

LazyVim installs its plugins automatically during the first start. After installation, run `:LazyHealth` inside Neovim.

## Install on macOS or Linux

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
