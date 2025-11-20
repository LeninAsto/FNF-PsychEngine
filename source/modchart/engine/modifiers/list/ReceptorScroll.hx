package modchart.engine.modifiers.list;

import flixel.FlxG;
import flixel.math.FlxMath;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;
import modchart.backend.core.VisualParameters;
import modchart.backend.util.ModchartUtil;

class ReceptorScroll extends Modifier {
	override public function render(curPos:Vector3, params:ModifierParameters) {
		final perc = getPercent('receptorScroll', params.player);

		if (perc == 0)
			return curPos;

		final moveSpeed = Adapter.instance.getCurrentCrochet() * 4;

		var diff = -params.distance;
		var songTime = Adapter.instance.getSongPosition();
		var vDiff = -(diff - songTime) / moveSpeed;
		var reversed = Math.floor(vDiff) % 2 == 0;

		var startY = curPos.y;
		var revPerc = reversed ? 1 - vDiff % 1 : vDiff % 1;
		// haha perc 30
		var upscrollOffset = 50;
		var downscrollOffset = HEIGHT - 150;

		var endY = upscrollOffset + ((downscrollOffset - ARROW_SIZEDIV2) * revPerc) + ARROW_SIZEDIV2;

		curPos.y = FlxMath.lerp(startY, endY, perc);
		return curPos;
	}

	override public function visuals(data:VisualParameters, params:ModifierParameters):VisualParameters {
		final perc = getPercent('receptorScroll', params.player);
		if (perc == 0)
			return data;

		var bar = params.songTime / (Adapter.instance.getCurrentCrochet() * .25);
		var hitTime = params.distance;

		data.alpha = FlxMath.bound((1400 - hitTime) / 200, 0, 0.3) * perc;
		if ((params.distance + params.songTime) < Math.floor(bar + 1) * Adapter.instance.getCurrentCrochet() * 4)
			data.alpha = 1;

		return data;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
