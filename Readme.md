# FE4 Bachelor's Mode

This is a patch which removes the two fixed pairings

## Building The Patch

### Requirements

- [Asar version 1.81](https://github.com/RPGHacker/asar/releases/tag/v1.81)

### Building

Run the following in a terminal or command line instance:

```bash
asar main.asm [path/to/your/rom]
```

## Changes

- Adjusted Deirdre and Ethlyn's lvoe pooint bases/growths so they can be paired with other units.
- Adjusted the inheritance mechanism to allow Gáe Bolg to be inherited like other holy weapons.
- Moved the Steel Lance from the Chapter 8 vendor to Altena's starting inventory in case she doesn't inherit anything else.
- Allower the Chapter 10 Palmark event to be activate by any unit, as long as they're Sigurd's primary child.
