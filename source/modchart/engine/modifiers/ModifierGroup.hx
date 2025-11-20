package modchart.engine.modifiers;

import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import haxe.ds.Vector;
import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierOutput;
import modchart.backend.core.ModifierParameters;
import modchart.backend.core.PercentArray;
import modchart.backend.core.VisualParameters;
import modchart.backend.macros.ModifiersMacro;
import modchart.backend.util.ModchartUtil;
import modchart.engine.modifiers.Modifier;
import modchart.engine.modifiers.list.*;
import modchart.engine.modifiers.list.false_paradise.*;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:allow(modchart.engine.Modifier)
final class ModifierGroup {
	/**
	 * A `List` containing all compiled `Modifier` classes.
	 *
	 * This list is generated at compile time using `ModifiersMacro.get()`.
	 * It provides a collection of all available modifiers for use in the system.
	 */
	public static final COMPILED_MODIFIERS = ModifiersMacro.get();

	/**
	 * A 2D array storing percentage values, indexed by hashed string keys.
	 *
	 * **Usage Notes:**
	 * - Do not access `percents` directly, as all keys are hashed into 16-bit integers.
	 * - Use `getPercent(name, player)` to retrieve a value.
	 * - Use `setPercent(name, value, player)` to modify values safely.
	 *
	 * **Hashing Mechanism:**
	 * - Keys are automatically converted to lowercase and hashed into a 16-bit integer.
	 * - This ensures efficient storage and retrieval while avoiding direct string key lookups.
	 */
	public var percents(default, never):PercentArray = new PercentArray();

	/**
	 * A `StringMap` that maps modifier names/identifiers to their corresponding `Modifier` class.
	 * **Note**: This is not actually used internally-
	 */
	public var modifiers(default, never):StringMap<Modifier> = new StringMap();

	/**
	 * The current `PlayField` instance.
	 *
	 * When set, all stored modifiers are updated to reference the new `PlayField` instance.
	 */
	public var playfield(default, set):PlayField;

	public function set_playfield(newPlayfield:PlayField) {
		for (i in 0...__modifierCount) {
			@:privateAccess __sortedModifiers[i].pf = newPlayfield;
		}
		return playfield = newPlayfield;
	}

	@:noCompletion private var __modifierRegistrery:StringMap<Class<Modifier>> = new StringMap();

	@:noCompletion private var __sortedModifiers:Vector<Modifier> = new Vector<Modifier>(32);
	@:noCompletion private var __modifierCount:Int = 0;
	@:noCompletion private var __sortedIDs:Vector<String> = new Vector<String>(32);
	@:noCompletion private var __idCount:Int = 0;

	inline private function __loadModifiers() {
		for (cls in COMPILED_MODIFIERS) {
			var name = Type.getClassName(cls);
			name = name.substring(name.lastIndexOf('.') + 1, name.length);
			__modifierRegistrery.set(name.toLowerCase(), cast cls);
		}
	}

	public function new(playfield:PlayField) {
		this.playfield = playfield;

		__loadModifiers();
	}

	public inline function postRender() {}

	/**
	 * Computes the transformed position and visual properties of an arrow based on active modifiers.
	 *
	 * @param pos The initial `Vector3` position of the arrow.
	 * @param data The `ArrowData` containing arrow properties such as lane, player, and timing.
	 * @param posDiff (Optional) A positional offset applied to the arrow.
	 * @param allowVis (Optional) If `true`, visual modifications will be applied.
	 * @param allowPos (Optional) If `true`, positional transformations will be applied.
	 * @return A `ModifierOutput` structure containing the modified position and visuals.
	 *
	 * **Processing Steps:**
	 * - Retrieves the current song position and beat.
	 * - Iterates through all active modifiers, applying transformations if conditions are met.
	 * - Adjusts the `z` position based on `Config.Z_SCALE` and projects the final position.
	 * - (Caching is currently disabled but could be re-enabled for optimization.)
	 */
	public inline function getPath(pos:Vector3, data:ArrowData, ?posDiff:Float = 0, ?allowVis:Bool = true, ?allowPos:Bool = true):ModifierOutput {
		var visuals:VisualParameters = {};

		if (!allowVis && !allowPos)
			return {pos: pos, visuals: visuals};

		final songPos = Adapter.instance.getSongPosition();
		final beat = Adapter.instance.getCurrentBeat();

		final args:ModifierParameters = {
			songTime: songPos,
			curBeat: beat,
			hitTime: data.hitTime + posDiff,
			distance: data.distance + posDiff,
			lane: data.lane,
			player: data.player,
			isTapArrow: data.isTapArrow
		}

		// sorta optimizations
		final mods = __sortedModifiers;
		final len = __modifierCount;

		for (i in 0...len) {
			final mod = mods[i];

			if (!mod.shouldRun(args))
				continue;

			if (allowPos)
				pos = mod.render(pos, args);
			if (allowVis)
				visuals = mod.visuals(visuals, args);
		}
		pos.z *= 0.001 * Config.Z_SCALE;
		pos = playfield.projection.transformVector(pos);
		final output:ModifierOutput = {
			pos: pos,
			visuals: visuals
		};

		return output;
	}

	public inline function addScriptedModifier(name:String, instance:Modifier)
		__addModifier(name, instance);

	public inline function addModifier(name:String) {
		var lowerName = name.toLowerCase();
		if (modifiers.exists(lowerName))
			return;

		var modifierClass:Null<Class<Modifier>> = __modifierRegistrery.get(lowerName);
		if (modifierClass == null) {
			trace('$name modifier was not found !');

			return;
		}
		var newModifier = Type.createInstance(modifierClass, [playfield]);
		__addModifier(lowerName, newModifier);
	}

	public inline function setPercent(name:String, value:Float, player:Int = -1) {
		final key = name.toLowerCase();

		final possiblePercs = percents.get(key);
		final generate = possiblePercs == null;
		final percs = generate ? __getPercentTemplate() : possiblePercs;

		if (player == -1)
			for (_ in 0...percs.length)
				percs[_] = value;
		else
			percs[player] = value;

		// if the percent list already was generated, we dont need to set it again
		if (generate)
			percents.set(key, percs);
	}

	public inline function getPercent(name:String, player:Int):Float {
		final percs = percents.get(name.toLowerCase());

		if (percs != null)
			return percs[player];
		return 0;
	}

	inline private function __getUnsafe(id:Int, player:Int) {
		final percs = percents.getUnsafe(id);

		if (percs != null)
			return percs[player];
		return 0;
	}

	inline private function __setUnsafe(id:Int, value:Float, player:Int = -1) {
		var possiblePercs = percents.getUnsafe(id);
		var generate = possiblePercs == null;
		var percs = generate ? __getPercentTemplate() : possiblePercs;

		if (player == -1)
			for (_ in 0...percs.length)
				percs[_] = value;
		else
			percs[player] = value;

		if (generate)
			percents.setUnsafe(id, percs);
	}

	@:noCompletion
	inline private function __addModifier(name:String, modifier:Modifier) {
		modifiers.set(name, modifier);
		@:privateAccess modifier.pf = playfield;

		// update modifier identificators
		if (__idCount > (__sortedIDs.length - 1)) {
			final oldIDs = __sortedIDs.copy();
			__sortedIDs = new Vector<String>(oldIDs.length + 8);

			for (i in 0...oldIDs.length)
				__sortedIDs[i] = oldIDs[i];
		}
		__sortedIDs[__idCount++] = name;

		// update modifier list
		if (__modifierCount > (__sortedModifiers.length - 1)) {
			final oldMods = __sortedModifiers.copy();
			__sortedModifiers = new Vector<Modifier>(oldMods.length + 8);

			for (i in 0...oldMods.length)
				__sortedModifiers[i] = oldMods[i];
		}
		__sortedModifiers[__modifierCount++] = modifier;
	}

	@:noCompletion
	inline private function __getPercentTemplate():Vector<Float> {
		final vector = new Vector<Float>(Adapter.instance.getPlayerCount());
		for (i in 0...vector.length)
			vector[i] = 0;
		return vector;
	}

	inline private function __findID(str:String) {
		@:privateAccess percents.__hashKey(str.toLowerCase());
	}
}
