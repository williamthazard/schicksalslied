local LiedMotorNew = {}
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["mul1"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["mul2"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["mul3"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["mul4"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["modmul1"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["modmul2"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["modmul3"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["modmul4"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["modfreq1"] = controlspec.FREQ,
  ["modfreq2"] = controlspec.FREQ,
  ["modfreq3"] = controlspec.FREQ,
  ["modfreq4"] = controlspec.FREQ,
  ["carPartial1"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["carPartial2"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["carPartial3"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["carPartial4"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modPartial1"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modPartial2"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modPartial3"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modPartial4"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["index1"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["index2"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["index3"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["index4"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modindex1"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modindex2"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modindex3"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["modindex4"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["attack1"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack2"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack3"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack4"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["release1"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release2"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release3"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release4"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["phase1"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase2"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase3"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase4"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["pan1"] = controlspec.PAN,
  ["pan2"] = controlspec.PAN,
  ["pan3"] = controlspec.PAN,
  ["pan4"] = controlspec.PAN
}

-- this table establishes an order for parameter initialization:
local param_names = {"carpartial1","index1","attack1","release1","phase1","mul1","pan1","modfreq1","modpartial1","modindex1","modmul1","carpartial2","index2","attack2","release2","phase2","mul2","pan2","modfreq2","modpartial2","modindex2","modmul2","carpartial3","index3","attack3","release3","phase3","mul3","pan3","modfreq3","modpartial3","modindex3","modmul3","carpartial4","index4","attack4","release4","phase4","mul4","pan4","modfreq4","modpartial4","modindex4","modmul4"}

-- initialize parameters:
function LiedMotorNew.add_params()
  params:add_group("LiedMotorNew",#param_names)

  for i = 1,#param_names do
    local p_name = param_names[i]
    params:add{
      type = "control",
      id = "LiedMotorNew_"..p_name,
      name = p_name,
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
  end
  
  params:bang()
end

-- a single-purpose triggering command fire a note
function LiedMotorNew.trig(hz)
  if hz ~= nil then
    engine.hzone(hz)
  end
end

function LiedMotorNew.trigtwo(hz)
  if hz ~= nil then
    engine.hztwo(hz)
  end
end

function LiedMotorNew.trigthree(hz)
  if hz ~= nil then
    engine.hzthree(hz)
  end
end

function LiedMotorNew.trigfour(hz)
  if hz ~= nil then
    engine.hzfour(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return LiedMotorNew
