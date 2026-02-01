# ATOM

ATOM is my personal addon for housing custom scripts and miscellaneous functionality. Over the years, I've consolidated features from addons I previously released but no longer wanted to maintain, or for which better alternatives now exist. When I need something scripted, I drop it here and move on.

## Features

### Quest Automation

- **Auto Turn-In** — Hold Ctrl while interacting with NPCs to automatically accept quests, complete turn-ins, and select rewards

### Inventory Management

- **Bag Export** — Export bag contents to text for easy sharing (`/atom bags`)
- **Auto-Destroy** — Automatically destroys heirloom gear and specified junk items
- **Underlight Angler** — Auto-re-equips the fishing artifact when unequipped

### Experience Tracking

- **Session Stats** — Tracks XP/hour, kills to level, time to level, and rested XP (`/atom xp`)
- **Real-Time Display** — Shows XP gains with percentage to next level

### Merchant Automation

- **Auto-Repair** — Repairs gear when opening a vendor
- **Auto-Sell** — Sells grey items automatically

### Mail Collection

- **Auto-Loot Mail** — Automatically collects all items and gold from mailbox (skips COD)

### Mount System

- **Smart Mounting** — Context-aware mount selection (Qiraji tank in AQ, Seahorse in Vashj'ir, etc.)
- **Flying Detection** — Prevents flying mount summons in no-fly zones

### Battle Pets

- **Round Counter** — Displays current round during pet battles
- **Powerleveling Finder** — Locates active pet trainer world quests (`/atom powerleveling`)

### UI Customization

- **Custom Fonts** — Replaces game fonts with modern alternatives (Lato, Nunito, Roboto, etc.)
- **Texture Tweaks** — Dims action bar borders and cleans up button visuals
- **Nameplate Abbreviation** — Shortens long NPC names

### Utilities

- **Raid Marking** — Cycle through raid markers (`/atom mark`)
- **Target Macros** — Generate dynamic target macros (`/atom target [name]`)
- **Waypoints** — Set map waypoints (`/atom way X Y`)
- **Profile Import/Export** — Backup and share addon profiles via Wago-style strings (`/atom wago`)
- **Zelda Loot Sounds** — Quality-based sound effects when looting items

### System Optimization

- **CVar Defaults** — Sets sensible defaults for 28+ game settings on login

## Misc

### Plater/WeakAuras

- Plater Profile https://wago.io/NsEiuppVw
- Arcane Mage https://wago.io/RuEnI73C0

### Zygor Guides

To register the guides you'll need to edit `ZygorGuidesViewer\Guides\Autoload.xml` and add the following:

```xml
<Include file="..\..\ATOM\Guides\Autoload.xml"/>
```
