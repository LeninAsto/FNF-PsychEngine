package modchart.backend.core;

@:publicFields
@:structInit
final class ModifierParameters {
	var songTime:Float;
	var hitTime:Float;
	var distance:Float;
	var curBeat:Float;

	var lane:Int = 0;
	var player:Int = 0;
	var isTapArrow:Bool = false;

	public function toString() {
		return 'ModifierParameters(songTime: $songTime, hitTime: $hitTime, distance: $distance, curBeat: $curBeat, lane: $lane, player: $player)';
	}
}
