package modchart.engine.modifiers.list;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;
import modchart.backend.util.ModchartUtil;

class Boost extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('waveMult', 1, -1);
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		var player = params.player;
		var lane = Std.string(params.lane);

		var fYOffset = params.distance;

		final boost = (getPercent('boost', params.player) + getPercent('boost' + lane, params.player));
		if (boost != 0) {
			var fEffectHeight = HEIGHT;
			var fNewYOffset = fYOffset * 1.5 / ((fYOffset + fEffectHeight / 1.2) / fEffectHeight);
			var fAccelYAdjust = .75 * boost * (fNewYOffset - fYOffset);
			fAccelYAdjust = ModchartUtil.clamp(fAccelYAdjust, -400, 400);

			curPos.y += fAccelYAdjust;
		}

		final brake = (getPercent('brake', params.player) + getPercent('brake' + lane, params.player));

		if (brake != 0) {
			var fEffectHeight = HEIGHT;
			var fScale = FlxMath.remapToRange(fYOffset, 0., fEffectHeight, 0, 1.);
			var fNewYOffset = fYOffset * fScale;
			var fBrakeYAdjust = .75 * brake * (fNewYOffset - fYOffset);
			fBrakeYAdjust = ModchartUtil.clamp(fBrakeYAdjust, -400., 400.);
			curPos.y += fBrakeYAdjust;
		}
		final wave = (getPercent('wave', params.player) + getPercent('wave' + lane, params.player));

		if (wave != 0) {
			curPos.y += wave * 20.0 * sin(fYOffset / 96.);
		}

		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
