# Remove Settings NEW Badges

A World of Warcraft addon that removes all "NEW" badges/tags from the Settings panel.

## What it does

Removes the yellow "NEW" labels that appear throughout the Settings UI when Blizzard adds new options in a patch:

- **Category sidebar badges** — the "NEW" labels next to category names like "Gameplay Enhancements"
- **Section header tags** — the "NEW" tags on section headers like "External Defensives", "Boss Warnings", "Nameplates"
- **Individual setting controls** — any per-setting NEW indicators
- **Micro menu notification pip** — the notification dot on the Game Menu button

## How it works

1. Marks all entries in `NewSettingsSeen` as viewed
2. Wipes the `NewSettings` table so `IsNewSettingInCurrentVersion()` returns false for everything
3. Hooks `SettingsCategoryListButtonMixin:RefreshNewFeature` to force-hide sidebar badges

## Installation

Copy the `RemoveSettingsNotification` folder into your `Interface/AddOns` directory, or install via your preferred addon manager.