---schicksalslied
---
---a poetry sequencer
---
---K1: crow sequencing
---K2: softcut sequencing
---K3: synth engine sequencing
---
---plug in a keyboard 
---to add lines to your poem
---
---use grid to recall history
---
---version 1.0.8

local extensions = '/home/we/.local/share/SuperCollider/Extensions'
engine.name = util.file_exists(extensions .. '/FormantTriPTR/FormantTriPTR.sc') and 'LiedMotor' or nil
UI = require "ui"
LiedMotor = include 'lib/LiedMotor_engine'
MusicUtil = require 'musicutil'
Sequins = require 'sequins'
FileSelect = require 'fileselect'
_lfos = include 'lib/lied_lfo'

Selected_File = {}
File_Length = {}

for i=1,3 do
  Selected_File[i] = _path.dust..'audio/hermit_leaves.wav'
end

My_String = " "
History = {}
History_Index = 0
New_Line = false

Running = false 
Going = false
Walking = false

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
    softcut.pan(i, i % 2 == 0 and 1 or -1)
  end
  softcut.voice_sync(2,1,0)
  softcut.voice_sync(4,3,0)
  softcut.voice_sync(6,5,0)
end

local function Split()
  for line in io.lines() do
    if #line > 0 then
    table.insert(History, line)
    end
  end
end

Step = {}
Divs = {}
Trig_Keys = {"trigsinsin", "trigtrisin", "trigringer", "trigtritri", "trigkarplu", "trigresonz"}

for i = 1, 6 do
  Step[i] = function()
    while true do
      clock.sync((S:step(3*(i-1)+1)()/S:step(3*(i-1)+2)())*Divs[i])
      if Running then
        local note_num = S:step(3*i)()
        local freq = MusicUtil.note_num_to_freq(note_num)
        LiedMotor[Trig_Keys[i]](freq)
      end
    end
  end
end

Soft = {}
Rate = {}
Rates = {}
Pans = {}
Reed = {}
Soft_Div = {}

for i=1,3 do
  Soft[i] = function()
    while true do
      clock.sync((S:step(15*(i-1)+19)()/S:step(15*(i-1)+20)())*Soft_Div[i])
      if Going then
        local fade = 1/(C:step(15*(i-1)+21)())
        softcut.fade_time(2*i-1,fade)
        softcut.fade_time(2*i,fade)
        local _,samples,rate = audio.file_info(Selected_File[i])
        local length = samples/rate
        if length > 45 then 
          length = 45
        else 
          length = length
        end
        local scstarter = 50*(i-1)
        local position = util.linlin(49,80,scstarter,scstarter+length-0.5,S:step(15*(i-1)+22)())
        softcut.position(2*i-1,position)
        softcut.position(2*i,position)
        local endpoint = util.linlin(49,80,scstarter,scstarter+length,S:step(15*(i-1)+23)())
        local realend = position + endpoint
        if realend > (scstarter+length) then 
          realend = scstarter+length
        else 
          realend = realend
        end
        softcut.loop_start(2*i-1,position)
        softcut.loop_start(2*i,position)
        softcut.loop_end(2*i-1,realend)
        softcut.loop_end(2*i,realend)
        softcut.loop(2*i-1,1)
        softcut.loop(2*i,1)
      end
    end
  end
  Rate[i] = function()
    while true do
      clock.sync((S:step(15*(i-1)+24)()/S:step(15*(i-1)+25)())*Soft_Div[i])
      if Going then
        local rate_slew = 1/C:step(15*(i-1)+26)()
        Rates[i] = math.min(S:step(15*(i-1)+27)()/S:step(15*(i-1)+28)(), 16)
        Rates[i] = C:step(15*(i-1)+29)() > 17 and Rates[i]*-1 or Rates[i]
        for j = 1, 2 do
          softcut.rate_slew_time(2*(i-1)+j, rate_slew)
          softcut.rate(2*(i-1)+j, Rates[i])
        end
      end
    end
  end
  Pans[i] = function()
    while true do
      clock.sync((S:step(15*(i-1)+30)()/S:step(15*(i-1)+31)())*Soft_Div[i])
      if Going then
        local pan = util.linlin(49,80,-1,1,S:step(15*(i-1)+32)())
        local pan_slew = 1/J:step(15*(i-1)+33)()
        for j = 1, 2 do
          softcut.pan_slew_time(2*(i-1)+j,pan_slew)
          softcut.pan(2*(i-1)+j,j==2 and -pan or pan)
        end
      end
    end
  end
  Reed[i] = function()
    while true do
      clock.sync(J:step(63+i)()*Soft_Div[i])
      local filelength, starter, screader, scstarter
      filelength = get_len(Selected_File[i])
      starter = util.linlin(49,80,0,filelength,S:step(66+i)())
      screader = 150+(50*(i-1))
      scstarter = 50*(i-1)
      softcut.buffer_read_stereo(Selected_File[i], starter, screader, 50, 0, 1)
      clock.sync(J:step(69+i)()*Soft_Div[i])
      softcut.buffer_copy_stereo(screader,scstarter,50,1/C:step(70)(),0,0)
    end
  end
end
  
function key(n, z)
  if z == 0 then return end
  if n == 2 then
    Going = not Going
    print(Going and 'going' or 'not going')
    for i = 1, 6 do
      softcut.play(i, Going and 1 or 0)
    end
  elseif n == 3 then
    Running = not Running
    print(Running and 'running' or 'not running')
  elseif n == 1 then
    Walking = not Walking
    print(Walking and 'walking' or 'not walking')
  end
end

local function remap(ascii)
  return ascii % 32 + 49
end

local function crowmap(ascii)
  return ascii % 32 + 1
end

local function jfmap(ascii)
  return ascii % 5 + 1
end

local function process_string(c)
  local tmp = {}
  for i = 1, #c do
    table.insert(tmp, remap(c:byte(i)))
  end
  return tmp
end

local function crow_string(c)
  local tmp = {}
  for i = 1, #c do
    table.insert(tmp, crowmap(c:byte(i)))
  end
  return tmp
end

local function jf_string(c)
  local tmp = {}
  for i = 1, #c do
    table.insert(tmp, jfmap(c:byte(i)))
  end
  return tmp
end

S = Sequins(process_string(My_String))
C = Sequins(crow_string(My_String))
J = Sequins(jf_string(My_String))

function get_len(x)
  local _, samples, rate = audio.file_info(x)
  return samples / rate
end

local function set()
  S:settable(process_string(My_String))
  C:settable(crow_string(My_String))
  J:settable(jf_string(My_String))
end

local function wcheck()
  while true do
    clock.sleep(1/30)
    crow.ii.wtape.play(Walking and 1 or 0)
  end
end

Notes_Event = {}
Crow_Div = {}

for i = 1, 2 do
  Notes_Event[i] = function ()
    while true do
      clock.sync((C:step(6*i+59)()/C:step(6*i+60)())*Crow_Div[i])
      if Walking then
        crow.output[2*i-1].volts = C:step(6*i+61)()/12
        crow.output[2*i-1].slew = C:step(6*i+62)()/300
        crow.output[2*i].action = "{to(5,dyn{attack=1}), to(0,dyn{release=1})}"
        crow.output[2*i].dyn.attack = C:step(6*i+63)()/40
        crow.output[2*i].dyn.release = C:step(6*i+64)()/40
        crow.output[2*i]()
      end
    end
  end
end

JF = {}
JF_Div = {}

for i = 1, 6 do
  JF[i] = function ()
    while true do
      clock.sync((C:step(4*i+73)()/C:step(4*i+74)())*JF_Div[i])
      if Walking then
        crow.ii.jf.play_voice(i,C:step(4*i+75)()/12,J:step(4*i+76)())
      end
    end
  end
end

local function run_event()
  while true do
    clock.sync((C:step(101)()/C:step(102)())*JF_Div[7])
    if Walking then
      crow.ii.jf.run(J:step(103)())
    end
  end
end

local function quantize_event()
  while true do
    clock.sync((C:step(104)()/C:step(105)())*JF_Div[8])
    if Walking then
      crow.ii.jf.quantize(C:step(106)())
    end
  end
end

W_Div = {}

local function with_event()
  while true do
    clock.sync((C:step(107)()/C:step(108)())*W_Div[5])
    if Walking then
      crow.ii.wtape.speed(C:step(109)(), C:step(110)())
    end
  end
end

local function rev_event()
  while true do
    clock.sync((C:step(111)()/C:step(112)())*W_Div[5])
    if Walking then
      crow.ii.wtape.reverse(1)
    end
  end
end

local function looper()
  while true do
    clock.sync((C:step(113)()/C:step(114)())*W_Div[5])
    if Walking then
      crow.ii.wtape.loop_start(1)
      clock.sync((C:step(115)()/C:step(116)())*W_Div[5])
      crow.ii.wtape.loop_end(1)
      if C:step(117)() < 17 then
        for _ = 1,J:step(118)() do
          clock.sync((C:step(119)()/C:step(120)())*W_Div[5])
          crow.ii.wtape.loop_scale(C:step(121)()/C:step(122)())
          for _ = 1, J:step(123)() do
            clock.sync((C:step(124)()/C:step(125)())*W_Div[5])
            crow.ii.wtape.loop_next(C:step(126)()-C:step(127)())
          end
        end
      else
        for _ = 1,J:step(128)() do
          clock.sync((C:step(129)()/C:step(130)())*W_Div[5])
          crow.ii.wtape.loop_next(C:step(131)()-C:step(132)())
          for _ = 1, J:step(133)() do
            clock.sync((C:step(134)()/C:step(135)())*W_Div[5])
            crow.ii.wtape.loop_scale(C:step(136)()/C:step(137)())
          end
        end
      end
      clock.sync((C:step(138)()/C:step(139)())*W_Div[5])
      crow.ii.wtape.loop_active(0)
      for _ = 1,C:step(140)() do
        clock.sync((C:step(141)()/C:step(142)())*W_Div[5])
        crow.ii.wtape.seek((C:step(143)()-C:step(144)()) * 300)
      end
      for _ = 1,J:step(145)() do
        clock.sync((C:step(146)()/C:step(147)())*W_Div[5])
        crow.ii.wtape.loop_active(1)
        if C:step(148)() < 17 then
          for _ = 1,J:step(149)() do
            clock.sync((C:step(150)()/C:step(151)())*W_Div[5])
            crow.ii.wtape.loop_scale(C:step(152)()/C:step(153)())
            for _ = 1, J:step(154)() do
              clock.sync((C:step(155)()/C:step(156)())*W_Div[5])
              crow.ii.wtape.loop_next(C:step(157)()-C:step(158)())
            end
          end
        else
          for _ = 1,J:step(159)() do
            clock.sync((C:step(160)()/C:step(161)())*W_Div[5])
            crow.ii.wtape.loop_next(C:step(162)()-C:step(163)())
            for _ = 1,J:step(164)() do
              clock.sync((C:step(165)()/C:step(166)())*W_Div[5])
              crow.ii.wtape.loop_scale(C:step(167)()/C:step(168)())
            end
          end
        end
        clock.sync((C:step(169)()/C:step(170)())*W_Div[5])
        crow.ii.wtape.loop_active(0)
        for _ = 1,C:step(171)() do
          clock.sync((C:step(172)()/C:step(173)())*W_Div[5])
          crow.ii.wtape.seek((C:step(174)()-C:step(175)())*300)
        end
      end
    end
  end
end

WSyn = {}

for i = 1,4 do
  WSyn[i] = function()
    while true do
      clock.sync((C:step(4*i+171)()/C:step(4*i+172)())*W_Div[i])
      if Walking then
        crow.ii.wsyn.play_voice(i, C:step(4*i+173)()/12, J:step(4*i+174)())
      end
    end
  end
end

local function wdel_event()
  while true do
    clock.sync((C:step(192)()/C:step(193)())*W_Div[6])
    if Walking then
      crow.ii.wdel.time(0)
      crow.ii.wdel.freq(C:step(194)()/12)
      crow.ii.wdel.pluck(J:step(195)())
    end
  end
end

G = grid.connect()

G.key = function(x,y,z)
  Momentary[x][y] = z == 1
  if x + 16 * (y  - 1) > #History then return end
  if z == 1 then
    My_String = My_String .. History[x + 16 * (y - 1)]
    redraw()
    Grid_Dirty = true
  else
    Grid_Dirty = true
    local flag = false
    for j = 1, 8 do
      for k = 1, 16 do
        if Momentary[k][j] then
          flag = true
          break
        end
      end
    end
    if flag then return end
    if My_String == "" then return end
    set()
    My_String = ""
    New_Line = true
    redraw()
  end
end

local function grid_redraw()
  G:all(0)
  -- i will be 1 for #History between 1 and 16, 2 for #History betwen 17 and 32...
  local i = (#History - 1) // 16 + 1
  -- j will be the leftover amount
  local j = (#History - 1) % 16 + 1
  for y = 1, i do
    local k = y == i and j or 16
    for x = 1, k do
      G:led(x,y,4)
    end
  end
  for x = 1, 16 do
    for y = 1, 8 do
      if Momentary[x][y] and x + 16 * (y - 1) <= #History then
        G:led(x,y,15)
      end
    end
  end
  G:refresh()
end

local function grid_redraw_clock()
  while true do
    clock.sleep(1/30)
    if Grid_Dirty then
      grid_redraw()
      Grid_Dirty = false
    end
  end
end

keyboard.char = function (character)
  if #My_String < 20 then
    My_String = My_String .. character
    redraw()
  end
end

keyboard.code = function (code, val)
  if val == 0 then return end
  if code == "BACKSPACE" then
    My_String = My_String:sub(1, -2)
  elseif code == "UP" then
    if #History == 0 then return end
    if New_Line then
      History_Index = #History - 1
      New_Line = false
    else
      History_Index = util.clamp(History_Index - 1, 0, #History)
    end
    My_String = History[History_Index + 1]
  elseif code == "DOWN" then
    if #History == 0 or History_Index == nil then return end
    History_Index = util.clamp(History_Index + 1, 0, #History)
    if History_Index == #History then
      My_String = ""
      New_Line = true
    else
      My_String = History[History_Index + 1]
    end
  elseif code == "ENTER" and #My_String > 0 then
    set()
    table.insert(History, My_String)
    My_String = ""
    History_Index = #History
    New_Line = true
  end
  redraw()
  grid_redraw()
end

function redraw()
  if Needs_Restart then
    screen.clear()
    Restart_Message:redraw()
    screen.update()
    return
  end
  screen.clear()
  screen.level(10)
  screen.rect(2, 50, 125, 14)
  screen.stroke()
  screen.move(5, 59)
  screen.text("> " .. My_String)
  for i = 1, 5 do
    if not (History_Index - i >= 0) then break end
    screen.move(5, 55 - 10 * i)
    screen.text(History[History_Index - i + 1])
  end
  screen.update()
end

function init()
  Needs_Restart = false
  local formanttri_files = {"FormantTriPTR.sc", "FormantTriPTR_scsynth.so"}
  for _, file in pairs(formanttri_files) do
    if util.file_exists(extensions .. "/FormantTriPTR/" .. file) then goto continue end
    util.os_capture("mkdir " .. extensions .. "/FormantTriPTR")
    util.os_capture("cp " .. norns.state.path .. "/ignore/" .. file .. " " .. extensions .. "/FormantTriPTR/" .. file)
    print("installed " .. file)
    Needs_Restart = true
    ::continue::
  end
  Restart_Message = UI.Message.new{"please restart norns"}
  if needs_restart then redraw() return end
  LiedMotor.add_params()
  local index = {index = {min = -24, max = 24}}
  local modnum = {modnum = {min = 1, max = 100}}
  local modeno = {modeno = {min = 1, max = 100}}
  local width = {width = {min = 0, max = 1}}
  local modwidth = {modidth = {min = 0, max = 1}}
  local phase = {phase = {min = -24, max = 24}}
  local modphase = {modphase = {min = -24, max = 24}}
  local attack = {attack = {min = 0.003, max = 8}}
  local release = {release = {min = 0.003, max = 8}}
  local amp = {amp = {min = 0, max = 1}}
  local pan = {pan = {min = -1, max = 1}}
  local LFOs = {
    {sinsin = {index, modnum, modeno, phase, attack, release, amp, pan}},
    {trisin = {index, modnum, modeno, phase, attack, release, amp, pan}},
    {ringer = {index, amp, pan}},
    {tritri = {index, modnum, modeno, width, modwidth, phase, modphase, attack, release, amp, pan}},
    {karplu = {index, {coef = {min = -1, max = 1}}, amp, pan}},
    {resonz = {index, amp, pan}},
    {wdel = {{feedback = {min = -5, max = 5}}, {filter = {min = -5, max = 5}}}},
    {wsyn = {{lpg_speed = {min = -5, max = 5}}, {lpg_symmetry = {min = -5, max = 5}}, {fm_num = {min = -5, max = 5}}, {fm_deno = {min = -5, max = 5}}, {fm_index = {min = -5, max = 5}}, {fm_envelope = {min = -5, max = 5}}}},
  }
  params:add_group('LFOs', 675)
  for _, val in ipairs(LFOs) do
    for key, vals in pairs(val) do
      for _, lfo_param in ipairs(vals) do
        for name, arg in pairs(lfo_param) do
          local lfo = _lfos:add(arg)
          lfo:add_params(key .. '_' .. name .. '_lfo', key .. ' ' .. name)
          lfo:set('action', function(scaled, _)
            params:set('LiedMotor_' .. key .. '_' .. name, scaled)
          end)
        end
      end
    end
  end
  screen.aa(0)
  params:add_separator('clock_divs', 'clock divs')
  local divs_params = {"sinsin", "trisin", "ringer", "tritri", "karplu", "resonz"}
  for i, value in ipairs(divs_params) do
    params:add{
      type = 'control',
      id = value,
      name = value,
      controlspec = controlspec.new(1, 256, 'lin', 1, 1, ''),
      action = function (x)
        Divs[i] = x
      end
    }
  end
  for i = 1, 3 do
    params:add{
      type = 'control',
      id = 'softcut_voice_' .. i,
      name = 'softcut voice ' ..i,
      controlspec = controlspec.new(1, 256, 'lin', 1, 1, ''),
      action = function (x)
        Soft_Div[i] = x
      end
    }
  end
  params:add{
    type = 'control',
    id = 'crow_1_2',
    name = 'crow outputs 1 & 2',
    controlspec = controlspec.new(1,256,'lin',1,1,''),
    action = function (x)
      Crow_Div[1] = x
    end
  }
  params:add{
    type = 'control',
    id = 'crow_3_4',
    name = 'crow outputs 3 & 4',
    controlspec = controlspec.new(1,256,'lin',1,1,''),
    action = function (x)
      Crow_Div[2] = x
    end
  }
  for i = 1, 6 do
    params:add{
      type = 'control',
      id = 'just_friends_voice_' .. i,
      name = 'just friends voice ' .. i,
      controlspec = controlspec.new(1,256,'lin',1,1,''),
      action = function (x)
        JF_Div[i] = x
      end
    }
  end
  params:add{
    type = 'control',
    id = 'just_friends_run',
    name = 'just friends run',
    controlspec = controlspec.new(1,256,'lin',1,1,''),
    action = function (x)
      JF_Div[7] = x
    end
  }
params:add{
    type = 'control',
    id = 'just_friends_quantize',
    name = 'just friends quantize',
    controlspec = controlspec.new(1,256,'lin',1,1,''),
    action = function (x)
      JF_Div[8] = x
    end
  }
  params:add{
    type = 'control',
    id = 'w_tape',
    name = 'w/tape',
    controlspec = controlspec.new(1,256,'lin',1,1,''),
    action = function (x)
      W_Div[5] = x
    end
  }
  params:add{
    type = 'control',
    id = 'w_del',
    name = 'w/del',
    controlspec = controlspec.new(1,256,'lin',1,1,''),
    action = function (x)
      W_Div[6] = x
    end
  }
  for i = 1, 4 do
    params:add{
      type = 'control',
      id = 'w_syn_' .. i,
      name = 'w/syn voice ' .. i,
      controlspec = controlspec.new(1,256,'lin',1,1,''),
      action = function (x)
        W_Div[i] = x
      end
    }
  end
  params:add_separator('softcut_voice_levels', 'softcut voice levels')
  for i = 1, 3 do
    params:add{
      type = 'control',
      id = 'voice_' .. i,
      name = 'voice ' .. i,
      controlspec = controlspec.new(0,1,'lin',0.01,1,''),
      action = function (x)
        softcut.level(2 * i - 1, x)
        softcut.level(2 * i, x)
      end
    }
  end
  params:add_separator('w_settings', 'w/ settings')
  params:add{
    type = 'control',
    id = 'w_del_feeback',
    name = 'w/del feedback',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, 4.8, ''),
    action = function (x)
      crow.ii.wdel.feedback(x)
    end
  }
  params:add{
    type = 'control',
    id = 'w_del_filter_cutoff',
    name = 'w/del filter cutoff',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, 4.8, ''),
    action = function (x)
      crow.ii.wdel.filter(x)
    end
  }
  params:add{
    type = 'control',
    id = 'w_syn_lpg_speed',
    name = 'w/syn lpg speed',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, -3, ''),
    action = function (x)
      crow.ii.wsyn.lpg_time(x)
    end
  }
  params:add{
    type = 'control',
    id = 'w_syn_lpg_symmetry',
    name = 'w/syn lpg symmetry',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, -1, ''),
    action = function (x)
      crow.ii.wsyn.lpg_symmetry(x)
    end
  }
  params:add{
    type = 'control',
    id = 'w_syn_fm_num',
    name = 'w/syn fm num',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, 1, ''),
    action = function (x)
      crow.ii.wsyn.fm_ratio(x, params:get('w_syn_fm_deno'))
    end
  }
  params:add{
    type = 'control',
    id = 'w_syn_fm_deno',
    name = 'w/syn fm deno',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, 1, ''),
    action = function (x)
      crow.ii.wsyn.fm_ratio(params:get('w_syn_fm_num'),x)
    end
  }
  params:add{
    type = 'control',
    id = 'w_syn_fm_index',
    name = 'w/syn fm index',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, 0.1, ''),
    action = function (x)
      crow.ii.wsyn.fm_index(x)
    end
  }
  params:add{
    type = 'control',
    id = 'w_syn_fm_envelope',
    name = 'w/syn fm envelope',
    controlspec = controlspec.new(-5, 5, 'lin', 0.01, -0.1, ''),
    action = function (x)
      crow.ii.wsyn.fm_env(x)
    end
  }
  params:bang()
  params:add_separator('load_files','load files')
  for i = 1, 3 do
    params:add{
      type = 'file',
      id = 'audio_file_' .. i,
      name = 'audio file ' .. i,
      action = function (x)
        Selected_File[i] = x
      end
    }
  end
  params:add{
    type = 'file',
    id = 'text_file',
    name = 'text file',
    action = function (x)
      io.input(x)
      Split()
      grid_redraw()
    end
  }
  Grid_Dirty = false
  Momentary = {}
  for x = 1, 16 do
    Momentary[x] = {}
    for y = 1, 8 do
      Momentary[x][y] = false
    end
  end
  print('Schicksalslied')
  softcut_init()
  local bpm = clock.get_tempo()
  for i = 1, 6 do
    clock.run(Step[i])
    clock.run(JF[i])
  end
  for i = 1, 4 do
    clock.run(WSyn[i])
  end
  for i = 1, 3 do
    clock.run(Soft[i])
    clock.run(Rate[i])
    clock.run(Pans[i])
    clock.run(Reed[i])
  end
  for i = 1, 2 do
    clock.run(Notes_Event[i])
  end
  clock.run(run_event)
  clock.run(quantize_event)
  clock.run(with_event)
  clock.run(rev_event)
  clock.run(looper)
  clock.run(wdel_event)
  clock.run(wcheck)
  clock.run(grid_redraw_clock)
  crow.input[1].mode('clock')
  crow.ii.jf.mode(1)
  crow.ii.jf.run_mode(1)
  crow.ii.jf.tick(bpm)
  crow.ii.wtape.timestamp(1)
  crow.ii.wtape.freq(0)
  crow.ii.wtape.play(0)
  crow.ii.wdel.mod_rate(0)
  crow.ii.wdel.mod_amount(0)
  crow.ii.wsyn.ar_mode(1)
  crow.ii.wsyn.voices(4)
  crow.ii.wsyn.patch(1,1)
  crow.ii.wsyn.patch(2,2)
end
