Engine_LiedMotorNew : CroneEngine {

	var params;

	alloc {
(
SynthDef("carrier1",
	{ arg inbus1 = 2,
		outbus1 = 0,
		freq1 = 440,
		carPartial1 = 1,
		index1 = 3,
		attack1 = 0,
		release1 = 0.4,
		phase1 = 0,
		mul1 = 0.2,
		pan1 = 0;

    // index values usually are between 0 and 24
    // carPartial :: modPartial => car/mod ratio

	var envelope1 = Env.perc(attackTime: attack1, releaseTime: release1, level: mul1).kr(doneAction: 2);
    var mod1 = In.ar(inbus1, 1);
	var signal1 = Pan2.ar((LFTri.ar((freq1 * carPartial1) + mod1, phase1, mul1)*envelope1),pan1);

    Out.ar(
        outbus1,
        signal1;
    )
}).add;

SynthDef("modulator1",
	{ arg outbus1 = 2,
		modfreq1 = 220,
		modPartial1 = 1,
		modindex1 = 3,
		modmul1 = 0.2;

    Out.ar(
        outbus1,
        LFTri.ar(modfreq1 * modPartial1, 0, modfreq1)
        *
        modmul1
        *
        modindex1
    )
}).add;

SynthDef("carrier2",
	{ arg inbus2 = 4,
		outbus2 = 0,
		freq2 = 440,
		carPartial2 = 1,
		index2 = 3,
		attack2 = 0,
		release2 = 0.4,
		phase2 = 0,
		mul2 = 0.2,
		pan2 = 0;

    // index values usually are between 0 and 24
    // carPartial :: modPartial => car/mod ratio

	var envelope2 = Env.perc(attackTime: attack2, releaseTime: release2, level: mul2).kr(doneAction: 2);
    var mod2 = In.ar(inbus2, 1);
	var signal2 = Pan2.ar((LFTri.ar((freq2 * carPartial2) + mod2, phase2, mul2)*envelope2),pan2);

    Out.ar(
        outbus2,
        signal2;
    )
}).add;

SynthDef("modulator2",
	{ arg outbus2 = 4,
		modfreq2 = 220,
		modPartial2 = 1,
		modindex2 = 3,
		modmul2 = 0.2;

    Out.ar(
        outbus2,
        LFTri.ar(modfreq2 * modPartial2, 0, modfreq2)
        *
        modmul2
        *
        modindex2
    )
}).add;

SynthDef("carrier3",
	{ arg inbus3 = 6,
		outbus3 = 0,
		freq3 = 440,
		carPartial3 = 1,
		index3 = 3,
		attack3 = 0,
		release3 = 0.4,
		phase3 = 0,
		mul3 = 0.2,
		pan3 = 0;

    // index values usually are between 0 and 24
    // carPartial :: modPartial => car/mod ratio

	var envelope3 = Env.perc(attackTime: attack3, releaseTime: release3, level: mul3).kr(doneAction: 2);
    var mod3 = In.ar(inbus3, 1);
	var signal3 = Pan2.ar((LFTri.ar((freq3 * carPartial3) + mod3, phase3, mul3)*envelope3),pan3);

    Out.ar(
        outbus3,
        signal3;
    )
}).add;

SynthDef("modulator3",
	{ arg outbus3 = 6,
		modfreq3 = 220,
		modPartial3 = 1,
		modindex3 = 3,
		modmul3 = 0.2;

    Out.ar(
        outbus3,
        LFTri.ar(modfreq3 * modPartial3, 0, modfreq3)
        *
        modmul3
        *
        modindex3
    )
}).add;

SynthDef("carrier4",
	{ arg inbus4 = 8,
		outbus4 = 0,
		freq4 = 440,
		carPartial4 = 1,
		index4 = 3,
		attack4 = 0,
		release4 = 0.4,
		phase4 = 0,
		mul4 = 0.2,
		pan4 = 0;

    // index values usually are between 0 and 24
    // carPartial :: modPartial => car/mod ratio

	var envelope4 = Env.perc(attackTime: attack4, releaseTime: release4, level: mul4).kr(doneAction: 2);
    var mod4 = In.ar(inbus4, 1);
	var signal4 = Pan2.ar((LFTri.ar((freq4 * carPartial4) + mod4, phase4, mul4)*envelope4),pan4);

    Out.ar(
        outbus4,
        signal4;
    )
}).add;

SynthDef("modulator4",
	{ arg outbus4 = 8,
		modfreq4 = 220,
		modPartial4 = 1,
		modindex4 = 3,
		modmul4 = 0.2;

    Out.ar(
        outbus4,
        LFTri.ar(modfreq4 * modPartial4, 0, modfreq4)
        *
        modmul4
        *
        modindex4
    )
}).add;
)

		params = Dictionary.newFrom([
			\carPartial1, 1,
			\index1, 3,
			\attack1, 0,
			\release1, 0.4,
			\phase1, 0,
			\mul1, 0.2,
			\pan1, 0,
			\modfreq1, 220,
			\modPartial1, 1,
			\modindex1, 3,
			\modmul1, 0.2,
			\carPartial2, 1,
			\index2, 3,
			\attack2, 0,
			\release2, 0.4,
			\phase2, 0,
			\mul2, 0.2,
			\pan2, 0,
			\modfreq2, 220,
			\modPartial2, 1,
			\modindex2, 3,
			\modmul2, 0.2,
			\carPartial3, 1,
			\index3, 3,
			\attack3, 0,
			\release3, 0.4,
			\phase3, 0,
			\mul3, 0.2,
			\pan3, 0,
			\modfreq3, 220,
			\modPartial3, 1,
			\modindex3, 3,
			\modmul3, 0.2,
			\carPartial4, 1,
			\index4, 3,
			\attack4, 0,
			\release4, 0.4,
			\phase4, 0,
			\mul4, 0.2,
			\pan4, 0,
			\modfreq4, 220,
			\modPartial4, 1,
			\modindex4, 3,
			\modmul4, 0.2;
		]);

		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1];
			});
		});

		this.addCommand("hzone", "f", { arg msg;
			Synth.new("moulator1", \modfreq1 ++ params.getPairs);
			Synth.new("carrier1", [\freq1, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hztwo", "f", { arg msg;
			Synth.new("moulator2", \modfreq2 ++ params.getPairs);
			Synth.new("carrier2", [\freq2, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzthree", "f", { arg msg;
			Synth.new("moulator3", \modfreq3 ++ params.getPairs);
			Synth.new("carrier3", [\freq3, msg[1]] ++ params.getPairs)
		});

		this.addCommand("hzfour", "f", { arg msg;
			Synth.new("moulator4", \modfreq4 ++ params.getPairs);
			Synth.new("carrier4", [\freq4, msg[1]] ++ params.getPairs)
		});

	}

}
