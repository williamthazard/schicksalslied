---lied

engine.name = 'LiedMotor'
LiedMotor = include('lib/LiedMotor_engine')
MusicUtil = require "musicutil"
sequins = require "sequins"
fileselect = require 'fileselect'

selectedfile = _path.dust.."audio/hermit_leaves.wav"

local my_string = " "
history = {}
local history_index = nil
local new_line = false

running = false 
going = false

starter = 1
firstrate = 1
secondrate = 1
thirdrate = 1

function softcut_init()
  softcut.buffer_clear()
  for i=1,6 do
    softcut.enable(i,1)
    softcut.level(i,1.0)
    softcut.buffer(i,i%2+1)
    softcut.position(i,1)
    softcut.play(i,0)
    softcut.level_slew_time(i,1.0)
    softcut.phase_quant(i,0.125)
  end
  softcut.voice_sync(2,1,0)
  softcut.voice_sync(4,3,0)
  softcut.voice_sync(6,5,0)
  softcut.pan(1,-1)
  softcut.pan(2,1)
  softcut.pan(3,-1)
  softcut.pan(4,1)
  softcut.pan(5,-1)
  softcut.pan(6,1)
  softcut.event_phase(update_positions)
  softcut.poll_start_phase()
end

function load_sample(file)
  print(file)  
end

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

function update_positions(i,pos)
  my_positions[i] = pos - 1
end

my_positions = {}

function softone()
  while true do
    clock.sync(s:step(4)()/s:step(5)())
    if going then
      local ch,length,rate = audio.file_info(selectedfile)
      if length/rate > 300 then length = 300
        else length = length/rate
      end
      local firstposition = util.linlin(49,80,1,length-0.5,s:step(6)())
      softcut.position(1,firstposition)
      local firstrateslew = 1/s:step(7)()
      softcut.rate_slew_time(1,firstrateslew)
      local firstrate = (s:step(8)()/s:step(9)())
      softcut.rate(1,firstrate)
      local firstfade = 1/s:step(10)()
      softcut.fade_time(1,firstfade)
      softcut.position(2,firstposition)
      softcut.rate_slew_time(2,firstrateslew)
      softcut.rate(2,firstrate)
      softcut.fade_time(2,firstfade)
      if s:step(11)() >= 17 then
        local firstend = s:step(12)()
        local realend = firstposition + firstend
        if realend > length then realend = length
          else realend = firstend
        end
        softcut.loop(1,1)
        softcut.loop(2,1)
        softcut.loop_start(1,firstposition)
        softcut.loop_end(1,realend)
        softcut.loop_start(2,firstposition)
        softcut.loop_end(2,realend)
      else
        softcut.loop(1,0)
        softcut.loop(2,0)
      end
    end
  end
end

function softtwo()
  while true do
    clock.sync(s:step(13)()/s:step(14)())
    if going then
      local ch,length,rate = audio.file_info(selectedfile)
      if length/rate > 300 then length = 300
        else length = length/rate
      end
      local secondposition = util.linlin(49,80,1,length-0.5,s:step(15)())
      softcut.position(3,secondposition)
      local secondrateslew = 1/s:step(16)()
      softcut.rate_slew_time(3,secondrateslew)
      local secondrate = (s:step(17)()/s:step(18)())
      softcut.rate(3,secondrate)
      local secondfade = 1/s:step(19)()
      softcut.fade_time(3,secondfade)
      softcut.position(4,secondposition)
      softcut.rate_slew_time(4,secondrateslew)
      softcut.rate(4,secondrate)
      softcut.fade_time(4,secondfade)
      if s:step(20)() >= 17 then
        local secondend = s:step(21)()
        local realend = secondposition + secondend
        if realend > length then realend = length
          else realend = secondend
        end
        softcut.loop(3,1)
        softcut.loop(4,1)
        softcut.loop_start(3,secondposition)
        softcut.loop_end(3,realend)
        softcut.loop_start(4,secondposition)
        softcut.loop_end(4,realend)
      else
        softcut.loop(3,0)
        softcut.loop(4,0)
      end
    end
  end
end

function softthree()
  while true do
    clock.sync(s:step(22)()/s:step(23)())
    if going then
      local ch,length,rate = audio.file_info(selectedfile)
      if length/rate > 300 then length = 300
        else length = length/rate
      end
      local thirdposition = util.linlin(49,80,1,length-0.5,s:step(24)())
      softcut.position(5,thirdposition)
      local thirdrateslew = 1/s:step(25)()
      softcut.rate_slew_time(5,thirdrateslew)
      local thirdrate = (s:step(26)()/s:step(27)())
      softcut.rate(5,thirdrate)
      local thirdfade = 1/s:step(28)()
      softcut.fade_time(5,thirdfade)
      softcut.position(6,thirdposition)
      softcut.rate_slew_time(6,thirdrateslew)
      softcut.rate(6,thirdrate)
      softcut.fade_time(6,thirdfade)
      if s:step(29)() >= 17 then
        local thirdend = s:step(30)()
        local realend = thirdposition + thirdend
        if realend > length then realend = length
          else realend = thirdend
        end
        softcut.loop(5,1)
        softcut.loop(6,1)
        softcut.loop_start(5,thirdposition)
        softcut.loop_end(5,realend)
        softcut.loop_start(6,thirdposition)
        softcut.loop_end(6,realend)
      else
        softcut.loop(5,0)
        softcut.loop(6,0)
      end
    end
  end
end

function revone()
  while true do
    clock.sync(s:step(31)()/s:step(32)())
    firstrate = -firstrate
  end
end

function revtwo()
  while true do
    clock.sync(s:step(33)()/s:step(34)())
    secondrate = -secondrate
  end
end

function revthree()
  while true do
    clock.sync(s:step(35)()/s:step(36)())
    thirdrate = -thirdrate
  end
end

function key(n,z)
  if n==2 and z==1 then
    -- K2 toggles softcut
    going = not going
    print('going')
    if going then
      for i=1,6 do
        softcut.play(i,1)
      end
    elseif not going then
      for i=1,6 do
        softcut.play(i,0)
      end
    end
  elseif n==3 and z==1 then
    -- K3 toggles synth engine
    running = not running
    print('running')
  end
end

function init()
  LiedMotor.add_params() -- adds params via the `.add params()` function defined in LiedMotor_engine.lua
  params:add_file('file select','file select')
  params:set_action('file select', function(file) load_sample(file) selectedfile=file end)
  params:add_control('softcut_1','softcut_1',controlspec.new(0,1,'lin',0.01,1,''))
  params:set_action('softcut_1',function(x) softcut.level(1,x) softcut.level(2,x) end)
  params:add_control('softcut_2','softcut_2',controlspec.new(0,1,'lin',0.01,1,''))
  params:set_action('softcut_2',function(x) softcut.level(3,x) softcut.level(4,x) end)
  params:add_control('softcut_3','softcut_3',controlspec.new(0,1,'lin',0.01,1,''))
  params:set_action('softcut_3',function(x) softcut.level(5,x) softcut.level(6,x) end)
  screen.aa(0)
  print("lied")
  softcut_init()
  clock.run(step)
  clock.run(softone)
  clock.run(softtwo)
  clock.run(softthree)
  clock.run(revone)
  clock.run(revtwo)
  clock.run(revthree)
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
    local ch,length,rate = audio.file_info(selectedfile)
    starter = util.linlin(49,80,1,length/rate,s:step(37)())
    softcut.buffer_read_stereo(selectedfile, starter, 1, -1, 0, 1)
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
