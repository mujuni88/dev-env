# Instructions for updating turbo.json

To complete the dotbot integration, please update your root `turbo.json` file with these changes:

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "sync": {
      "cache": false,
      "outputs": []
    },
    "build": {
      "outputs": ["dist/**"]
    }
  }
}
```

The existing `bun run setup` command will now automatically handle all aspects:
1. Install dependencies (`bun install`)
2. Sync all packages, including dotfiles (`bun run sync`)

Your updated workflow:
- `devsetup` runs nixswitch first, then setup (which includes dotfiles sync)
- All tools are managed through nix/homebrew