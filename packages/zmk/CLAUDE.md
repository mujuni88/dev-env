# ZMK Keyboard Firmware

## Build Commands

- **Build Glove80**: `./build.sh`
- **Build Go60**: `./build-go60.sh`

## Post-Build

After building firmware, always open the `.uf2` file in Finder so the user can easily drag it to the keyboard:

```bash
# For Go60
open -R /Users/jbuza/dev-env/packages/zmk/go60.uf2

# For Glove80
open -R /Users/jbuza/dev-env/packages/zmk/glove80.uf2
```

## Flash Instructions

1. Put keyboard in bootloader mode (hold corner key while plugging in USB)
2. Drag the `.uf2` file to the mounted drive
3. Repeat for second half (split keyboards)
