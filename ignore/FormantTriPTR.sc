FormantTriPTR : UGen {
	*ar { |freq=440.0, formant=440.0, width=0.5, phase=0.0, sync=0.0|
		^this.multiNew('audio', freq, formant, width, phase, sync);
	}
	checkInputs {
		^this.checkValidInputs;
	}
}
