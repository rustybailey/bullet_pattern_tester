pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- bullet pattern tester
-- by rusty bailey

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
      if (current_bullet_type == 1) then
        rectfill(self.x, self.y, self.x + 1, self.y + 1, self.color)
      end

      if (current_bullet_type == 2) then
        circfill(self.x, self.y, self.r, self.color)
      end

      if (current_bullet_type == 3) then
        spr(6, self.x - 3, self.y - 3)
      end
    end
  }
end
bullets = {}
bullet_types = { 'square', 'circle', 'sprite' }

function make_bullet_pattern(number, color, current_pattern)
  patterns[current_pattern]:make_wave(number, color)
end

patterns = {
  {
    name = 'single',
    make_wave = function(self, number, color)
      add(bullets, make_bullet(64, 64, 0, color))
    end
  },
  {
    name = 'cross',
    make_wave = function(self, number, color)
      add(bullets, make_bullet(64, 64, 0, color))
      add(bullets, make_bullet(64, 64, 90, color))
      add(bullets, make_bullet(64, 64, -90, color))
    end
  },
  {
    name = 'spreadshot',
    make_wave = function(self, number, color)
      add(bullets, make_bullet(64, 64, 0, color))
      add(bullets, make_bullet(64, 64, 10, color))
      add(bullets, make_bullet(64, 64, -10, color))
    end
  },
  {
    name = 'arc',
    make_wave = function(self, number, color)
      local full_deg = 90
      local increment = 180/number
      for i=-90, full_deg, increment do
        add(bullets, make_bullet(64, 64, i, color))
      end
    end
  },
  {
    name = 'radial',
    make_wave = function(self, number, color)
      local full_deg = 360
      local increment = full_deg/number
      for i=increment, full_deg, increment do
        add(bullets, make_bullet(64, 64, i, color))
      end
    end
  }
}

menu = {
  current_selection = 1,
  x = 4,
  y = 5,
  btn_is_pressed = false,
  btn_was_pressed_times = 0,
  menu_items = {
    {
      name = "loop",
      disabled = false,
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
        print('loop on: ' .. max_counter, x, y, text_color)
      end
    },
    {
      name = "cluster",
      disabled = true,
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
        local color = text_color
        if (self.disabled) then
          color = 1
        end
        print('cluster count: ' .. max_cluster_count, x, y, color)
      end
    },
    {
      name = "pulse",
      disabled = false,
      decrement = function(self)
        pulse -= 1
        if (pulse < 0) then
          pulse = 0
        end
        pulse_count = 0
        pulse_off = false
      end,
      increment = function(self)
        pulse += 1
        pulse_count = 0
        pulse_off = false
      end,
      draw = function(self, x, y)
        print('pulse: ' .. pulse, x, y, text_color)
      end
    },
    {
      name = "bullet type",
      disabled = false,
      decrement = function(self)
        current_bullet_type -= 1
        if (current_bullet_type <= 0) then
          current_bullet_type = #bullet_types
        end
      end,
      increment = function(self)
        current_bullet_type += 1
        if (current_bullet_type > #bullet_types) then
          current_bullet_type = 1
        end
      end,
      draw = function(self, x, y)
        print('bullet type: ' .. bullet_types[current_bullet_type], x, y, text_color)
      end
    },
    {
      name = "pattern",
      disabled = false,
      decrement = function(self)
        current_pattern -= 1
        if (current_pattern <= 0) then
          current_pattern = #patterns
        end
        self:toggle_cluster_count()
      end,
      increment = function(self)
        current_pattern += 1
        if (current_pattern > #patterns) then
          current_pattern = 1
        end
        self:toggle_cluster_count()
      end,
      toggle_cluster_count = function(self)
        if (patterns[current_pattern].name == 'arc' or patterns[current_pattern].name == 'radial') then
          menu.menu_items[2].disabled = false
        else
          menu.menu_items[2].disabled = true
        end
      end,
      draw = function(self, x, y)
        print('pattern: ' .. patterns[current_pattern].name, x, y, text_color)
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
        if (self.menu_items[self.current_selection].disabled) then
          self.current_selection -= 1
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
        if (self.menu_items[self.current_selection].disabled) then
          self.current_selection += 1
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

function _init()
  version = 'v2.0'

  counter = 1
  current_color = 1
  current_pattern = 1

  text_color = 9

  pulse = 0
  pulse_count = 0
  pulse_off = false
  max_counter = 10
  max_cluster_count = 20
  colors_dark_to_light = {1,2,5,4,8,3,13,14,12,9,6,11,15,7,10}
  colors_light_to_dark = {10,7,15,11,6,9,12,14,13,3,8,4,5,2,1}
  current_bullet_type = 1
end

function _update60()
  menu:update()

  counter += 1
  if (counter > max_counter) then
    counter = 1
    pulse_count += 1
    if (pulse_count == pulse) then
      pulse_off = not pulse_off
      pulse_count = 0
    end

    if (not pulse_off) then
      current_color += 1

      if (current_color > #colors_light_to_dark) then
        current_color = 1
      end

      make_bullet_pattern(max_cluster_count, colors_light_to_dark[current_color], current_pattern)
    end
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

  local max_width = 128
  local margin = 5
  local letter_width = 4
  local letter_height = 7

  local mem = "mem: " .. flr(stat(0))
  local cpu_stat = flr(stat(1) * 100)
  if cpu_stat < 10 then
    cpu_stat = " " .. cpu_stat
  end
  local cpu = "cpu: " .. cpu_stat
  local fps = "fps: " .. stat(7)
  local stats = { version, mem, cpu, fps }

  for i = 1, #stats do
    print(
      stats[i],
      max_width - (#stats[i] * letter_width) - margin,
      margin + (letter_height * (i - 1)),
      text_color
    )
  end
  -- print(version, max_width - (#version * letter_width) - margin, margin, text_color)
  -- print(mem, max_width - (#mem * letter_width) - margin, margin + letter_height * 1, text_color)
  -- print(cpu, max_width - (#cpu * letter_width) - margin, margin + letter_height * 2, text_color)
  -- print(fps, max_width - (#fps * letter_width) - margin, margin + letter_height * 3, text_color)
  -- line(0, 4, 127, 4, 15)

  menu:draw()
  rect(0, 0, 127, 127, text_color)
end

__gfx__
0000000000000000000a0000000c00000a0000000aaa000004444000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000aaa00000ccc000aaa00000aaaaa00044474400000000000000000000000000000000000000000000000000000000000000000000000000
007007000000000000aaa00000ccc000aa700000aa7aa00044447400000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000aa7aa000cc7cc00aa700000aaa7a00044447400000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000aaa7a000ccc7c00aaa00000aaa7a00044444400000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000aaa7a000ccc7c0099900000aaaaa00004444000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000aaaaa000ccccc00000000009999900000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000099999000ddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
