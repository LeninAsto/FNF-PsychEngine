package modchart.engine.modifiers.list;

import flixel.FlxG;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;
import modchart.backend.util.ModchartUtil;

class FieldRotate extends Rotate {
	override public function getOrigin(curPos:Vector3, params:ModifierParameters):Vector3 {
		var x:Float = (WIDTH * 0.5) - ARROW_SIZE - 54 + ARROW_SIZE * 1.5;
		switch (params.player) {
			case 0:
				x -= WIDTH * 0.5 - ARROW_SIZE * 2 - 100;
			case 1:
				x += WIDTH * 0.5 - ARROW_SIZE * 2 - 100;
		}
		x -= 56;

		return new Vector3(x, HEIGHT * 0.5);
	}

	override public function getRotateName():String
		return 'fieldRotate';

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
