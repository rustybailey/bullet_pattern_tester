# bullet_pattern_tester
Bullet pattern testing tool for Pico-8

## What is this?
I plan to create a shmup for Pico-8, but I wanted an easy way to test different attack patterns. This started off as a simple toy to test creating a circle of bullets and expanded into a tool to play with several different variables in order to fine tune attacks.

## What can I do with it?
* Use the up and down arrow keys to navigate the menu. On each menu item press left and right to change the value.

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_33.gif)

* Press Z to hide the UI. While hidden, you can use the arrows to move the bullet pattern's origin point.
* Press X to reset the values to defaults.

### Loop On
This changes which frame bullets/bullet waves are created. Basically, how often they appear.

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_34.gif)

### Cluster Count
This affects how many bullets appear per wave. This is only enabled for the "arc" and "radial" pattern types.

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_35.gif)

### Pulse
Defaults to 0. When greater than 0, it will create bullets for X frames, and then pause for X frames.

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_36.gif)

### Rotate
Defaults to 0. When greater than 0, it will rotate the bullets clockwise, less than zero, counter-clockwise.

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_37.gif)

### Bullet Type
Square, Circle, or 3 Different Sprites

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_39.gif)

### Pattern
Cycle through all bullet pattern types: Single, Cross, Spreadshot, Arc, Semi-Circle, and Radial

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_41.gif)

So check out this code to learn or just load up the cart and play around!

![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_42.gif)
![Alt Text](https://github.com/rustybailey/bullet_pattern_tester/raw/master/gifs/bullet_pattern_tester_45.gif)
