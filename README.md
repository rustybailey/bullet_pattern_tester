# bullet_pattern_tester
Bullet pattern testing tool for Pico-8

## What is this?
I plan to create a shmup for Pico-8, but I wanted an easy way to test different attack patterns. This started off as a simple toy to test creating a circle of bullets and expanded into a tool to play with several different variables in order to fine tune attacks.

## What can I do with it?
Use the up and down arrow keys to navigate the menu. On each menu item press left and right to change the value.

### Loop On
This changes which frame bullets are created. Basically, how often they appear.

### Cluster Count
This affects how many bullets appear per wave. This is only enabled for the "arc" and "radial" pattern types.

### Pulse
Defaults to 0. When greater than 0, it will create bullets for X frames, and then pause for X frames.

### Bullet Type
Square, Circle, or a ball-like Sprite

### Pattern
Single, Cross, Spreadshot, Arc, Radial


