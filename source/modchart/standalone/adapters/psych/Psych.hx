package modchart.standalone.adapters.psych;

#if (FM_ENGINE_VERSION == "1.0" || FM_ENGINE_VERSION == "0.7")
import backend.ClientPrefs;
import backend.Conductor;
import objects.Note;
import objects.NoteSplash;
import objects.SustainSplash;
import objects.StrumNote as Strum;
import states.PlayState;
#else
import ClientPrefs;
import Conductor;
import Note;
import PlayState;
import StrumNote as Strum;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import modchart.Manager;
import modchart.standalone.IAdapter;

class Psych implements IAdapter {
	private var __fCrochet:Float = 0;

	public function new() {
		try {
			setupLuaFunctions();
		} catch (e) {
			trace('[ From FunkinModchart Adapter ] Failed while adding lua functions: $e');
		}
	}

	public function onModchartingInitialization() {
		__fCrochet = Conductor.crochet;
	}

	private function setupLuaFunctions() {
		#if LUA_ALLOWED
		// todo
		#end
	}

	public function isTapNote(sprite:FlxSprite) {
		return sprite is Note;
	}

	// Song related
	public function getSongPosition():Float {
		return Conductor.songPosition;
	}

	public function getCurrentBeat():Float {
		@:privateAccess
		return PlayState.instance.curDecBeat;
	}

	public function getStaticCrochet():Float {
		return __fCrochet + 8;
	}

	public function getBeatFromStep(step:Float)
		return step * .25;

	public function arrowHit(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).wasGoodHit;
		return false;
	}

	public function isHoldEnd(arrow:FlxSprite) {
		if (arrow is Note) {
			final castedNote = cast(arrow, Note);

			if (castedNote.nextNote != null)
				return !castedNote.nextNote.isSustainNote;
		}
		return false;
	}

	public function getLaneFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).noteData;
		else if (arrow is Strum) @:privateAccess
			return cast(arrow, Strum).noteData;
		#if (FM_ENGINE_VERSION >= "1.0")
		if (arrow is NoteSplash) @:privateAccess
			return cast(arrow, NoteSplash).babyArrow.noteData;
		#end
		if (arrow is SustainSplash) @:privateAccess
			return cast(arrow, SustainSplash).strumNote.noteData;

		return 0;
	}

	public function getPlayerFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).mustPress ? 1 : 0;
		if (arrow is Strum) @:privateAccess
			return cast(arrow, Strum).player;
		#if (FM_ENGINE_VERSION >= "1.0")
		if (arrow is NoteSplash) @:privateAccess
			return cast(arrow, NoteSplash).babyArrow.player;
		#end
		if (arrow is SustainSplash) @:privateAccess
			return cast(arrow, SustainSplash).strumNote.player;
		return 0;
	}

	public function getKeyCount(?player:Int = 0):Int {
		return 4;
	}

	public function getPlayerCount():Int {
		return 2;
	}

	public function getTimeFromArrow(arrow:FlxSprite) {
		if (arrow is Note)
			return cast(arrow, Note).strumTime;

		return 0;
	}

	public function getHoldSubdivisions():Int {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.holdSubdivisions;
		#else
		return ClientPrefs.holdSubdivisions;
		#end
	}

	public function getHoldParentTime(arrow:FlxSprite) {
		final note:Note = cast arrow;
		return note.parent.strumTime;
	}

	public function getDownscroll():Bool {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.downScroll;
		#else
		return ClientPrefs.downScroll;
		#end
	}

	public function isModchartingEnabled():Bool {
		// Return true to enable modcharting by default
		// You can add a ClientPrefs option later if needed
		return true;
	}

	inline function getStrumFromInfo(lane:Int, player:Int) {
		var group = player == 0 ? PlayState.instance.opponentStrums : PlayState.instance.playerStrums;
		
		// Validar que el lane esté dentro del rango del mania actual
		if (lane < 0 || lane >= group.length) {
			trace('[Modchart] Warning: Lane $lane is out of range for current mania (${group.length} keys)');
			return null;
		}
		
		var strum = null;
		group.forEach(str -> {
			@:privateAccess
			if (str.noteData == lane)
				strum = str;
		});
		return strum;
	}

	public function getDefaultReceptorX(lane:Int, player:Int):Float {
		var strum = getStrumFromInfo(lane, player);
		if (strum == null) return 0.0; // Retornar valor por defecto si el strum no existe
		return strum.x;
	}

	public function getDefaultReceptorY(lane:Int, player:Int):Float {
		var strum = getStrumFromInfo(lane, player);
		if (strum == null) return 0.0; // Retornar valor por defecto si el strum no existe
		
		// El strum ya tiene la posición Y correcta según su propiedad downScroll
		// No necesitamos convertir la posición, solo retornarla directamente
		return strum.y;
	}

	public function getArrowCamera():Array<FlxCamera>
		return [PlayState.instance.camHUD];

	public function getCurrentScrollSpeed():Float {
		return PlayState.instance.songSpeed;
	}

	// 0 receptors
	// 1 tap arrows
	// 2 hold arrows
	public function getArrowItems() {
		// Obtener el mania actual dinámicamente
		var mania:Int = PlayState.SONG.mania;
		
		// Crear arrays dinámicamente basados en el mania
		// pspr[player][type][lane] donde:
		// - player: 0 = opponent, 1 = player
		// - type: 0 = receptors, 1 = tap notes, 2 = hold notes, 3 = splashes
		var pspr:Array<Array<Array<FlxSprite>>> = [];
		
		// Inicializar arrays para cada player
		for (p in 0...2) {
			pspr[p] = [];
			for (t in 0...4) {
				pspr[p][t] = []; // Arrays vacíos, no pre-llenados con null
			}
		}

		@:privateAccess
		PlayState.instance.strumLineNotes.forEachAlive(strumNote -> {
			var player = strumNote.player;
			var noteData = strumNote.noteData;
			
			// Validar que el noteData esté dentro del rango del mania
			if (noteData >= 0 && noteData < mania) {
				if (pspr[player] == null)
					pspr[player] = [];
				if (pspr[player][0] == null)
					pspr[player][0] = [];

				pspr[player][0].push(strumNote);
			}
		});
		
		PlayState.instance.notes.forEachAlive(note -> {
			final player = Adapter.instance.getPlayerFromArrow(note);
			var noteData = note.noteData;
			
			// Validar que el noteData esté dentro del rango del mania
			if (noteData >= 0 && noteData < mania) {
				if (pspr[player] == null)
					pspr[player] = [];

				pspr[player][note.isSustainNote ? 2 : 1].push(note);
			}
		});
		
		#if (FM_ENGINE_VERSION >= "1.0")
		PlayState.instance.grpNoteSplashes.forEachAlive(splash -> {
			@:privateAccess
			if (splash.babyArrow != null && splash.active) {
				final player = splash.babyArrow.player;
				var noteData = splash.babyArrow.noteData;
				
				// Validar que el noteData esté dentro del rango del mania
				if (noteData >= 0 && noteData < mania) {
					if (pspr[player] == null)
						pspr[player] = [];

					pspr[player][3].push(splash);
				}
			}
		});
		#end
		
		// Add support for SustainSplash (grpHoldSplashes)
		PlayState.instance.grpHoldSplashes.forEachAlive(splash -> {
			@:privateAccess
			if (splash.strumNote != null && splash.active) {
				final player = splash.strumNote.player;
				var noteData = splash.strumNote.noteData;
				
				// Validar que el noteData esté dentro del rango del mania
				if (noteData >= 0 && noteData < mania) {
					if (pspr[player] == null)
						pspr[player] = [];

					pspr[player][3].push(splash);
				}
			}
		});

		return pspr;
	}
}
