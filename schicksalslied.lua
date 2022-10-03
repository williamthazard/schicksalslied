---schicksalslied

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
    softcut.phase_quant(i,0.5)
    softcut.loop(i,1)
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
      local firstfade = 1/s:step(6)() + 1
      softcut.fade_time(1,firstfade)
      softcut.fade_time(2,firstfade)
      local ch,length,rate = audio.file_info(selectedfile)
      if length/rate > 300 then length = 300
        else length = length/rate
      end
      local firstposition = util.linlin(49,80,0,length-0.5,s:step(7)())
      softcut.position(1,firstposition)
      softcut.position(2,firstposition)
      local firstend = s:step(8)()
      local realend = firstposition + firstend
      if realend > length then realend = length
        else realend = firstend
      end
      softcut.loop_start(1,firstposition)
      softcut.loop_end(1,realend)
      softcut.loop_start(2,firstposition)
      softcut.loop_end(2,realend)
      softcut.loop(1,1)
      softcut.loop(2,1)
    end
  end
end

function softfirstrate()
  while true do
    clock.sync(s:step(9)()/s:step(10)())
    if going then
      local firstrateslew = 1/s:step(11)()
      softcut.rate_slew_time(1,firstrateslew)
      softcut.rate_slew_time(2,firstrateslew)
      firstrate = (s:step(12)()/s:step(13)())
      if firstrate > 16 then firstrate = 16
        else firstrate = firstrate
      end
      softcut.rate(1,firstrate)
      softcut.rate(2,firstrate)
    end
  end
end

function firstpan()
  while true do
    clock.sync(s:step(14)()/s:step(15)())
    if going then
      local firstpan = util.linlin(49,80,-1,1,s:step(16)())
      local firstnegativepan = firstpan * -1
      local firstpanslew = 1/s:step(17)()
      softcut.pan(1,firstpan)
      softcut.pan(2,firstnegativepan)
      softcut.pan_slew_time(1,firstpanslew)
      softcut.pan_slew_time(2,firstpanslew)
    end
  end
end

function softtwo()
  while true do
    clock.sync(s:step(18)()/s:step(19)())
    if going then
      local secondfade = 1/s:step(20)() + 1
      softcut.fade_time(3,secondfade)
      softcut.fade_time(4,secondfade)
      local ch,length,rate = audio.file_info(selectedfile)
      if length/rate > 300 then length = 300
        else length = length/rate
      end
      local secondposition = util.linlin(49,80,0,length-0.5,s:step(21)())
      softcut.position(3,secondposition)
      softcut.position(4,secondposition)
      local secondend = s:step(22)()
      local realend = secondposition + secondend
      if realend > length then realend = length
        else realend = secondend
      end
      softcut.loop_start(3,secondposition)
      softcut.loop_end(3,realend)
      softcut.loop_start(4,secondposition)
      softcut.loop_end(4,realend)
    end
  end
end

function softsecondrate()
  while true do
    clock.sync(s:step(23)()/s:step(24)())
    if going then
      local secondrateslew = 1/s:step(25)()
      softcut.rate_slew_time(3,secondrateslew)
      softcut.rate_slew_time(4,secondrateslew)
      secondrate = (s:step(26)()/s:step(27)())
      if secondrate > 16 then secondrate = 16
        else secondrate = secondrate
      end
      softcut.rate(3,secondrate)
      softcut.rate(4,secondrate)
    end
  end
end

function secondpan()
  while true do
    clock.sync(s:step(28)()/s:step(29)())
    if going then
      local firstpan = util.linlin(49,80,-1,1,s:step(30)())
      local secondnegativepan = secondpan * -1
      local secondpanslew = 1/s:step(31)()
      softcut.pan(3,secondpan)
      softcut.pan(4,secondnegativepan)
      softcut.pan_slew_time(3,secondpanslew)
      softcut.pan_slew_time(4,secondpanslew)
    end
  end
end

function softthree()
  while true do
    clock.sync(s:step(32)()/s:step(33)())
    if going then
      local thirdfade = 1/s:step(34)() + 1
      softcut.fade_time(5,thirdfade)
      softcut.fade_time(6,thirdfade)
      local ch,length,rate = audio.file_info(selectedfile)
      if length/rate > 300 then length = 300
        else length = length/rate
      end
      local thirdposition = util.linlin(49,80,0,length-0.5,s:step(35)())
      softcut.position(5,thirdposition)
      softcut.position(6,thirdposition)
      local thirdend = s:step(36)()
      local realend = thirdposition + thirdend
      if realend > length then realend = length
        else realend = thirdend
      end
      softcut.loop_start(5,thirdposition)
      softcut.loop_end(5,realend)
      softcut.loop_start(6,thirdposition)
      softcut.loop_end(6,realend)
    end
  end
end

function softthirdrate()
  while true do
    clock.sync(s:step(37)()/s:step(38)())
    if going then
      local thirdrateslew = 1/s:step(39)()
      softcut.rate_slew_time(5,thirdrateslew)
      softcut.rate_slew_time(6,thirdrateslew)
      thirdrate = (s:step(40)()/s:step(41)())
      if thirdrate > 16 then thirdrate = 16
        else thirdrate = thirdrate
      end
      softcut.rate(5,thirdrate)
      softcut.rate(6,thirdrate)
    end
  end
end

function thirdpan()
  while true do
    clock.sync(s:step(42)()/s:step(43)())
    if going then
      local thirdpan = util.linlin(49,80,-1,1,s:step(44)())
      local thirdnegativepan = thirdpan * -1
      local thirdpanslew = 1/s:step(45)()
      softcut.pan(5,thirdpan)
      softcut.pan(6,thirdnegativepan)
      softcut.pan_slew_time(5,thirdpanslew)
      softcut.pan_slew_time(6,thirdpanslew)
    end
  end
end

function revone()
  while true do
    clock.sync(s:step(46)()/s:step(47)())
    firstrate = firstrate * -1
  end
end

function revtwo()
  while true do
    clock.sync(s:step(48)()/s:step(49)())
    secondrate = secondrate * -1
  end
end

function revthree()
  while true do
    clock.sync(s:step(50)()/s:step(51)())
    thirdrate = thirdrate * -1
  end
end

function key(n,z)
  if n==2 and z==1 then
    -- K2 toggles softcut
    going = not going
    if going then
      print('going')
      for i=1,6 do
        softcut.play(i,1)
      end
    elseif not going then
      print('not going')
      for i=1,6 do
        softcut.play(i,0)
      end
    end
  elseif n==3 and z==1 then
    -- K3 toggles synth engine
    running = not running
    if running then
    print('running')
    else print('not running')
    end
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
  grid_dirty = false
  momentary = {}
  for x = 1,16 do -- for each x-column (16 on a 128-sized grid)...
    momentary[x] = {} -- create a table that holds...
    for y = 1,8 do -- each y-row (8 on a 128-sized grid)!
      momentary[x][y] = false -- the state of each key is 'off'
    end
  end
  print("schicksalslied")
  softcut_init()
  clock.run(step)
  clock.run(softone)
  clock.run(softtwo)
  clock.run(softthree)
  clock.run(revone)
  clock.run(revtwo)
  clock.run(revthree)
  clock.run(softfirstrate)
  clock.run(softsecondrate)
  clock.run(softthirdrate)
  clock.run(firstpan)
  clock.run(secondpan)
  clock.run(thirdpan)
  clock.run(grid_redraw_clock)
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
    local seclength = length/rate
    if seclength > 300 then seclength = seclength-300
      else seclength = seclength
    end
    starter = util.linlin(49,80,0,seclength,s:step(52)())
    softcut.buffer_read_stereo(selectedfile, starter, 0, -1, 0, 1)
end

function keyboard.char(character)
  if #my_string < 20 then
  my_string = my_string .. character -- add characters to my string
  redraw()
  elseif #my_string >=20 then
  my_string = my_string
  end
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
    grid_redraw()
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
    if history_index >= 4 then screen.move(5, 15) screen.text(history[history_index - 3]) end -- command before that
    if history_index >= 5 then screen.move(5, 5) screen.text(history[history_index - 4]) end -- command before...
  end
  screen.update()
end

g = grid.connect()

function grid_redraw_clock() -- our grid redraw clock
  while true do -- while it's running...
    clock.sleep(1/30) -- refresh at 30fps.
    if grid_dirty then -- if a redraw is needed...
      grid_redraw() -- redraw...
      grid_dirty = false -- then redraw is no longer needed.
    end
  end
end

function grid_redraw()
  g:all(0)
  if #history < 17 then
    for i=1,#history do
      g:led(i,1,4)
    end
  end
  if #history >= 17 and #history < 33 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,#history do
      g:led(i-16,2,4)
    end
  end
  if #history >= 33 and #history < 49 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,33 do
      g:led(i-16,2,4)
    end
    for i=34,#history do
      g:led(i-33,3,4)
    end
  end
  if #history >= 49 and #history < 65 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,33 do
      g:led(i-16,2,4)
    end
    for i=34,49 do
      g:led(i-33,3,4)
    end
    for i=50,#history do
      g:led(i-49,4,4)
    end
  end
  if #history >= 65 and #history < 81 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,33 do
      g:led(i-16,2,4)
    end
    for i=34,49 do
      g:led(i-33,3,4)
    end
    for i=50,65 do
      g:led(i-49,4,4)
    end
    for i=66,#history do
      g:led(i-65,5,4)
    end
  end
  if #history >= 81 and #history < 97 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,33 do
      g:led(i-16,2,4)
    end
    for i=34,49 do
      g:led(i-33,3,4)
    end
    for i=50,65 do
      g:led(i-49,4,4)
    end
    for i=66,81 do
      g:led(i-65,5,4)
    end
    for i=82,#history do
      g:led(i-81,6,4)
    end
  end
  if #history >= 97 and #history < 113 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,33 do
      g:led(i-16,2,4)
    end
    for i=34,49 do
      g:led(i-33,3,4)
    end
    for i=50,65 do
      g:led(i-49,4,4)
    end
    for i=66,81 do
      g:led(i-65,5,4)
    end
    for i=82,97 do
      g:led(i-81,6,4)
    end
    for i=98,#history do
      g:led(i-97,7,4)
    end
  end
  if #history >= 113 and #history < 129 then
    for i=1,16 do
      g:led(i,1,4)
    end
    for i=17,33 do
      g:led(i-16,2,4)
    end
    for i=34,49 do
      g:led(i-33,3,4)
    end
    for i=50,65 do
      g:led(i-49,4,4)
    end
    for i=66,81 do
      g:led(i-65,5,4)
    end
    for i=82,97 do
      g:led(i-81,6,4)
    end
    for i=98,113 do
      g:led(i-97,7,4)
    end
    for i=114,#history do
      g:led(i-113,8,4)
    end
  end
  if #history >= 129 then
    g:all(4)
  end
   for x = 1,16 do -- for each column...
    for y = 1,8 do -- and each row...
      if momentary[x][y] then -- if the key is held...
        if x+16*(y-1) <= #history then
        g:led(x,y,15) -- turn on that LED!
        end
      end
    end
  end
  g:refresh()
end

g.key = function(x,y,z)
  momentary[x][y] = z == 1
  if x+16*(y-1) <= #history then
    if z == 1 then
      local index = x + 16*(y-1)
      if index <= #history then
        my_string = my_string .. history[index]
        redraw()
      end
    elseif z == 0 then
      local flag = false
      for j = 1,8 do
        for k = 1,16 do
          if momentary[j][k] then
            flag = true
            break
          end
        end
      end
      if not flag then
        set()
        my_string = ""
        new_line = true
        redraw()
      end
    end
  end
  grid_dirty = true -- flag for redraw
end
