# FMODding for Godot

## External Addons used

- **quality-godot-first-person**: https://git.colormatic.org/ColormaticStudios/quality-godot-first-person
- **FMOD GDExtension**: https://github.com/utopia-rise/fmod-gdextension

---

## FMOD Project

The FMOD project used by the game is located here: assets/fmod/project.fspro

## Available Events

### Music

- **Music_Main**

### Player

#### Movement

- **FootStep**
- **Jump**
- **Landing**

#### Bow

- **Bow Draw**
- **Bow Shoot**
- **Arrow Woosh**
- **Arrow Hit**

### Door

- **Door Open**
- **Door Close**


## Available Parameters

- **Time**: time of the day (0..24)
- **Surface**: the surface the player is walking on (Wood, Grass, Rock, Dirt)
- **Zone**: the level zone the player is currently in (Village, Forest, Lake, Cave)
- **SubZone**: specific area within the zone (None, InsideBuilding)
- **Underwater**: 1 if player underwater, 0 otherwise
- **Tension**: not used yet (0..1)