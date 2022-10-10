local LiedMotor = {}
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["mul1"] = controlspec.new(0, 2, "lin", 0, 0.5, ""),
  ["mul2"] = controlspec.new(0, 2, "lin", 0, 0.4, ""),
  ["mul3"] = controlspec.new(0, 2, "lin", 0, 0.3, ""),
  ["mul4"] = controlspec.new(0, 2, "lin", 0, 0.3, ""),
  ["mul5"] = controlspec.new(0, 2, "lin", 0, 0.2, ""),
  ["mul6"] = controlspec.new(0, 2, "lin", 0, 0.2, ""),
  ["mul7"] = controlspec.new(0, 2, "lin", 0, 0.6, ""),
  ["mul8"] = controlspec.new(0, 2, "lin", 0, 0.6, ""),
  ["modfreq1"] = controlspec.FREQ,
  ["modfreq2"] = controlspec.FREQ,
  ["modfreq3"] = controlspec.FREQ,
  ["modfreq4"] = controlspec.FREQ,
  ["modfreq5"] = controlspec.FREQ,
  ["modfreq6"] = controlspec.FREQ,
  ["modfreq7"] = controlspec.FREQ,
  ["modfreq8"] = controlspec.FREQ,
  ["index1"] = controlspec.new(0, 24, "lin", 0, 0, ""),
  ["index2"] = controlspec.new(0, 24, "lin", 0, 0, ""),
  ["index3"] = controlspec.new(0, 24, "lin", 0, 1, ""),
  ["index4"] = controlspec.new(0, 24, "lin", 0, 2, ""),
  ["index5"] = controlspec.new(0, 24, "lin", 0, 3, ""),
  ["index6"] = controlspec.new(0, 24, "lin", 0, 4, ""),
  ["index7"] = controlspec.new(0, 24, "lin", 0, 0, ""),
  ["index8"] = controlspec.new(0, 24, "lin", 0, 0, ""),
  ["attack1"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack2"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack3"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack4"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack5"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack6"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["attack7"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["attack8"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release1"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release2"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release3"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release4"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release5"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release6"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["release7"] = controlspec.new(0.003, 8, "exp", 0, 2, "s"),
  ["release8"] = controlspec.new(0.003, 8, "exp", 0, 2, "s"),
  ["phase1"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase2"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase3"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase4"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase5"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase6"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase7"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["phase8"] = controlspec.new(0, 4, "lin", 0, 1, ""),
  ["pan1"] = controlspec.PAN,
  ["pan2"] = controlspec.PAN,
  ["pan3"] = controlspec.PAN,
  ["pan4"] = controlspec.PAN,
  ["pan5"] = controlspec.PAN,
  ["pan6"] = controlspec.PAN,
  ["pan7"] = controlspec.PAN,
  ["pan8"] = controlspec.PAN
}

-- this table establishes an order for parameter initialization:
local param_names = {"index1","attack1","release1","phase1","mul1","pan1","modfreq1","index2","attack2","release2","phase2","mul2","pan2","modfreq2","index3","attack3","release3","phase3","mul3","pan3","modfreq3","index4","attack4","release4","phase4","mul4","pan4","modfreq4","index5","attack5","release5","phase5","mul5","pan5","modfreq5","index6","attack6","release6","phase6","mul6","pan6","modfreq6","index7","attack7","release7","phase7","mul7","pan7","modfreq7","index8","attack8","release8","phase8","mul8","pan8","modfreq8"}

-- initialize parameters:
function LiedMotor.add_params()
  params:add_group("LiedMotor",#param_names)

  for i = 1,#param_names do
    local p_name = param_names[i]
    params:add{
      type = "control",
      id = "LiedMotor_"..p_name,
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
function LiedMotor.trig(hz)
  if hz ~= nil then
    engine.hzone(hz)
  end
end

function LiedMotor.trigtwo(hz)
  if hz ~= nil then
    engine.hztwo(hz)
  end
end

function LiedMotor.trigthree(hz)
  if hz ~= nil then
    engine.hzthree(hz)
  end
end

function LiedMotor.trigfour(hz)
  if hz ~= nil then
    engine.hzfour(hz)
  end
end

function LiedMotor.trigfive(hz)
  if hz ~= nil then
    engine.hzfive(hz)
  end
end

function LiedMotor.trigsix(hz)
  if hz ~= nil then
    engine.hzsix(hz)
  end
end

function LiedMotor.trigseven(hz)
  if hz ~= nil then
    engine.hzseven(hz)
  end
end

function LiedMotor.trigeight(hz)
  if hz ~= nil then
    engine.hzeight(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return LiedMotor
