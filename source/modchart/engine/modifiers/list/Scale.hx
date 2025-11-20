package modchart.engine.modifiers.list;

import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;
import modchart.backend.core.VisualParameters;

class Scale extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('scale', 1, -1);
		setPercent('scaleX', 1, -1);
		setPercent('scaleY', 1, -1);
	}

	private inline function applyScale(vis:VisualParameters, params:ModifierParameters, axis:String, realAxis:String) {
		var receptorName = Std.string(params.lane);
		var player = params.player;

		var scale = 1.;
		// Scale
		scale *= getPercent('scale' + axis, player) + getPercent('scale' + axis + receptorName, player);
		scale *= 1 - (getPercent('tiny' + axis, player) + getPercent('tiny' + axis + receptorName, player)) * 0.5;

		switch (realAxis) {
			case 'x':
				vis.scaleX *= scale;
			case 'y':
				vis.scaleY *= scale;
			default:
				vis.scaleX *= scale;
				vis.scaleY *= scale;
		}
	}

	override public function visuals(data:VisualParameters, params:ModifierParameters) {
		var player = params.player;
		var receptorName = Std.string(params.lane);

		applyScale(data, params, '', '');
		applyScale(data, params, 'x', 'x');
		applyScale(data, params, 'y', 'y');

		data.scaleX *= 1;
		data.scaleY *= 1;

		return data;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
