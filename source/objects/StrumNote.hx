package objects;

import backend.animation.PsychAnimationController;
import backend.ExtraKeysHandler;

import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;

class StrumNote extends FlxSprite
{
	public var rgbShader:RGBShaderReference;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 90;
	public var downScroll:Bool = false;
	public var sustainReduce:Bool = true;
	private var player:Int;
	
	public var texture(default, set):String = null;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	public var useRGBShader:Bool = true;
	public function new(x:Float, y:Float, leData:Int, player:Int) {
		animation = new PsychAnimationController(this);

		rgbShader = new RGBShaderReference(this, Note.initializeGlobalRGBShader(leData));
		rgbShader.enabled = false;
		if(PlayState.SONG != null && PlayState.SONG.disableNoteRGB) useRGBShader = false;
		
		var arr:Array<FlxColor> = null;
		
		// Manejar Extra Keys - obtener colores apropiados
		if (leData < 4) {
			// Usar colores estándar para las primeras 4 teclas
			arr = ClientPrefs.data.arrowRGB[leData];
			if(PlayState.isPixelStage) arr = ClientPrefs.data.arrowRGBPixel[leData];
		} else {
			// Para Extra Keys, usar colores del ExtraKeysHandler o colores por defecto
			if (ExtraKeysHandler.instance != null && ExtraKeysHandler.instance.data != null) {
				var numKeys = (PlayState.SONG != null && PlayState.SONG.mania != null) ? PlayState.SONG.mania : 4;
				var index = ExtraKeysHandler.instance.getIndex(numKeys, leData);
				if (index < ExtraKeysHandler.instance.data.colors.length) {
					// Crear array de colores desde ExtraKeysHandler
					var colorData = ExtraKeysHandler.instance.data.colors[index];
					arr = [
						FlxColor.fromString('#' + colorData.inner),
						FlxColor.fromString('#' + colorData.border), 
						FlxColor.fromString('#' + colorData.outline)
					];
				}
			}
			
			// Fallback: usar colores por defecto si no se encontraron
			if (arr == null) {
				arr = [FlxColor.PURPLE, FlxColor.WHITE, FlxColor.BLACK]; // Colores por defecto
			}
		}
		
		if(arr != null && leData < arr.length)
		{
			@:bypassAccessor
			{
				rgbShader.r = arr[0];
				rgbShader.g = arr[1];
				rgbShader.b = arr[2];
			}
		}

		noteData = leData;
		this.player = player;
		this.noteData = leData;
		this.ID = noteData;
		super(x, y);

		var skin:String = null;
		if(PlayState.SONG != null && PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) skin = PlayState.SONG.arrowSkin;
		else skin = Note.defaultNoteSkin;

		var customSkin:String = skin + Note.getNoteSkinPostfix();
		if(Paths.fileExists('images/$customSkin.png', IMAGE)) skin = customSkin;

		texture = skin; //Load texture and anims
		scrollFactor.set();
		playAnim('static');
	}

	public function reloadNote()
	{
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		if(PlayState.isPixelStage)
		{
			loadGraphic(Paths.image('pixelUI/' + texture));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('pixelUI/' + texture), true, Math.floor(width), Math.floor(height));

			antialiasing = false;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));

			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);
			
			// Obtener animaciones para Extra Keys
			var animIndex = noteData;
			if (ExtraKeysHandler.instance != null && ExtraKeysHandler.instance.data != null) {
				var numKeys = (PlayState.SONG != null && PlayState.SONG.mania != null) ? PlayState.SONG.mania : 4;
				animIndex = ExtraKeysHandler.instance.getIndex(numKeys, noteData);
			}
			
			// Mapear a animaciones estándar si no hay suficientes frames
			var mappedIndex = animIndex % 4;
			
			switch (mappedIndex)
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}
		}
		else
		{
			frames = Paths.getSparrowAtlas(texture);
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			antialiasing = ClientPrefs.data.antialiasing;
			setGraphicSize(Std.int(width * 0.7));

			// Obtener animaciones para Extra Keys
			var animData = null;
			if (ExtraKeysHandler.instance != null && ExtraKeysHandler.instance.data != null) {
				var numKeys = (PlayState.SONG != null && PlayState.SONG.mania != null) ? PlayState.SONG.mania : 4;
				var index = ExtraKeysHandler.instance.getIndex(numKeys, noteData);
				animData = ExtraKeysHandler.instance.getAnimSet(index);
			}
			
			// Usar datos de Extra Keys o fallback al sistema clásico
			if (animData != null) {
				// Usar animaciones específicas de Extra Keys
				animation.addByPrefix('static', 'arrow' + animData.strum);
				animation.addByPrefix('pressed', animData.anim + ' press', 24, false);
				animation.addByPrefix('confirm', animData.anim + ' confirm', 24, false);
			} else {
				// Fallback al sistema clásico 4K
				switch (noteData % 4)
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			}
		}
		updateHitbox();

		if(lastAnim != null)
		{
			playAnim(lastAnim, true);
		}
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		if(animation.curAnim != null)
		{
			centerOffsets();
			centerOrigin();
		}
		if(useRGBShader) rgbShader.enabled = (animation.curAnim != null && animation.curAnim.name != 'static');
	}

	// Función para posicionar el strum según la mania
	public function playerPosition() {
		if (PlayState.SONG == null) return;
		
		var numKeys = (PlayState.SONG.mania != null) ? PlayState.SONG.mania : 4;
		var keyCount = numKeys;
		
		// Obtener escala basándose en la mania
		var scale = 1.0;
		if (ExtraKeysHandler.instance != null && ExtraKeysHandler.instance.data != null) {
			var maniaIndex = ExtraKeysHandler.instance.keysToIndex(numKeys);
			if (PlayState.isPixelStage && ExtraKeysHandler.instance.data.pixelScales != null && 
				maniaIndex < ExtraKeysHandler.instance.data.pixelScales.length) {
				scale = ExtraKeysHandler.instance.data.pixelScales[maniaIndex];
			} else if (!PlayState.isPixelStage && ExtraKeysHandler.instance.data.scales != null && 
				maniaIndex < ExtraKeysHandler.instance.data.scales.length) {
				scale = ExtraKeysHandler.instance.data.scales[maniaIndex];
			}
		}
		
		// Aplicar escala
		setGraphicSize(Std.int(width * scale));
		updateHitbox();
		
		// Configuración de posicionamiento
		var strumWidth = width;
		var separation = strumWidth * 1.0; // Separación entre strums
		var totalWidth = keyCount * separation;
		
		// Posicionamiento basándose en el engine original
		if (player == 1) {
			// Player strums
			if (ClientPrefs.data.middleScroll) {
				// Middle scroll: centrado
				var startX = (FlxG.width - totalWidth) / 2;
				x = startX + (noteData * separation);
			} else {
				// Normal positioning: lado derecho
				x = FlxG.width * 0.75 + (noteData * separation) - (totalWidth / 2);
			}
		} else {
			// Opponent strums
			if (ClientPrefs.data.middleScroll) {
				// Middle scroll: lados
				var baseX = FlxG.width * 0.25;
				if (noteData < Math.floor(keyCount / 2)) {
					// Lado izquierdo
					x = baseX - ((Math.floor(keyCount / 2) - noteData) * separation);
				} else {
					// Lado derecho
					x = FlxG.width * 0.75 + ((noteData - Math.floor(keyCount / 2)) * separation);
				}
			} else {
				// Normal positioning: lado izquierdo
				x = FlxG.width * 0.25 + (noteData * separation) - (totalWidth / 2);
			}
		}
	}
}
