# WezTerm Config

A WezTerm configuration for Windows 11 + WSL2. Opens PowerShell 7 by default, with one key to jump into WSL Ubuntu at `~/repo` (configurable).

## Installation

The config must live in `%USERPROFILE%\.config\wezterm\`. From the root of this repository, run in PowerShell:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\wezterm" | Out-Null
Copy-Item -Recurse -Force ".\wezterm\*" "$env:USERPROFILE\.config\wezterm\"
```

## Features

- Catppuccin Mocha color scheme, Maple Mono Normal NFM CN at 14pt
- 85% opacity with Acrylic blur (rendered with OpenGL on Windows, since WebGpu does not support window transparency there)
- Windows are maximized on startup and when newly opened, keeping the taskbar visible
- Title bar buttons integrated into the tab bar, with Windows-style icons; the close button turns red on hover
- Capsule tabs: index, program icon (pwsh / powershell / cmd / WSL), manual tab name takes priority, unseen-output count for background tabs, OSC 9;4 progress icon
- When WezTerm runs as administrator, local shell tabs show a shield icon (detected at startup with `fltmc`)
- Left-clicking `+` opens the launch menu: PowerShell 7 / WSL:Ubuntu / Windows PowerShell / Command Prompt
- Inactive panes at 50% brightness, scrollbar at least 3 rows tall, 100000 lines of scrollback

## Key Bindings

All built-in WezTerm key bindings are disabled. Every binding uses the `Ctrl+Shift` prefix.

### Panels and Editing

| Key | Action |
|---|---|
| `Ctrl+Shift+M` | Command palette |
| `Ctrl+Shift+Y` | Tab navigator |
| `Ctrl+Shift+C` / `V` | Copy / paste |
| `Ctrl+Shift+S` | Search |
| `Ctrl+Shift+U` | Label links on screen with letters; press a letter to open it in the browser |

In search mode: `Enter` / `↑` previous match, `↓` next match, `Ctrl+R` cycle match type, `Ctrl+U` clear, `Esc` exit.

### Tabs

| Key | Action |
|---|---|
| `Ctrl+Shift+T` | New PowerShell 7 tab |
| `Ctrl+Shift+B` | New WSL:Ubuntu tab (opens `~/repo` by default) |
| `Ctrl+Shift+Q` | Close tab (with confirmation) |
| `Ctrl+Shift+[` / `]` | Previous / next tab |
| `Ctrl+Shift+,` / `.` | Move tab left / right |
| `Ctrl+Shift+1` … `9` | Switch to tab 1–9 |
| `Ctrl+Shift+R` | Rename tab (submit empty to restore the automatic name) |

### Panes

| Key | Action |
|---|---|
| `Ctrl+Shift+\` | Split left / right |
| `Ctrl+Shift+/` | Split top / bottom |
| `Ctrl+Shift+Z` | Maximize / restore current pane |
| `Ctrl+Shift+A` | Close pane (with confirmation) |
| `Ctrl+Shift+I` / `K` / `J` / `L` | Move to the pane above / below / left / right |
| `Ctrl+Shift+G` | Label panes with numbers; press a number to swap it with the current pane |

### Font Size and Scrolling

| Key | Action |
|---|---|
| `Ctrl+Shift+↑` / `↓` | Increase / decrease font size |
| `Ctrl+Shift+=` | Reset font size to 14 |
| `Ctrl+Shift+PgUp` / `PgDn` | Scroll up / down 0.6 page |
| `Ctrl+Shift+Home` / `End` | Jump to the top / bottom of scrollback |

### Reserved Keys

The following `Ctrl+Shift` combinations are left unbound for other programs:
`P`, `O`, `X`, `D`, `F`, `W`, `H`, `N`, `E`, `←`, `→`, `Enter`

## File Structure

| File | Contents |
|---|---|
| `wezterm/wezterm.lua` | Entry point: admin detection, event registration, config merging |
| `wezterm/config/init.lua` | Config merging, warns on duplicate keys |
| `wezterm/config/general.lua` | Update check, bell, scrollback lines |
| `wezterm/config/appearance.lua` | Rendering, colors, transparency, tab bar, title bar buttons, padding, command palette |
| `wezterm/config/fonts.lua` | Fonts |
| `wezterm/config/launch.lua` | Default shell, launch menu, WSL domain |
| `wezterm/config/bindings.lua` | Key and mouse bindings |
| `wezterm/events/tab-title.lua` | Capsule tabs |
| `wezterm/events/new-tab-button.lua` | `+` button and launch menu |
| `wezterm/events/left-status.lua` | Shows the mode name on the left in search and other modes |
| `wezterm/events/window-maximize.lua` | Maximize on startup and for new windows |
| `wezterm/colors/palette.lua` | Catppuccin Mocha colors for custom-drawn UI |

## Credits

This configuration is adapted from:

- [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config) 
- [QianSong1/wezterm-config](https://github.com/QianSong1/wezterm-config)
- [vivy89/wezterm-config](https://github.com/vivy89/wezterm-config)