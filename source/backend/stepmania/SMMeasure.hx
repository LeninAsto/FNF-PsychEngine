package backend.stepmania;

/**
 * Representa una medida (measure) en un archivo .sm
 * Una medida contiene múltiples filas de notas
 */
class SMMeasure {
	public var noteRows:Array<String> = [];
	
	public function new(rows:Array<String>) {
		// Filtrar líneas vacías y comentarios
		for (row in rows) {
			var trimmed = row.trim();
			if (trimmed.length > 0 && !trimmed.startsWith('//')) {
				noteRows.push(trimmed);
			}
		}
	}
	
	/**
	 * Obtiene el número de subdivisiones en esta medida
	 * Más subdivisiones = notas más rápidas/precisas
	 */
	public function getSubdivisions():Int {
		return noteRows.length;
	}
	
	/**
	 * Verifica si la medida contiene alguna nota
	 */
	public function hasNotes():Bool {
		for (row in noteRows) {
			for (i in 0...row.length) {
				var char = row.charAt(i);
				if (char != '0' && char != 'M') {
					return true;
				}
			}
		}
		return false;
	}
}
