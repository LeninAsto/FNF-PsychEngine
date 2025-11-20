package modchart.backend.graphics;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.util.FlxSort;

@:publicFields
@:structInit
class FMDrawInstruction {
	var item:FlxSprite;
	var vertices:openfl.Vector<Float>;
	var uvt:openfl.Vector<Float>;
	var indices:openfl.Vector<Int>;
	var colorData:Array<ColorTransform>;

	var extra:Array<Dynamic>;
	var mappedExtra:Map<String, Dynamic>;

	public function new() {}
}

class ModchartRenderer<T:FlxBasic> extends FlxBasic {
	private var instance:Null<PlayField>;
	private var queue:NativeVector<FMDrawInstruction>;
	private var count:Int = 0;
	private var postCount:Int = 0;

	private var projection(get, never):ModchartPerspective;

	function get_projection()
		return instance.projection;

	public function new(instance:PlayField) {
		super();

		this.instance = instance;
	}

	// Renderer-side
	public function prepare(item:T) {}

	public function shift():Void {}

	public function dispose() {}

	// Built-in functions
	public function preallocate(length:Int) {
		queue = new NativeVector<FMDrawInstruction>(length);
		count = postCount = 0;
	}

	public function sort() {
		if (queue == null || queue.length <= 0)
			return;
		queue.sort((a, b) -> {
			if (a == null || b == null)
				return 0;
			return FlxSort.byValues(FlxSort.DESCENDING, a.item._z, b.item._z);
		});
	}

	// public function render(times:Null<Int>):Void {}
}
