pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function make_ball(x, y, angle, color)
  return {
    x = x + .5,
    y = y + .5,
    r = 2,
    speed = .5,
    angle = angle,
    color = color,
    update = function(self)
      self.x += self.speed * sin(self.angle/360)
      self.y += self.speed * cos(self.angle/360)

      if (self.x < 0 or self.x > 127 or self.y < 0 or self.y > 127) then
        del(balls, self)
      end
    end,
    draw = function(self)
      rectfill(self.x, self.y, self.x + 1, self.y + 1, self.color)
    end
  }
end
balls = {}

function make_cluster(number, color)
  local full_deg = 360
  local increment = full_deg/number
  for i=increment, full_deg, increment do
    add(balls, make_ball(64, 64, i, color))
  end
end

counter = 1
color = 1

max_counter = 30
max_cluster_count = 16
max_color = 15

function _init()
end

function _update60()
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

  counter += 1
  if (counter > max_counter) then
    counter = 1
    color += 1
    if (color > max_color) then
      color = 1
    end
    make_cluster(max_cluster_count, color)
  end

  for ball in all(balls) do
    ball:update()
  end
end

function _draw()
  cls()

  rect(0, 0, 127, 127, 8)
	for ball in all(balls) do
    ball:draw()
  end

  print('balls: ' .. count(balls), 6, 6)
  print('counter: ' .. counter, 6, 12)
  print('loop on: ' .. max_counter, 6, 18)
  print('cluster count: ' .. max_cluster_count, 6, 24)
end