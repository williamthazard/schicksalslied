---lied

engine.name = 'LiedMotor'
LiedMotor = include('lib/LiedMotor_engine')
hs = include('lib/halfsecond')
MusicUtil = require "musicutil"
sequins = require "sequins"

local my_string = " "
history = {}
local history_index = nil
local new_line = false

running = false 

function step()
    while true do
        clock.sync(s:step(2)()/s:step(3)())
        if running then
            local note_num = s()
            local freq = MusicUtil.note_num_to_freq(note_num)
            LiedMotor.trig(freq)
        end
    end
end

function key(n,z)
  if n==3 and z==1 then
    -- K3 toggles playback
    running = not running
  end
end

function init()
  LiedMotor.add_params() -- adds params via the `.add params()` function defined in LiedMotor_engine.lua
  screen.aa(0)
  print("lied")
  hs.init()
  clock.run(step)
end

function remap(ascii)
    ascii = ascii % 32 + 48
    return ascii
end

function processString(s)
    local tempScalar = {}
      for i = 1, #s do
        table.insert(tempScalar,remap(s:byte(i)))
      end
    return tempScalar
end

s = sequins(processString(my_string))
  
function set()
    s:settable(processString(my_string))
end

function keyboard.char(character)
  my_string = my_string .. character -- add characters to my string
  redraw()
end

function keyboard.code(code,value)
  if value == 1 or value == 2 then -- 1 is down, 2 is held, 0 is release
    if code == "BACKSPACE" then
      my_string = my_string:sub(1, -2) -- erase characters from my_string
    elseif code == "UP" then
      if #history > 0 then -- make sure there's a history
        if new_line then -- reset the history index after pressing enter
          history_index = #history
          new_line = false
        else
          history_index = util.clamp(history_index - 1, 1, #history) -- increment history_index
        end
        my_string = history[history_index]
      end
    elseif code == "DOWN" then
      if #history > 0 and history_index ~= nil then -- make sure there is a history, and we are accessing it
        history_index = util.clamp(history_index + 1, 1, #history) -- decrement history_index
        my_string = history[history_index]
      end
    elseif code == "ENTER" and #my_string > 0 then
        set()
        table.insert(history, my_string) -- append the command to history
        my_string = "" -- clear my_string
        new_line = true
    end
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.level(10)
  screen.rect(2, 50, 125, 14)
  screen.stroke()
  screen.move(5,59)
  screen.text("> " .. my_string)
  if #history > 0 then
    history_index = #history -- this is always the last entered command
    screen.move(5, 45)
    screen.text(history[history_index])
    if history_index >= 2 then screen.move(5, 35) screen.text(history[history_index - 1]) end -- command before last
    if history_index >= 3 then screen.move(5, 25) screen.text(history[history_index - 2]) end -- command before the command before last
  end
  screen.update()
end
