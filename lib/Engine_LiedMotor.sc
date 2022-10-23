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
		pan1 = 0,
		slew1 = 0.1;

	var envelope1 = Env.perc(attackTime: attack1, releaseTime: release1, level: mul1).kr(doneAction: 2);
	var signal1 = Pan2.ar((SinOsc.ar(Lag.kr(carfreq1,slew1) + (index1*modfreq1*SinOsc.ar(modfreq1)), phase1, mul1)*envelope1),pan1);

    Out.ar(
        0,
        signal1;
    )
}).add;

SynthDef("voice2",
	{ arg carfreq2 = 440,
		index2 = 1,
		modnum2 = 1,
		modeno2 = 1,
		width2 = 0.7,
		phase2 = 0,
		attack2 = 2,
		release2 = 2,
		mul2 = 0.2,
		pan2 = 0,
		slew2 = 0.1;

	var modfreq2 = (modnum2/modeno2)*carfreq2;
	var envelope2 = Env.perc(attackTime: attack2, releaseTime: release2, level: mul2).kr(doneAction: 2);
				var signal2 = Pan2.ar((SineShaper.ar(FormantTriPTR.ar(carfreq2 + (index2*modfreq2*FormantTriPTR.ar(modfreq2)), carfreq2, SinOsc.kr(0.5,0,1), phase2, 0.0),1,Pulse.ar(carfreq2))*envelope2),pan2);

    Out.ar(
        0,
        signal2;
    )
}).play;


SynthDef("voice3",
	{ arg carfreq3 = 440,
		index3 = 1,
		coef3 = 0.5,
		mul3 = 0.2,
		pan3 = 0,
		slew3 = 0.1;

	var envelope3 = Env.perc(attackTime: 0.01, releaseTime: index3*2, level: mul3).kr(doneAction: 2);
	var signal3 = Pan2.ar((Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(0), Lag.kr(carfreq3.reciprocal,slew3), Lag.kr(carfreq3.reciprocal,slew3), index3,

					coef3)*envelope3),pan3);

    Out.ar(
        0,
        signal3;
    )
}).add;

SynthDef("voice4",
	{ arg carfreq4 = 440,
		index4 = 0,
		modnum4 = 1,
		modeno4 = 1,
		width4 = 0.7,
		phase4 = 0,
		attack4 = 2,
		release4 = 2,
		mul4 = 0.2,
		pan4 = 0;

	var modfreq4 = (modnum4/modeno4)*carfreq4;
	var envelope4 = Env.perc(attackTime: attack4, releaseTime: release4, level: mul4).kr(doneAction: 2);
				var signal4 = Pan2.ar((SineShaper.ar(FormantTriPTR.ar(carfreq4 + (index4*modfreq4*FormantTriPTR.ar(modfreq4)), carfreq4, width4, phase4, 0.0),1,PulsePTR.ar(carfreq4, phase4, 0, width4)[0])*envelope4),pan4);

    Out.ar(
        0,
        signal4;
    )
}).add;

SynthDef("voice5",
	{ arg carfreq5 = 440,
		index5 = 1,
		coef5 = 0.5,
		mul5 = 0.2,
		pan5 = 0;

	var envelope5 = Env.perc(attackTime: 0.01, releaseTime: index5*2, level: mul5).kr(doneAction: 2);
	var signal5 = Pan2.ar((Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(0), carfreq5.reciprocal, carfreq5.reciprocal, index5, coef5)*envelope5),pan5);

    Out.ar(
        0,
        signal5;
    )
}).add;

SynthDef("voice6",
	{ arg carfreq6 = 440,
		index6 = 1,
		coef6 = 0.5,
		mul6 = 0.2,
		pan6 = 0;

	var envelope6 = Env.perc(attackTime: 0.01, releaseTime: index6*2, level: mul6).kr(doneAction: 2);
	var signal6 = Pan2.ar((Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(0), carfreq6.reciprocal, carfreq6.reciprocal, index6, coef6)*envelope6),pan6);

    Out.ar(
        0,
        signal6;
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
			\slew1, 0.1,
			\index2, 3,
			\attack2, 0,
			\release2, 0.4,
			\phase2, 0,
			\mul2, 0.2,
			\pan2, 0,
			\modfreq2, 220,
			\slew2, 0.1,
			\index3, 3,
			\mul3, 0.2,
			\pan3, 0,
			\coef3, 220,
			\slew3, 0.1,
			\index4, 3,
			\mul4, 0.2,
			\pan4, 0,
			\coef4, 220,
			\slew4, 0.1,
			\index5, 3,
			\coef5, 0.5,
			\mul5, 0.2,
			\pan5, 0,
			\slew5, 0.1,
			\index6, 3,
			\attack6, 0,
			\release6, 0.4,
			\phase6, 0,
			\mul6, 0.2,
			\pan6, 0,
			\modfreq6, 220,
			\slew6, 0.1
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
	}
}
