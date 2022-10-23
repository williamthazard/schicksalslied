PulsePTR : MultiOutUGen {
    // Audio rate output
	*ar { |freq=440.0, phase=0.0, sync=0.0, width=0.5|
		^this.multiNew('audio', freq, phase, sync, width);
	}
    // Control rate output
    *kr { |freq=1.0, phase=0.0, sync=0.0, width=0.5|
      ^this.multiNew('control', freq, phase, sync, width);
    }
    init { arg ... theInputs;
      inputs = theInputs;
      ^this.initOutputs(2, rate);
    }
	checkInputs {
		^this.checkValidInputs;
	}
}
