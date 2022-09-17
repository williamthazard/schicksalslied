Engine_LiedMotor : CroneEngine {
// All norns engines follow the 'Engine_MySynthName' convention above

	var params;

	alloc { // allocate memory to the following:

		// add SynthDefs
		SynthDef("LiedMotor", {
			arg out = 0,
			freq, sub_div, noise_level,
			pulse_level, saw_level, sub_level,
			cutoff, resonance,
			attack, release,
			amp, pan;

			var pulse = Pulse.ar(freq: freq, mul: pulse_level);
			var saw = Saw.ar(freq: freq, mul: saw_level);
			var sub = Pulse.ar(freq: freq/sub_div, mul: sub_level);
			var noise = WhiteNoise.ar(mul: noise_level);
			var mix = Mix.ar([pulse,saw,sub,noise]);

			var envelope = Env.perc(attackTime: attack, releaseTime: release, level: amp).kr(doneAction: 2);
			var filter = MoogFF.ar(in: mix, freq: cutoff, gain: resonance);

			var signal = Pan2.ar(filter*envelope,pan);

			Out.ar(out,signal);

		}).add;

		params = Dictionary.newFrom([
			\sub_div, 2,
			\noise_level, 0.1,
			\pulse_level, 1,
			\saw_level, 1,
			\sub_level, 1,
			\cutoff, 8000,
			\resonance, 3,
			\attack, 0,
			\release, 0.4,
			\amp, 0.5,
			\pan, 0;
		]);

		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});
		
		this.addCommand("hz", "f", { arg msg;
			Synth.new("LiedMotor", [\freq, msg[1]] ++ params.getPairs)
		});

	}

}
