# macOS-like Aesthetic Style Guide

This document defines the unified color system and styling guidelines for all tools in the Hyprland rice. All colors should follow macOS-inspired principles: subtle, clean, and harmonious.

---

## Color Palette

### Base Colors
| Variable | Hex | Usage |
|----------|-----|-------|
| `$background` | `#19120d` | Root background (dark warm brown) |
| `$surface` | `#19120d` | Surface background |
| `$surface_container` | `#261e18` | Elevated surfaces |
| `$surface_container_high` | `#312822` | Cards, dropdowns |
| `$surface_container_highest` | `#3c332d` | Modals, dialogs |
| `$surface_container_low` | `#221a14` | Low elevation |
| `$surface_container_lowest` | `#140d08` | Deepest level |

### Text Colors
| Variable | Hex | Usage |
|----------|-----|-------|
| `$on_background` | `#f0dfd6` | Primary text |
| `$on_surface` | `#f0dfd6` | Surface text |
| `$on_surface_variant` | `#d6c3b7` | Secondary text |
| `$outline` | `#9f8d82` | Borders, dividers |
| `$outline_variant` | `#51443b` | Subtle borders |

### Accent Colors
| Variable | Hex | Usage |
|----------|-----|-------|
| `$primary` | `#ffb780` | Primary accent (warm orange) |
| `$on_primary` | `#4e2600` | Text on primary |
| `$primary_container` | `#6d3a09` | Primary backgrounds |
| `$secondary` | `#e4bfa7` | Secondary accent |
| `$tertiary` | `#c6ca95` | Tertiary accent |

---

## Unified Opacity System

Use these opacity values for consistency across all tools:

| Element | Opacity | Hex |
|---------|---------|-----|
| Active tab/element | 12-15% | `rgba(ffffff1f)` |
| Hover state | 18-20% | `rgba(ffffff33)` |
| Inactive/background | 6-10% | `rgba(ffffff1a)` |
| Selected/focused | 20-25% | `rgba(ffffff33)` |
| Text primary | 80-90% | `rgba(ffffffcc)` |
| Text secondary | 50-60% | `rgba(ffffff99)` |
| Text disabled | 30-40% | `rgba(ffffff66)` |

---

## Per-Tool Guidelines

### Hyprland (Window Manager)

**Groupbar / Tabs:**
```
col.active = $surface_container_high
col.inactive = $surface_container
text_color = $on_surface_variant
```

**Window Borders:**
```
col.active_border = $on_primary  # Use accent
col.inactive_border = $background
```

**General:**
- Use blur (6px, 2 passes) for transparency effects
- Keep rounding consistent: 12px for windows, 8px for elements

---

### Waybar (Status Bar)

**Background:** `rgba(0,0,0,0.6)` with blur

**Modules:**
- Active: `rgba(ffffff1f)`
- Inactive: transparent
- Text: `#f0dfd6` (80%)
- Icon: `#f0dfd6` (80%)

**Spacing:**
- Module padding: 8px horizontal, 4px vertical
- Module gap: 4px

---

### Ghostty (Terminal)

**Background:** `$background` (#19120d)
**Foreground:** `$on_background` (#f0dfd6)

**Selection:** `rgba(255,183,128,0.3)` (primary at 30%)

**Cursor:**
- Color: `$primary` (#ffb780)
- Style: beam

**Syntax Highlighting (suggested):**
- Keywords: `#ffb780` (primary)
- Strings: `#c6ca95` (tertiary)
- Comments: `#9f8d82` (outline)
- Functions: `#f0dfd6`
- Variables: `#e4bfa7` (secondary)

---

### GTK / Qt Themes

**Use these values:**

| Element | CSS Variable | Value |
|---------|--------------|-------|
| Background | `--bg-color` | `#19120d` |
| Surface | `--surface-color` | `#261e18` |
| Primary | `--accent-color` | `#ffb780` |
| Text | `--text-color` | `#f0dfd6` |
| Border | `--border-color` | `#51443b` |

**For Qt5/6:**
- Use `qt5ct` and `qt6ct` with color scheme configured to match above

---

### swaync (Notifications)

**Background:** `$surface_container` (#261e18)
**Text:** `$on_surface` (#f0dfd6)

**Notification colors:**
- Urgent: `$error` (#ffb4ab)
- Normal: `$primary` (#ffb780)

---

### wlogout

**Background:** `rgba(0,0,0,0.8)` with blur

**Buttons:**
- Background: `rgba(ffffff10)`
- Hover: `rgba(ffffff20)`
- Text: `$on_background` (#f0dfd6)
- Rounding: 12px

---

### vicinae (Launcher/Menu)

**Background:** `$surface_container` (#261e18) with blur
**Border:** `$outline_variant` (#51443b)

**Items:**
- Normal: transparent
- Hover: `rgba(ffffff10)`
- Selected: `rgba(ffffff1f)`
- Text: `$on_surface` (#f0dfd6)

---

### yazi (File Manager)

**Background:** `$background` (#19120d)
**Directory:** `$primary` (#ffb780)
**File:** `$on_surface` (#f0dfd6)
**Selected:** `rgba(ffffff1f)`
**Border:** `$outline_variant` (#51443b)

---

## Rounding Standards

| Element | Radius |
|---------|--------|
| Windows | 12px |
| Cards/Containers | 8px |
| Buttons | 6px |
| Small elements | 4px |

---

## Font Guidelines

**Primary Font:** JetBrainsMono
**Fallback:** JetBrainsMono Nerd Font Propo

| Element | Size |
|---------|------|
| Status bar | 13px |
| Terminal | 14px |
| Window titles | 13px |
| Notifications | 14px |
| Menu items | 14px |

---

## Quick Reference (Copy-Paste)

### Hyprland groupbar
```hypr
groupbar {
    font_size = 13
    gradients = true
    height = 16
    gradient_rounding = 12
    text_color = $on_surface_variant
    col.active = $surface_container_high
    col.inactive = $surface_container
}
```

### Waybar CSS (add to style.css)
```css
#waybar {
    background: rgba(25, 18, 13, 0.85);
    color: @on_surface_variant;
}
module {
    color: @on_surface_variant;
}
#workspaces button.active {
    background: $surface_container_high;
    color: @on_background;
}
```

---

## Notes for LLM Styling

When adding new tools or modifying colors:

1. **Always use RGBA** for transparency — never use named colors with alpha unless defined above
2. **Keep contrast** — text should be at least 80% opacity on dark backgrounds
3. **Use opacity steps** — follow the opacity system (6%, 12%, 20%, etc.)
4. **Match existing** — reference this document first, then the matugen colors
5. **Test readability** — ensure text is readable on all backgrounds

macOS aesthetic = subtle, layered, warm dark theme with consistent accents.
