Engine_LiedMotor : CroneEngine {

	var params;
	var firstvoice;
	var secondvoice;
	var thirdvoice;
	var fourthvoice;
	var fifthvoice;
	var sixthvoice;

	alloc {

SynthDef("sinsin",
	{ arg sinsin_carfreq = 440,
		sinsin_index = 1,
		sinsin_modnum = 1,
		sinsin_modeno = 1,
		sinsin_phase = 0,
		sinsin_attack = 0,
		sinsin_release = 0.4,
		sinsin_amp = 0.2,
		sinsin_pan = 0;

	var sinsin_modfreq = (sinsin_modnum/sinsin_modeno)*sinsin_carfreq;
	var sinsin_env = Env.perc(attackTime: sinsin_attack, releaseTime: sinsin_release, level: sinsin_amp).kr(doneAction: 2);
	var sinsin_signal = Pan2.ar((SinOsc.ar(sinsin_carfreq + (sinsin_index*sinsin_modfreq*SinOsc.ar(sinsin_modfreq)), sinsin_phase, sinsin_amp)*sinsin_env),sinsin_pan);

    Out.ar(
        0,
        sinsin_signal;
    )
}).add;

SynthDef("trisin",
	{ arg trisin_carfreq = 440,
		trisin_index = 1,
		trisin_modnum = 1,
		trisin_modeno = 1,
		trisin_phase = 0,
		trisin_attack = 2,
		trisin_release = 2,
		trisin_amp = 0.2,
		trisin_pan = 0;

	var trisin_modfreq = (trisin_modnum/trisin_modeno)*trisin_carfreq;
	var trisin_env = Env.perc(attackTime: trisin_attack, releaseTime: trisin_release, level: trisin_amp).kr(doneAction: 2);
				var trisin_signal = Pan2.ar((LFTri.ar(trisin_carfreq + (trisin_index*trisin_modfreq*SinOsc.ar(trisin_modfreq)), trisin_phase, trisin_amp)*trisin_env), trisin_pan);

    Out.ar(
        0,
        trisin_signal;
    )
}).add;


SynthDef("ringer",
	{ arg ringer_freq = 440,
		ringer_index = 3,
		ringer_amp = 0.2,
		ringer_pan = 0;

	var ringer_env = Env.perc(attackTime: 0.01, releaseTime: ringer_index*2, level: ringer_amp).kr(doneAction: 2);
	var ringer_signal = Pan2.ar((Ringz.ar(Impulse.ar(0), ringer_freq, ringer_index, ringer_amp)*ringer_env),ringer_pan);

    Out.ar(
        0,
        ringer_signal;
    )
}).add;

SynthDef("tritri",
	{ arg tritri_carfreq = 440,
		tritri_index = 1,
		tritri_modnum = 1,
		tritri_modeno = 1,
		tritri_width = 0.7,
		tritri_modwidth = 0.7,
		tritri_phase = 0,
		tritri_modphase = 0,
		tritri_attack = 2,
		tritri_release = 2,
		tritri_amp = 0.2,
		tritri_pan = 0;

	var tritri_modfreq = (tritri_modnum/tritri_modeno)*tritri_carfreq;
	var tritri_env = Env.perc(attackTime: tritri_attack, releaseTime: tritri_release, level: tritri_amp).kr(doneAction: 2);
	var tritri_signal = Pan2.ar((SineShaper.ar(FormantTriPTR.ar(tritri_carfreq + (tritri_index*tritri_modfreq*FormantTriPTR.ar(tritri_modfreq, tritri_modfreq, tritri_modwidth, tritri_modphase)), tritri_carfreq, tritri_width, tritri_phase, 0.0),1,Pulse.ar(tritri_carfreq))*tritri_env),tritri_pan);

    Out.ar(
        0,
        tritri_signal;
    )
}).add;

SynthDef("karplu",
	{ arg karplu_freq = 440,
		karplu_index = 3,
		karplu_coef = 0.5,
		karplu_amp = 0.2,
		karplu_pan = 0;

	var karplu_env = Env.perc(attackTime: 0.01, releaseTime: karplu_index*2, level: karplu_amp).kr(doneAction: 2);
	var karplu_signal = Pan2.ar((Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(0), karplu_freq.reciprocal, karplu_freq.reciprocal, karplu_index, karplu_coef)*karplu_env),karplu_pan);

    Out.ar(
        0,
        karplu_signal;
    )
}).add;

SynthDef("resonz",
	{ arg resonz_freq = 440,
		resonz_index = 0.1,
		resonz_amp = 4,
		resonz_pan = 0;

	var resonz_env = Env.perc(attackTime: 0.01, releaseTime: resonz_index*30, level: resonz_amp).kr(doneAction: 2);
	var resonz_signal = Pan2.ar((Resonz.ar(Impulse.ar(0), resonz_freq, resonz_index, resonz_amp)*resonz_env),resonz_pan);

    Out.ar(
        0,
        resonz_signal;
    )
}).add;

		params = Dictionary.newFrom([
			\sinsin_index, 3,
			\sinsin_attack, 0,
			\sinsin_release, 0.4,
			\sinsin_phase, 0,
			\sinsin_amp, 0.2,
			\sinsin_pan, 0,
			\sinsin_modnum, 1,
			\sinsin_modeno, 1,
			\trisin_index, 3,
			\trisin_attack, 0,
			\trisin_release, 0.4,
			\trisin_phase, 0,
			\trisin_amp, 0.2,
			\trisin_pan, 0,
			\trisin_modnum, 1,
			\trisin_modeno, 1,
			\trisin_width, 0.7,
			\ringer_index, 3,
			\ringer_amp, 0.2,
			\ringer_pan, 0,
			\tritri_index, 3,
			\tritri_amp, 0.2,
			\tritri_pan, 0,
			\tritri_modnum, 1,
			\tritri_modeno, 1,
			\tritri_width, 0.7,
			\tritri_modwidth, 0.7,
			\tritri_phase, 0,
			\tritri_modphase, 0,
			\tritri_attack, 2,
			\tritri_release, 2,
			\karplu_index, 3,
			\karplu_coef, 0.5,
			\karplu_amp, 0.2,
			\karplu_pan, 0,
			\resonz_index, 0.1,
			\resonz_amp, 4,
			\resonz_pan, 0
		]);

		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

		this.addCommand("sinsinhz", "f", { arg msg;
			firstvoice = Synth.new("sinsin", [\sinsin_carfreq, msg[1]] ++ params.getPairs)
		});

		this.addCommand("trisinhz", "f", { arg msg;
			secondvoice = Synth.new("trisin", [\trisin_carfreq, msg[1]] ++ params.getPairs)
		});

		this.addCommand("ringerhz", "f", { arg msg;
			thirdvoice = Synth.new("ringer", [\ringer_freq, msg[1]] ++ params.getPairs)
		});

		this.addCommand("tritrihz", "f", { arg msg;
			fourthvoice = Synth.new("tritri", [\tritri_carfreq, msg[1]] ++ params.getPairs)
		});

		this.addCommand("karpluhz", "f", { arg msg;
			fifthvoice = Synth.new("karplu", [\karplu_freq, msg[1]] ++ params.getPairs)
		});

		this.addCommand("resonzhz", "f", { arg msg;
			sixthvoice = Synth.new("resonz", [\resonz_freq, msg[1]] ++ params.getPairs)
		});
	}
}
