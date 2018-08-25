pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- bullet pattern tester
-- by rusty bailey

function make_bullet(bullets, x, y, angle, color, type)
  local bullet = {
    x = x + .5,
    y = y + .5,
    r = 2,
    speed = 1,
    angle = angle,
    color = color,
    type = type,
    init = function(self)
      -- square
      if (self.type == 1) then
        self.w = 1
        self.h = 1
      end

      -- circle
      if (self.type == 2) then
        self.w = 4
        self.h = 4
      end

      -- sprite
      if (self.type == 3) then
        self.w = 6
        self.h = 6
      end
    end,
    update = function(self)
      self.x += self.speed * sin(self.angle/360)
      self.y += self.speed * cos(self.angle/360)

      if (self.x < 0 or self.x > 128 or self.y < 0 or self.y > 128) then
        del(bullets, self)
      end
    end,
    draw = function(self)
      -- square
      if (self.type == 1) then
        rectfill(self.x - self.w/2, self.y - self.h/2, self.x + self.w, self.y + self.h, self.color)
      end

      -- circle
      if (self.type == 2) then
        circfill(self.x, self.y, self.r, self.color)
      end

      -- sprite
      if (self.type == 3) then
        spr(6, self.x - self.w/2, self.y - self.h/2)
      end
    end
  }
  bullet:init()
  add(bullets, bullet)
end

function make_attack_pattern(x, y, pattern, loop_number, cluster_count, pulse, bullet_type, rotate_speed)
  return {
    x = x,
    y = y,
    counter = 0,
    current_color = 1,
    pattern = pattern,
    loop_number = loop_number,
    cluster_count = cluster_count,
    pulse = pulse,
    pulse_count = 0,
    pulse_off = false,
    colors_light_to_dark = {10,7,15,11,6,9,12,14,13,3,8,4,5,2,1},
    bullet_type = bullet_type,
    bullets = {},
    rotate_counter = 0,
    rotate_speed = rotate_speed,
    make_wave = function(self, color)
      -- single
      if self.pattern == 1 then
        make_bullet(self.bullets, self.x, self.y, 0 + self.rotate_counter, color, self.bullet_type)
      end

      -- cross
      if self.pattern == 2 then
        make_bullet(self.bullets, self.x, self.y, 0 + self.rotate_counter, color, self.bullet_type)
        make_bullet(self.bullets, self.x, self.y, 90 + self.rotate_counter, color, self.bullet_type)
        make_bullet(self.bullets, self.x, self.y, -90 + self.rotate_counter, color, self.bullet_type)
      end

      -- spreadshot
      if self.pattern == 3 then
        make_bullet(self.bullets, self.x, self.y, 0 + self.rotate_counter, color, self.bullet_type)
        make_bullet(self.bullets, self.x, self.y, 10 + self.rotate_counter, color, self.bullet_type)
        make_bullet(self.bullets, self.x, self.y, -10 + self.rotate_counter, color, self.bullet_type)
      end

      -- cone
      if self.pattern == 4 then
        local full_deg = 45
        local increment = (full_deg * 2)/(self.cluster_count - 1)
        for i=-full_deg + self.rotate_counter, full_deg + self.rotate_counter, increment do
          make_bullet(self.bullets, self.x, self.y, i, color, self.bullet_type)
        end
      end

      -- semi-circle
      if self.pattern == 5 then
        local full_deg = 90
        local increment = (full_deg * 2)/(self.cluster_count - 1)
        for i=-full_deg + self.rotate_counter, full_deg + self.rotate_counter, increment do
          make_bullet(self.bullets, self.x, self.y, i, color, self.bullet_type)
        end
      end

      -- radial
      if self.pattern == 6 then
        local full_deg = 180
        local increment = (full_deg * 2)/(self.cluster_count)
        for i=-full_deg + self.rotate_counter, full_deg + self.rotate_counter, increment do
          make_bullet(self.bullets, self.x, self.y, i, color, self.bullet_type)
        end
      end
    end,
    update = function(self)
      -- if (self.rotate_speed < 0) then
        self.rotate_counter += self.rotate_speed
      -- end

      self.counter += 1
      if (self.counter > self.loop_number) then

        self.counter = 1
        self.pulse_count += 1
        if (self.pulse_count == self.pulse) then
          self.pulse_off = not self.pulse_off
          self.pulse_count = 0
        end

        if (not self.pulse_off) then
          self.current_color += 1

          if (self.current_color > #self.colors_light_to_dark) then
            self.current_color = 1
          end

          self:make_wave(self.colors_light_to_dark[self.current_color])
        end
      end

      for bullet in all(self.bullets) do
        bullet:update()
      end
    end,
    draw = function(self)
      for key, bullet in pairs(self.bullets) do
        bullet:draw()
      end
    end
  }
end
attack = make_attack_pattern(64, 64, 1, 10, 20, 0, 1, 0)

bullet_types = {
  'square',
  'circle',
  'sprite'
}
patterns = {
  'single',
  'cross',
  'spreadshot',
  'cone',
  'semi-circle',
  'radial'
}
menu = {
  x = 4,
  y = 5,
  current_selection = 1,
  btn_was_pressed_times = 0,
  menu_items = {
    {
      name = "loop",
      disabled = false,
      decrement = function(self)
        attack.loop_number -= 1
        if (attack.loop_number < 1) then
          attack.loop_number = 1
        end
      end,
      increment = function(self)
        attack.loop_number += 1
      end,
      draw = function(self, x, y)
        print('loop on: ' .. attack.loop_number, x, y, text_color)
      end
    },
    {
      name = "cluster",
      disabled = true,
      decrement = function(self)
        attack.cluster_count -= 1
        if (attack.cluster_count < 1) then
          attack.cluster_count = 1
        end
      end,
      increment = function(self)
        attack.cluster_count += 1
      end,
      draw = function(self, x, y)
        local color = text_color
        if (self.disabled) then
          color = 1
        end
        print('cluster count: ' .. attack.cluster_count, x, y, color)
      end
    },
    {
      name = "pulse",
      disabled = false,
      decrement = function(self)
        attack.pulse -= 1
        if (attack.pulse < 0) then
          attack.pulse = 0
        end
        attack.pulse_count = 0
        attack.pulse_off = false
      end,
      increment = function(self)
        attack.pulse += 1
        attack.pulse_count = 0
        attack.pulse_off = false
      end,
      draw = function(self, x, y)
        print('pulse: ' .. attack.pulse, x, y, text_color)
      end
    },
    {
      name = "rotate",
      disabled = false,
      decrement = function(self)
        attack.rotate_speed -= 1
      end,
      increment = function(self)
        attack.rotate_speed += 1
      end,
      draw = function(self, x, y)
        print('rotate: ' .. attack.rotate_speed, x, y, text_color)
      end
    },
    {
      name = "bullet type",
      disabled = false,
      decrement = function(self)
        attack.bullet_type -= 1
        if (attack.bullet_type <= 0) then
          attack.bullet_type = #bullet_types
        end
      end,
      increment = function(self)
        attack.bullet_type += 1
        if (attack.bullet_type > #bullet_types) then
          attack.bullet_type = 1
        end
      end,
      draw = function(self, x, y)
        print('bullet type: ' .. bullet_types[attack.bullet_type], x, y, text_color)
      end
    },
    {
      name = "pattern",
      disabled = false,
      decrement = function(self)
        attack.pattern -= 1
        if (attack.pattern <= 0) then
          attack.pattern = #patterns
        end
        self:toggle_cluster_count()
      end,
      increment = function(self)
        attack.pattern += 1
        if (attack.pattern > #patterns) then
          attack.pattern = 1
        end
        self:toggle_cluster_count()
      end,
      toggle_cluster_count = function(self)
        if (patterns[attack.pattern] == 'cone' or patterns[attack.pattern] == 'semi-circle' or patterns[attack.pattern] == 'radial') then
          menu.menu_items[2].disabled = false
        else
          menu.menu_items[2].disabled = true
        end
      end,
      draw = function(self, x, y)
        print('pattern: ' .. patterns[attack.pattern], x, y, text_color)
      end
    },
  },
  init = function(self)
    self.current_selection = 1
    self.btn_was_pressed_times = 0
    self.menu_items[2].disabled = true
    attack.x = 64
    attack.y = 64
    attack.pattern = 1
    attack.loop_number = 10
    attack.cluster_count = 20
    attack.pulse = 0
    attack.bullet_type = 1
    attack.rotate_counter = 0
    attack.rotate_speed = 0
  end,
  update = function(self)
    -- menu controls could have been handled by native btnp,
    -- but i didn't like how slow it was when you held down
    -- the button, so i wrote my own method

    -- up
    if self:btnp(2) then
      self.current_selection -= 1
      if (self.current_selection < 1) then
        self.current_selection = #self.menu_items
      end
      if (self.menu_items[self.current_selection].disabled) then
        self.current_selection -= 1
      end
    end

    -- down
    if self:btnp(3) then
      self.current_selection += 1
      if (self.current_selection > #self.menu_items) then
        self.current_selection = 1
      end
      if (self.menu_items[self.current_selection].disabled) then
        self.current_selection += 1
      end
    end

    -- left
    if self:btnp(0) then
      self.menu_items[self.current_selection]:decrement()
    end

    -- right
    if self:btnp(1) then
      self.menu_items[self.current_selection]:increment()
    end

    -- keep track of # times btn is pressed
    self:count_btn_presses()

    menu_cursor:update()
  end,
  btnp = function(self, button_number)
    return btn(button_number) and self:should_handle_btn_press()
  end,
  should_handle_btn_press = function(self)
    return self.btn_was_pressed_times == 0 or self.btn_was_pressed_times > 30
  end,
  count_btn_presses = function(self)
    if btn(0) or btn(1) or btn(2) or btn(3) then
      self.btn_was_pressed_times += 1
    else
      self.btn_was_pressed_times = 0
    end
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
  text_color = 9
  show_ui = true
  menu:init()
end

function _update60()
  if btnp(4) then
    show_ui = not show_ui
  end
  if btnp(5) then
    _init()
  end
  attack:update()

  if (show_ui) then
    menu:update()
  else
    -- if the menu is hidden, then you can move the attack pattern
    if btn(0) then
      attack.x -= 1
    end

    if btn(1) then
      attack.x += 1
    end

    if btn(2) then
      attack.y -= 1
    end

    if btn(3) then
      attack.y += 1
    end
  end
end

function _draw()
  cls()

  attack:draw()

  if (show_ui) then
    -- print stats
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

    menu:draw()
  end
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
