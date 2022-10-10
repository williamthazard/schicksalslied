Engine_LiedMotor : CroneEngine {

	var params;
	var firstvoice;
	var secondvoice;
	var thirdvoice;
	var fourthvoice;
	var fifthvoice;
	var sixthvoice;
	var seventhvoice;
	var eighthvoice;

	alloc {

SynthDef("voice1",
	{ arg carfreq1 = 440,
		index1 = 1,
		modfreq1 = 440,
		phase1 = 0,
		attack1 = 0,
		release1 = 0.4,
		mul1 = 0.2,
		pan1 = 0;

	var envelope1 = Env.perc(attackTime: attack1, releaseTime: release1, level: mul1).kr(doneAction: 2);
	var signal1 = Pan2.ar((SinOsc.ar(carfreq1 + (index1*modfreq1*SinOsc.ar(modfreq1)), phase1, mul1)*envelope1),pan1);

    Out.ar(
        0,
        signal1;
    )
}).add;

SynthDef("voice2",
	{ arg carfreq2 = 440,
		index2 = 1,
		modfreq2 = 440,
		phase2 = 0,
		attack2 = 0,
		release2 = 0.4,
		mul2 = 0.2,
		pan2 = 0;

	var envelope2 = Env.perc(attackTime: attack2, releaseTime: release2, level: mul2).kr(doneAction: 2);
	var signal2 = Pan2.ar((SinOsc.ar(carfreq2 + (index2*modfreq2*LFTri.ar(modfreq2)), phase2, mul2)*envelope2),pan2);

    Out.ar(
        0,
        signal2;
    )
}).add;


SynthDef("voice3",
	{ arg carfreq3 = 440,
		index3 = 1,
		modfreq3 = 440,
		phase3 = 0,
		attack3 = 0,
		release3 = 0.4,
		mul3 = 0.2,
		pan3 = 0;

	var envelope3 = Env.perc(attackTime: attack3, releaseTime: release3, level: mul3).kr(doneAction: 2);
	var signal3 = Pan2.ar((LFTri.ar(carfreq3 + (index3*modfreq3*SinOsc.ar(modfreq3)), phase3, mul3)*envelope3),pan3);

    Out.ar(
        0,
        signal3;
    )
}).add;


SynthDef("voice4",
	{ arg carfreq4 = 440,
		index4 = 1,
		modfreq4 = 440,
		phase4 = 0,
		attack4 = 0,
		release4 = 0.4,
		mul4 = 0.2,
		pan4 = 0;

	var envelope4 = Env.perc(attackTime: attack4, releaseTime: release4, level: mul4).kr(doneAction: 2);
	var signal4 = Pan2.ar((LFTri.ar(carfreq4 + (index4*modfreq4*LFTri.ar(modfreq4)), phase4, mul4)*envelope4),pan4);

    Out.ar(
        0,
        signal4;
    )
}).add;

SynthDef("voice5",
	{ arg carfreq5 = 440,
		index5 = 1,
		modfreq5 = 440,
		phase5 = 0,
		attack5 = 0,
		release5 = 0.4,
		mul5 = 0.2,
		pan5 = 0;

	var envelope5 = Env.perc(attackTime: attack5, releaseTime: release5, level: mul5).kr(doneAction: 2);
	var signal5 = Pan2.ar((SinOsc.ar(carfreq5 + (index5*modfreq5*SinOsc.ar(modfreq5)), phase5, mul5)*envelope5),pan5);

    Out.ar(
        0,
        signal5;
    )
}).add;

SynthDef("voice6",
	{ arg carfreq6 = 440,
		index6 = 1,
		modfreq6 = 440,
		phase6 = 0,
		attack6 = 0,
		release6 = 0.4,
		mul6 = 0.2,
		pan6 = 0;

	var envelope6 = Env.perc(attackTime: attack6, releaseTime: release6, level: mul6).kr(doneAction: 2);
	var signal6 = Pan2.ar((SinOsc.ar(carfreq6 + (index6*modfreq6*LFTri.ar(modfreq6)), phase6, mul6)*envelope6),pan6);

    Out.ar(
        0,
        signal6;
    )
}).add;

SynthDef("voice7",
	{ arg carfreq7 = 440,
		index7 = 1,
		modfreq7 = 440,
		phase7 = 0,
		attack7 = 0,
		release7 = 0.4,
		mul7 = 0.2,
		pan7 = 0;

	var envelope7 = Env.perc(attackTime: attack7, releaseTime: release7, level: mul7).kr(doneAction: 2);
	var signal7 = Pan2.ar((LFTri.ar(carfreq7 + (index7*modfreq7*SinOsc.ar(modfreq7)), phase7, mul7)*envelope7),pan7);

    Out.ar(
        0,
        signal7;
    )
}).add;

SynthDef("voice8",
	{ arg carfreq8 = 440,
		index8 = 1,
		modfreq8 = 440,
		phase8 = 0,
		attack8 = 0,
		release8 = 0.4,
		mul8 = 0.2,
		pan8 = 0;

	var envelope8 = Env.perc(attackTime: attack8, releaseTime: release8, level: mul8).kr(doneAction: 2);
	var signal8 = Pan2.ar((LFTri.ar(carfreq8 + (index8*modfreq8*LFTri.ar(modfreq8)), phase8, mul8)*envelope8),pan8);

    Out.ar(
        0,
        signal8;
    )
}).add;


		params = Dictionary.newFrom([
			\index1, 3,
			\attack1, 0,
			\release1, 0.4,
			\phase1, 0,
			\mul1, 0.2,
			\pan1, 0,
			\modfreq1, 220,
			\index2, 3,
			\attack2, 0,
			\release2, 0.4,
			\phase2, 0,
			\mul2, 0.2,
			\pan2, 0,
			\modfreq2, 220,
			\index3, 3,
			\attack3, 0,
			\release3, 0.4,
			\phase3, 0,
			\mul3, 0.2,
			\pan3, 0,
			\modfreq3, 220,
			\index4, 3,
			\attack4, 0,
			\release4, 0.4,
			\phase4, 0,
			\mul4, 0.2,
			\pan4, 0,
			\modfreq4, 220,
			\index5, 3,
			\attack5, 0,
			\release5, 0.4,
			\phase5, 0,
			\mul5, 0.2,
			\pan5, 0,
			\modfreq5, 220,
			\index6, 3,
			\attack6, 0,
			\release6, 0.4,
			\phase6, 0,
			\mul6, 0.2,
			\pan6, 0,
			\modfreq6, 220,
			\index7, 3,
			\attack7, 0,
			\release7, 0.4,
			\phase7, 0,
			\mul7, 0.2,
			\pan7, 0,
			\modfreq7, 220,
			\index8, 3,
			\attack8, 0,
			\release8, 0.4,
			\phase8, 0,
			\mul8, 0.2,
			\pan8, 0,
			\modfreq8, 220
		]);

		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

		this.addCommand("hzone", "f", { arg msg;
			firstvoice = Synth.new("voice1", [\carfreq1, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hztwo", "f", { arg msg;
			secondvoice = Synth.new("voice2", [\carfreq2, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzthree", "f", { arg msg;
			thirdvoice = Synth.new("voice3", [\carfreq3, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzfour", "f", { arg msg;
			fourthvoice = Synth.new("voice4", [\carfreq4, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzfive", "f", { arg msg;
			fifthvoice = Synth.new("voice5", [\carfreq5, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzsix", "f", { arg msg;
			sixthvoice = Synth.new("voice6", [\carfreq6, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzseven", "f", { arg msg;
			seventhvoice = Synth.new("voice7", [\carfreq7, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzeight", "f", { arg msg;
			eighthvoice = Synth.new("voice8", [\carfreq8, msg[1]] ++ params.getPairs)
		});
	}
}
