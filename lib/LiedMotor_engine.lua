local LiedMotor = {}
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["sinsin_amp"] = controlspec.AMP,
  ["trisin_amp"] = controlspec.AMP,
  ["ringer_amp"] = controlspec.AMP,
  ["tritri_amp"] = controlspec.AMP,
  ["karplu_amp"] = controlspec.AMP,
  ["resonz_amp"] = controlspec.new(0, 100, "lin", 0, 0.2, ""),
  ["sinsin_modnum"] = controlspec.new(1, 100, "lin", 1, 1, ""),
  ["sinsin_modeno"] = controlspec.new(1, 100, "lin", 1, 1, ""),
  ["trisin_modnum"] = controlspec.new(1, 100, "lin", 1, 1, ""),
  ["trisin_modeno"] = controlspec.new(1, 100, "lin", 1, 1, ""),
  ["tritri_width"] = controlspec.AMP,
  ["tritri_modwidth"] = controlspec.AMP,
  ["tritri_modnum"] = controlspec.new(1, 100, "lin", 1, 1, ""),
  ["tritri_modeno"] = controlspec.new(1, 100, "lin", 1, 1, ""),
  ["karplu_coef"] = controlspec.new(-1, 1, "lin", 0, 0.5, ""),
  ["sinsin_index"] = controlspec.new(-24, 24, "lin", 0, 0, ""),
  ["trisin_index"] = controlspec.new(-24, 24, "lin", 0, 0, ""),
  ["ringer_index"] = controlspec.new(0, 24, "lin", 0, 3, ""),
  ["tritri_index"] = controlspec.new(-24, 24, "lin", 0, 0, ""),
  ["karplu_index"] = controlspec.new(0, 24, "lin", 0, 3, ""),
  ["resonz_index"] = controlspec.new(0, 1, "lin", 0, 0.1, ""),
  ["sinsin_attack"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["trisin_attack"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["tritri_attack"] = controlspec.new(0.003, 8, "exp", 0, 0, "s"),
  ["sinsin_release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["trisin_release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["tritri_release"] = controlspec.new(0.003, 8, "exp", 0, 1, "s"),
  ["sinsin_phase"] = controlspec.PHASE,
  ["trisin_phase"] = controlspec.PHASE,
  ["tritri_phase"] = controlspec.PHASE,
  ["tritri_modphase"] = controlspec.PHASE,
  ["sinsin_pan"] = controlspec.PAN,
  ["trisin_pan"] = controlspec.PAN,
  ["ringer_pan"] = controlspec.PAN,
  ["tritri_pan"] = controlspec.PAN,
  ["karplu_pan"] = controlspec.PAN,
  ["resonz_pan"] = controlspec.PAN
}

-- this table establishes an order for parameter initialization:
local param_names = {"sinsin_attack","sinsin_release","sinsin_phase","sinsin_index","sinsin_modnum","sinsin_modeno","sinsin_amp","sinsin_pan","trisin_attack","trisin_release","trisin_phase","trisin_index","trisin_modnum","trisin_modeno","trisin_amp","trisin_pan","ringer_index","ringer_amp","ringer_pan","tritri_attack","tritri_release","tritri_width","tritri_modwidth","tritri_phase","tritri_modphase","tritri_index","tritri_modnum","tritri_modeno","tritri_amp","tritri_pan","karplu_index","karplu_coef","karplu_amp","karplu_pan","resonz_index","resonz_amp","resonz_pan"}

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
function LiedMotor.trigsinsin(hz)
  if hz ~= nil then
    engine.sinsinhz(hz)
  end
end

function LiedMotor.trigtrisin(hz)
  if hz ~= nil then
    engine.trisinhz(hz)
  end
end

function LiedMotor.trigringer(hz)
  if hz ~= nil then
    engine.ringerhz(hz)
  end
end

function LiedMotor.trigtritri(hz)
  if hz ~= nil then
    engine.tritrihz(hz)
  end
end

function LiedMotor.trigkarplu(hz)
  if hz ~= nil then
    engine.karpluhz(hz)
  end
end

function LiedMotor.trigresonz(hz)
  if hz ~= nil then
    engine.resonzhz(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return LiedMotor
