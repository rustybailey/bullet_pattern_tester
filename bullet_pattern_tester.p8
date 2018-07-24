pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function make_bullet(x, y, angle, color)
  return {
    x = x + .5,
    y = y + .5,
    r = 2,
    speed = 1,
    angle = angle,
    color = color,
    update = function(self)
      self.x += self.speed * sin(self.angle/360)
      self.y += self.speed * cos(self.angle/360)

      if (self.x < 0 or self.x > 127 or self.y < 0 or self.y > 127) then
        del(bullets, self)
      end
    end,
    draw = function(self)
      rectfill(self.x, self.y, self.x + 1, self.y + 1, self.color)
    end
  }
end
bullets = {}

-- todo: rename to grouping?
-- todo: add pulse/burst frequency
function make_radial_cluster(number, color)
  local full_deg = 360
  local increment = full_deg/number
  for i=increment, full_deg, increment do
    add(bullets, make_bullet(64, 64, i, color))
  end
end

function make_arc_cluster(number, color)
  local full_deg = 90
  local increment = 180/number
  for i=-90, full_deg, increment do
    add(bullets, make_bullet(64, 64, i, color))
  end
end

function make_spreadshot(color)
  add(bullets, make_bullet(64, 64, 0, color))
  add(bullets, make_bullet(64, 64, 10, color))
  add(bullets, make_bullet(64, 64, -10, color))
end

function make_cross_cluster(color)
  add(bullets, make_bullet(64, 64, 0, color))
  add(bullets, make_bullet(64, 64, 90, color))
  add(bullets, make_bullet(64, 64, -90, color))
end

function make_single_shot(color)
  add(bullets, make_bullet(64, 64, 0, color))
end

function make_bullet_pattern(number, color, pattern)
  if (pattern == 1) then
    make_single_shot(color)
  elseif (pattern == 2) then
    make_cross_cluster(color)
  elseif (pattern == 3) then
    make_spreadshot(color)
  elseif (pattern == 4) then
    make_arc_cluster(number, color)
  elseif (pattern == 5) then
    make_radial_cluster(number, color)
  end
end

counter = 1
color = 1
pattern = 1

patterns = {
  'single',
  'cross',
  'spreadshot',
  'arc',
  'radial'
}

max_counter = 10
max_cluster_count = 20
max_color = 15

function _init()
end

menu = {
  current_selection = 1,
  x = 4,
  y = 5,
  btn_is_pressed = false,
  btn_was_pressed_times = 0,
  menu_items = {
    {
      name = "loop",
      decrement = function(self)
        max_counter -= 1
        if (max_counter < 1) then
          max_counter = 1
        end
      end,
      increment = function(self)
        max_counter += 1
      end,
      draw = function(self, x, y)
        print('loop on: ' .. max_counter, x, y)
      end
    },
    {
      name = "cluster",
      decrement = function(self)
        max_cluster_count -= 1
        if (max_cluster_count < 1) then
          max_cluster_count = 1
        end
      end,
      increment = function(self)
        max_cluster_count += 1
      end,
      draw = function(self, x, y)
        print('cluster count: ' .. max_cluster_count, x, y)
      end
    },
    {
      name = "pattern",
      decrement = function(self)
        pattern -= 1
        if (pattern <= 0) then
          pattern = #patterns
        end
      end,
      increment = function(self)
        pattern += 1
        if (pattern > #patterns) then
          pattern = 1
        end
      end,
      draw = function(self, x, y)
        print('pattern: ' .. patterns[pattern], x, y)
      end
    },
  },
  update = function(self)
    self.btn_is_pressed = false
    if (btn(2)) then
      if self.btn_was_pressed_times == 0 or self.btn_was_pressed_times > 30 then
        self.current_selection -= 1
        if (self.current_selection < 1) then
          self.current_selection = #self.menu_items
        end
      end
      self.btn_is_pressed = true
    end

    if (btn(3)) then
      if self.btn_was_pressed_times == 0 or self.btn_was_pressed_times > 30 then
        self.current_selection += 1
        if (self.current_selection > #self.menu_items) then
          self.current_selection = 1
        end
      end
      self.btn_is_pressed = true
    end

    if (btn(1)) then
      if self.btn_was_pressed_times == 0 or self.btn_was_pressed_times > 30 then
        self.menu_items[self.current_selection]:increment()
      end
      self.btn_is_pressed = true
    end

    if (btn(0)) then
      if self.btn_was_pressed_times == 0 or self.btn_was_pressed_times > 30 then
        self.menu_items[self.current_selection]:decrement()
      end
      self.btn_is_pressed = true
    end

    if self.btn_is_pressed == true then
      self.btn_was_pressed_times += 1
    else
      self.btn_was_pressed_times = 0
    end

    menu_cursor:update()
  end,
  draw = function(self)
    for i, item in pairs(self.menu_items) do
      local x = menu_cursor.width + ((menu_cursor.x - 1) * 2)
      local y = (i - 1) * menu_cursor.height + menu_cursor.y_offset + 1
      item:draw(x, y)
    end
    menu_cursor:draw()
  end
}

menu_cursor = {
  sprite = 5,
  x = 4,
  y_offset = 4,
  y = 4,
  width = 6,
  height = 7,
  update = function(self)
    self.y = (menu.current_selection - 1) * self.height + self.y_offset
  end,
  draw = function(self)
    spr(self.sprite, self.x, self.y)
  end
}

function _update60()
  menu:update()

  -- todo: change counter to loop through 60 frames, make different var for frequency?
  counter += 1
  if (counter > max_counter) then
    counter = 1
    color += 1
    if (color > max_color) then
      color = 1
    end

    make_bullet_pattern(max_cluster_count, color, pattern)
  end

  for bullet in all(bullets) do
    bullet:update()
  end
end

function _draw()
  cls()

  for bullet in all(bullets) do
    bullet:draw()
  end

  print('fps: ' .. stat(7), 95, 5)

  menu:draw()
  rect(0, 0, 127, 127)
end

__gfx__
0000000000000000000a0000000c00000a0000000aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000aaa00000ccc000aaa00000aaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000000000aaa00000ccc000aa700000aa7aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000aa7aa000cc7cc00aa700000aaa7a00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000aaa7a000ccc7c00aaa00000aaa7a00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000aaa7a000ccc7c0099900000aaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaaa000ccccc00000000009999900000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000099999000ddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
