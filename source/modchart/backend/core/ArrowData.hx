package modchart.backend.core;

@:structInit
final class ArrowData {
	public var hitTime:Float = 0;
	public var distance:Float = 0;

	public var lane:Int = 0;
	public var player:Int = 0;

	public var hitten:Bool = false;
	public var isTapArrow:Bool = false;

	private var __holdSubdivisionOffset:Float = .0;

	public function toString() {
		return 'ModifierParameters(hitTime: $hitTime, distance: $distance, lane: $lane, player: $player, hitten: $hitten, isTapArrow: $isTapArrow)';
	}
}
