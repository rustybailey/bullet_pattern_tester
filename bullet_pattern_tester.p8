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

function make_spread_shot(number, color)
  add(bullets, make_bullet(64, 64, 0, color))
  add(bullets, make_bullet(64, 64, 10, color))
  add(bullets, make_bullet(64, 64, -10, color))
end

function make_cross_cluster(number, color)
  add(bullets, make_bullet(64, 64, 0, color))
  add(bullets, make_bullet(64, 64, 90, color))
  add(bullets, make_bullet(64, 64, -90, color))
end

function make_single_shot(number, color)
  add(bullets, make_bullet(64, 64, 0, color))
end

counter = 1
color = 1

max_counter = 30
max_cluster_count = 16
max_color = 15

function _init()
end

function _update60()
  -- todo: make the controls less sensitive, single press should increment one and then if you hold the key for a bit it will scroll
  -- todo: don't let it go below zero
  -- todo: enhance into an actual menu of items to increase/decrease; up/down goes through menu items (frequency/grouping count/burst), left/right changes value

  if (btn(0)) then
    max_counter += 1
  end

  if (btn(1)) then
    max_counter -= 1
  end

  if (btn(2)) then
    max_cluster_count += 1
  end

  if (btn(3)) then
    max_cluster_count -= 1
  end

  -- todo: change counter to loop through 60 frames, make different var for frequency?
  counter += 1
  if (counter > max_counter) then
    counter = 1
    color += 1
    if (color > max_color) then
      color = 1
    end
    make_arc_cluster(max_cluster_count, color)
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

  print('bullets: ' .. count(bullets), 6, 6)
  print('counter: ' .. counter, 6, 12)
  print('loop on: ' .. max_counter, 6, 18)
  print('cluster count: ' .. max_cluster_count, 6, 24)

  print ('fps: ' .. stat(7), 95, 6)
  rect(0, 0, 127, 127)
end