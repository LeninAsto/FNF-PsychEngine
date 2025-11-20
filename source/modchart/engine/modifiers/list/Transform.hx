package modchart.engine.modifiers.list;

import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;

class Transform extends Modifier {
	var xID = 0;
	var yID = 0;
	var zID = 0;

	var xOID = 0;
	var yOID = 0;
	var zOID = 0;

	public function new(pf) {
		super(pf);

		xID = findID('x');
		yID = findID('y');
		zID = findID('z');

		xOID = findID('xoffset');
		yOID = findID('yoffset');
		zOID = findID('zoffset');
	}

	override public function render(curPos:Vector3, params:ModifierParameters) {
		var receptorName = Std.string(params.lane);
		var player = params.player;

		curPos.x += getUnsafe(xID, player) + getUnsafe(xOID, player) + getPercent('x' + receptorName, player);
		curPos.y += getUnsafe(yID, player) + getUnsafe(yOID, player) + getPercent('y' + receptorName, player);
		curPos.z += getUnsafe(zID, player) + getUnsafe(zOID, player) + getPercent('z' + receptorName, player);

		return curPos;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
