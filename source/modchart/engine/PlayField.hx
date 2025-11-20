package modchart.engine;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase.EaseFunction;
import modchart.backend.core.Node.NodeFunction;
import modchart.backend.graphics.*;
import modchart.backend.graphics.renderers.*;
import modchart.backend.util.ModchartUtil;
import modchart.engine.events.types.*;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

// TODO: make this extend to flxsprite and use parented transformation matrix
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
final class PlayField extends FlxSprite {
	public var events:EventManager;
	public var modifiers:ModifierGroup;
	public var camera3D:ModchartCamera3D;

	private var arrowRenderer:ModchartArrowRenderer;
	private var receptorRenderer:ModchartArrowRenderer;
	private var attachmentRenderer:ModchartArrowRenderer;
	private var holdRenderer:ModchartHoldRenderer;
	private var pathRenderer:ModchartPathRenderer;

	public var projection:ModchartPerspective;

	public function new() {
		super();

		moves = false;

		this.events = new EventManager(this);
		this.modifiers = new ModifierGroup(this);

		arrowRenderer = new ModchartArrowRenderer(this);
		receptorRenderer = new ModchartArrowRenderer(this);
		attachmentRenderer = new ModchartArrowRenderer(this);
		holdRenderer = new ModchartHoldRenderer(this);
		pathRenderer = new ModchartPathRenderer(this);

		camera3D = new ModchartCamera3D();
		projection = new ModchartPerspective();

		// default mods
		addModifier('reverse');
		addModifier('confusion');
		addModifier('stealth');
		addModifier('skew');
		addModifier('zoom');

		setPercent('arrowPathAlpha', 1, -1);
		setPercent('arrowPathThickness', 2, -1);
		setPercent('rotateHoldY', 1, -1);
	}

	public inline function setPercent(name:String, value:Float, player:Int = -1)
		return modifiers.setPercent(name, value, player);

	public inline function getPercent(name:String, player:Int)
		return modifiers.getPercent(name, player);

	public inline function addModifier(name:String)
		return modifiers.addModifier(name);

	public inline function addScriptedModifier(name:String, instance:Modifier)
		return modifiers.addScriptedModifier(name, instance);

	public inline function addEvent(event:Event) {
		events.add(event);
	}

	public inline function set(name:String, beat:Float, value:Float, player:Int = -1):Void {
		if (player == -1) {
			for (curField in 0...Adapter.instance.getPlayerCount())
				set(name, beat, value, curField);
			return;
		}

		addEvent(new SetEvent(name.toLowerCase(), beat, value, player, events));
	}

	public inline function ease(name:String, beat:Float, length:Float, value:Float = 1, easeFunc:EaseFunction, player:Int = -1):Void {
		if (player == -1) {
			for (curField in 0...Adapter.instance.getPlayerCount())
				ease(name, beat, length, value, easeFunc, curField);
			return;
		}

		addEvent(new EaseEvent(name, beat, length, value, easeFunc, player, events));
	}

	public inline function add(name:String, beat:Float, length:Float, addition:Float = 1, easeFunc:EaseFunction, player:Int = -1):Void {
		if (player == -1) {
			for (curField in 0...Adapter.instance.getPlayerCount())
				add(name, beat, length, addition, easeFunc, curField);
			return;
		}

		addEvent(new AddEvent(name, beat, length, addition, easeFunc, player, events));
	}

	public inline function setAdd(name:String, beat:Float, valueToAdd:Float, player:Int = -1):Void {
		var addition = getPercent(name, player == -1 ? 0 : player);
		var value = addition + valueToAdd;
		if (player == -1) {
			for (curField in 0...Adapter.instance.getPlayerCount())
				set(name, beat, value, curField);
			return;
		}

		addEvent(new SetEvent(name.toLowerCase(), beat, value, player, events));
	}

	public inline function repeater(beat:Float, length:Float, callback:Event->Void):Void
		addEvent(new RepeaterEvent(beat, length, callback, events));

	public inline function callback(beat:Float, callback:Event->Void):Void
		addEvent(new Event(beat, callback, events));

	public inline function alias(name:String, alias:String) {
		aliases.push({
			parent: name,
			alias: alias
		});
	}

	private var aliases:Array<ModAlias> = [];
	private var nodes:Array<Node> = [];

	/**
	 * Register a node.
	 * @param input Input Aux Mods
	 * @param output Output Mods
	 * @param func Processor function, Array<InputModPercs> -> Array<OutputModPercs>
	 */
	public inline function node(input:Array<String>, output:Array<String>, func:NodeFunction) {
		nodes.push({
			input: input,
			output: output,
			func: func
		});
	}

	// EXPERIMENTAL
	// FIXME
	// Warning: If a node has 'drunk' by example in his output
	// and u made a ease on drunk and u made a ease on the node
	// input, the eases may overlap, causing visuals issues.
	public function updateNodes() {
		for (player in 0...Adapter.instance.getPlayerCount()) {
			final it = nodes.iterator();
			final n = it.next;
			final h = it.hasNext;
			do {
				final node = n();
				if (node == null)
					continue;

				var entryPercs = [];
				var outPercs = [];
				entryPercs.resize(node.input.length);

				for (i in 0...entryPercs.length)
					entryPercs[i] = getPercent(node.input[i], player);

				outPercs = node.func(entryPercs, player);

				final nbl = node.output.length;
				if (outPercs == null || outPercs.length < 0)
					outPercs = [];

				for (i in 0...nbl) {
					final prc = outPercs[i];

					if (!Math.isNaN(prc) && prc != 0)
						setPercent(node.output[i], prc, player);
				}
			} while (h());
		}
	}

	override function update(elapsed:Float):Void {
		// Update Event Timeline
		events.update(Adapter.instance.getCurrentBeat());

		updateNodes();

		super.update(elapsed);
	}

	override public function draw() {
		__drawPlayField();
		modifiers.postRender();
	}

	override public function destroy() {
		arrowRenderer.dispose();
		holdRenderer.dispose();
		receptorRenderer.dispose();
		attachmentRenderer.dispose();
		pathRenderer.dispose();
		super.destroy();
	}

	var drawCB:Array<{callback:Void->Void, z:Float}> = [];

	private function getVisibility(obj:flixel.FlxObject) {
		@:bypassAccessor obj.visible = false;
		return obj._fmVisible;
	}

	private function __drawPlayField() {
		drawCB = [];

		// TODO: prepare arrow paths shit
		var pathAlphaTotal = .0;

		var playerItems:Array<Array<Array<FlxSprite>>> = Adapter.instance.getArrowItems();

		// used for preallocate
		var receptorLength = 0;
		var arrowLength = 0;
		var holdLength = 0;
		var attachmentLength = 0;

		for (i in 0...playerItems.length) {
			final curItems = playerItems[i];

			if (curItems[0] != null)
				receptorLength = receptorLength + curItems[0].length;
			if (curItems[1] != null)
				arrowLength = arrowLength + curItems[1].length;
			if (curItems[2] != null)
				holdLength = holdLength + curItems[2].length;
			if (curItems[3] != null)
				attachmentLength = attachmentLength + curItems[3].length;
			// curItems[4] (sustain splashes) no se procesan aquí
		}

		if (receptorLength != 0)
			receptorRenderer.preallocate(receptorLength);
		if (arrowLength != 0)
			arrowRenderer.preallocate(arrowLength);
		if (holdLength != 0)
			holdRenderer.preallocate(holdLength);
		if (attachmentLength != 0)
			attachmentRenderer.preallocate(attachmentLength);

		if (Config.RENDER_ARROW_PATHS)
			pathRenderer.preallocate(receptorLength);

		drawCB.resize(receptorLength + arrowLength + holdLength + attachmentLength);

		var j = 0;
		inline function queue(f:{callback:Void->Void, z:Float}) {
			drawCB[j] = f;
			j++;
		}

		// i is player index
		for (i in 0...playerItems.length) {
			var curItems:Array<Array<FlxSprite>> = playerItems[i];

			if (curItems == null || curItems.length == 0)
				continue;

			final drawHolds = () -> {
				if (holdLength > 0) {
					for (hold in curItems[2]) {
						if (!getVisibility(hold))
							continue;

						holdRenderer.prepare(hold);
						queue({
							callback: holdRenderer.shift,
							z: hold._z
						});
					}
				}
			};

			// holds (behind strums)
			if (Config.HOLDS_BEHIND_STRUM)
				drawHolds();

			// receptors
			if (receptorLength > 0) {
				for (receptor in curItems[0]) {
					if (!getVisibility(receptor))
						continue;

					receptorRenderer.prepare(receptor);
					if (Config.RENDER_ARROW_PATHS)
						pathRenderer.prepare(receptor);
					queue({
						callback: receptorRenderer.shift,
						z: receptor._z
					});
				}
			}

			// holds (infront of strums)
			if (!Config.HOLDS_BEHIND_STRUM)
				drawHolds();

			// tap arrow
			if (arrowLength > 0) {
				for (arrow in curItems[1]) {
					if (!getVisibility(arrow))
						continue;

					arrowRenderer.prepare(arrow);
					queue({
						callback: arrowRenderer.shift,
						z: arrow._z
					});
				}
			}

			// attachments (splashes)
			if (attachmentLength > 0) {
				for (attachment in curItems[3]) {
					if (!getVisibility(attachment))
						continue;

					attachmentRenderer.prepare(attachment);
					queue({
						callback: attachmentRenderer.shift,
						z: attachment._z
					});
				}
			}
			
			// curItems[4] (sustain splashes) se omite intencionalmente
			// Los sustain splashes se renderizan directamente por PlayState sin transformaciones de modchart
		}

		for (r in [receptorRenderer, arrowRenderer, holdRenderer, attachmentRenderer])
			r.sort();

		if (Config.RENDER_ARROW_PATHS)
			pathRenderer.shift();
	}
}
