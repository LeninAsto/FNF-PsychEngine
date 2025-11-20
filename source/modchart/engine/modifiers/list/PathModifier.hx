package modchart.engine.modifiers.list;

import flixel.math.FlxMath;
import haxe.ds.Vector;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;
import modchart.backend.util.ModchartUtil;
import modchart.engine.PlayField;

/**
 * Manages path-based transformations for arrows.
 * 
 * This modifier interpolates arrow positions along a predefined path,
 * allowing smooth transitions and animations.
 * 
 * @author TheoDev
 */
class PathModifier extends Modifier {
	private var __path:Vector<PathNode>;
	private var __pathBound(default, set):Float;

	private var __boundDiv:Float;

	function set___pathBound(value:Float):Float {
		__boundDiv = 1 / value;
		return __pathBound = value;
	}

	public var pathOffset:Vector3 = new Vector3();

	public function new(pf:PlayField, path:Array<PathNode>) {
		super(pf);

		__pathBound = 1500;
		loadPath(path);
	}

	public function loadPath(newPath:Array<PathNode>) {
		__path = Vector.fromArrayCopy(newPath);
	}

	public function computePath(pos:Vector3, params:ModifierParameters, percent:Float) {
		final __path_length = __path.length;
		if (__path_length <= 0)
			return pos;
		if (__path_length == 1) {
			final pathNode = __path[0];
			return new Vector3(pathNode.x, pathNode.y, pathNode.z);
		}

		final nodeProgress = (__path_length - 1) * Math.min(__pathBound, params.distance) * __boundDiv;
		final thisNodeIndex = Math.floor(nodeProgress);
		final nextNodeIndex = FlxMath.minInt(thisNodeIndex + 1, __path_length - 1);
		final nextNodeRatio = nodeProgress - thisNodeIndex;

		final thisNode = __path[thisNodeIndex];
		final nextNode = __path[nextNodeIndex];

		return pos.interpolate(new Vector3(FlxMath.lerp(thisNode.x, nextNode.x, nextNodeRatio), FlxMath.lerp(thisNode.y, nextNode.y, nextNodeRatio),
			FlxMath.lerp(thisNode.z, nextNode.z, nextNodeRatio)).add(pathOffset),
			percent, pos);
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}

@:structInit
class PathNode {
	public var x:Float;
	public var y:Float;
	public var z:Float;
}
