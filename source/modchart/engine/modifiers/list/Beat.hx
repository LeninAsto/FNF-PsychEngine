package modchart.engine.modifiers.list;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;

class Beat extends Modifier {
	public function new(pf) {
		super(pf);

		for (x in ['x', 'y', 'z', ''])
			setPercent('beat${x}Speed', 1);
	}

	static final fAccelTime:Float = 0.2;
	static final fTotalTime:Float = 0.5;

	static final zeroOneFactor = 1 / fAccelTime;
	static final oneZeroFactor = 1 / fTotalTime;

	@:dox(hide)
	@:noCompletion private inline function beatMath(params:ModifierParameters, offset:Float, mult:Float, speed:Float):Float {
		var fBeat = ((params.curBeat * speed) + offset) + fAccelTime;

		if (fBeat <= 0)
			return 0;

		final bEvenBeat = Std.int(fBeat) % 2 != 0;
		fBeat = (fBeat % 1 + 1) % 1;

		if (fBeat >= fTotalTime)
			return 0;
		var fAmount:Float;

		if (fBeat < fAccelTime) {
			fAmount = Math.pow(fBeat * zeroOneFactor, 2);
		} else {
			final fcBeat = fBeat * oneZeroFactor;
			fAmount = (1 - fcBeat) * (1 + fcBeat);
		}

		if (bEvenBeat)
			fAmount *= -1;

		return 20 * fAmount * cos(params.distance * 0.01 * mult);
	}

	@:dox(hide)
	@:noCompletion private inline function computeBeat(curPos:Vector3, params:ModifierParameters, axis:String, realAxis:String) {
		final receptorName = Std.string(params.lane);
		final player = params.player;

		final amount = getPercent('beat' + axis, player) + getPercent('beat' + axis + receptorName, player);

		if (amount == 0)
			return curPos;

		final speed = 1 * getPercent('beat' + axis + 'Speed', player);
		final offset = getPercent('beat' + axis + 'Offset', player);
		final mult = getPercent('beat' + axis + 'Mult', player);

		var shift = beatMath(params, offset, 1 + mult, speed) * amount;

		switch (realAxis) {
			case 'x':
				curPos.x += shift;
			case 'y':
				curPos.y += shift;
			case 'z':
				curPos.z += shift;
		}

		return curPos;
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		computeBeat(curPos, params, '', 'x');
		computeBeat(curPos, params, 'x', 'x');
		computeBeat(curPos, params, 'y', 'y');
		computeBeat(curPos, params, 'z', 'z');

		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
