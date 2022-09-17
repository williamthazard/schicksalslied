local LiedMotor = {}
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["amp"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["sub_div"] = controlspec.new(1, 10, "lin", 1, 2, ""),
  ["noise_level"] = controlspec.new(0, 1, "lin", 0, 0.3, ""),
  ["pulse_level"] = controlspec.new(0, 1, "lin", 0, 0.3, ""),
  ["saw_level"] = controlspec.new(0, 1, "lin", 0, 0.3, ""),
  ["sub_level"] = controlspec.new(0, 1, "lin", 0, 0.3, ""),
  ["cutoff"] = controlspec.new(0.1, 20000, 'exp', 0, 1300, "Hz"),
  ["resonance"] = controlspec.new(0, 4, "lin", 0, 2, ""),
  ["attack"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["pan"] = controlspec.PAN
}

-- this table establishes an order for parameter initialization:
local param_names = {"amp","sub_div","noise_level","pulse_level","saw_level","sub_level","cutoff","resonance","attack","release","pan"}

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
    engine.hz(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return LiedMotor
