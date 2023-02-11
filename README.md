# Fire 'n Ice
[Fire 'n Ice](https://en.wikipedia.org/wiki/Fire_'n_Ice) clone programed in Godot as a hobby.

The player controls an ice mage that should clear all fires in each stage to win.

Godot is an free software to create games. Its two main advantages are the export to HTML5/Cellphone/Desktop feature and the included level editor. Fire 'n Ice game would be easier and faster to program and develop the game engine from scratch, but release and level design would be very time consuming.

## Controls
 * **Mouse** to select stage.
 * **Left** and **right** move the mage, push an ice block or climb short walls.
 * **Down** create/remove an ice just bellow and a little ahead of the mage.

## TODO
 * Restart mission when player touchs the fire;
 * Ice fall on fire do not erase both always;
 * When some ice fall or is removed, verify element above.

## Code organization
The tree structure is:
Phase
|-- TileMap
    |-- player