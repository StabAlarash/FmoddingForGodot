# FMODding for Godot

This is a Godot (4.7+) game project to use as an example for FMOD integration.

## Installation

- You need to have [Godot](https://godotengine.org/download) installed locally on your machine (at least version 4.7).
- You can either git clone the repository locally or download the [latest release](https://github.com/StabAlarash/FmoddingForGodot/releases)
- Once the source code is available locally through git clone or unzipping the release:
- open Godot and choose Import in the Project Manager
- Navigate to the project directory, select project.godot and Open
- Finally click on Import with the Edit Now option to open the project in Godot

You may experience some error messages when yu first open the project, this usually happens with addons.
This shouldn't be a problem though, you can always click on Project | Reload Current Project once loaded for the first time to fix those.

## Running the Game

To run the game, click on the Run Project icon (play arrow found on the top right of the editor) or press F5.

### Controls

- **Move**: WASD keys or Left Stick
- **Look**: Mouse move or Right Stick
- **Run**: Shift or Left Trigger
- **Crouch**: Control or Joypad Button 1
- **Jump**: Space or Joypad Button 0
- **Weapon Charge and Release**: Left Mouse Button or Right SHould
- **Weapon Focus**: Right Mouse Button or Right Trigger
- **Interact**: E or Joypad Button 3
- **Pause**: Escape or Start Button
- **Toggle Light**: F or Joypad Button 2


## External Addons used

- **quality-godot-first-person**: https://git.colormatic.org/ColormaticStudios/quality-godot-first-person
- **FMOD GDExtension**: https://github.com/utopia-rise/fmod-gdextension

---

## FMOD Project

The FMOD project used by the game is located here: assets/fmod/project.fspro

[FMOD Studio 2.3](https://www.fmod.com) was used to make the project.


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