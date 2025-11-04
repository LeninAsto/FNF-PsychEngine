package backend.stepmania;

import backend.stepmania.SMFile.TimingStruct;

/**
 * Parser para el header de archivos .sm
 * Extrae metadatos como título, artista, BPM, etc.
 */
class SMHeader {
	public var TITLE:String = "";
	public var SUBTITLE:String = "";
	public var ARTIST:String = "";
	public var GENRE:String = "";
	public var CREDIT:String = "";
	public var MUSIC:String = "";
	public var BANNER:String = "";
	public var BACKGROUND:String = "";
	public var OFFSET:String = "0";
	public var BPMS:String = "0=120"; // formato: beat=bpm,beat=bpm
	
	public var bpmChanges:Array<BPMChange> = [];
	
	private var headerData:String;
	
	public function new(data:String) {
		headerData = data;
		parseHeader();
	}
	
	function parseHeader():Void {
		// Dividir por líneas y procesar cada una
		var lines = headerData.split('\n');
		
		for (line in lines) {
			line = line.trim();
			if (line.length == 0 || line.startsWith('//')) continue;
			
			// Formato: #TAG:value;
			if (line.startsWith('#')) {
				var parts = line.substring(1).split(':');
				if (parts.length < 2) continue;
				
				var tag = parts[0].toUpperCase();
				var value = parts.slice(1).join(':').split(';')[0].trim();
				
				// Limpiar caracteres problemáticos
				value = StringTools.replace(value, '\r', '');
				value = StringTools.replace(value, '\n', ' ');
				value = StringTools.trim(value);
				
				switch (tag) {
					case 'TITLE': TITLE = value;
					case 'SUBTITLE': SUBTITLE = value;
					case 'ARTIST': ARTIST = value;
					case 'GENRE': GENRE = value;
					case 'CREDIT': CREDIT = value;
					case 'MUSIC': MUSIC = value;
					case 'BANNER': BANNER = value;
					case 'BACKGROUND': BACKGROUND = value;
					case 'OFFSET': OFFSET = value;
					case 'BPMS': BPMS = value;
				}
			}
		}
		
		// Parsear cambios de BPM
		parseBPMChanges();
	}
	
	function parseBPMChanges():Void {
		bpmChanges = [];
		
		var bpmPairs = BPMS.split(',');
		var currentTime:Float = -Std.parseFloat(OFFSET); // Offset negativo
		
		for (i in 0...bpmPairs.length) {
			var pair = bpmPairs[i].trim();
			if (pair.length == 0) continue;
			
			var parts = pair.split('=');
			if (parts.length != 2) continue;
			
			var beat = Std.parseFloat(parts[0]);
			var bpm = Std.parseFloat(parts[1]);
			
			// Calcular el tiempo en segundos
			if (i > 0) {
				var prevChange = bpmChanges[i - 1];
				var beatDiff = beat - prevChange.beat;
				var timeDiff = (beatDiff / prevChange.bpm) * 60;
				currentTime = prevChange.time + timeDiff;
			}
			
			bpmChanges.push({
				beat: beat,
				bpm: bpm,
				time: currentTime
			});
			
			// Inicializar timings
			if (i == 0) {
				TimingStruct.clearTimings();
			}
			
			var endBeat = (i < bpmPairs.length - 1) ? 
				Std.parseFloat(bpmPairs[i + 1].split('=')[0]) : 
				Math.POSITIVE_INFINITY;
				
			TimingStruct.addTiming(beat, bpm, endBeat, currentTime);
		}
	}
	
	/**
	 * Obtiene el BPM en un beat específico
	 */
	public function getBPM(beat:Float):Float {
		if (bpmChanges.length == 0) return 120;
		
		var currentBPM = bpmChanges[0].bpm;
		for (change in bpmChanges) {
			if (beat >= change.beat) {
				currentBPM = change.bpm;
			} else {
				break;
			}
		}
		return currentBPM;
	}
	
	/**
	 * Obtiene el beat donde ocurre un cambio de BPM específico por índice
	 */
	public function getBeatFromBPMIndex(index:Int):Float {
		if (index < 0 || index >= bpmChanges.length) return 0;
		return bpmChanges[index].beat;
	}
}

typedef BPMChange = {
	var beat:Float;
	var bpm:Float;
	var time:Float;
}
