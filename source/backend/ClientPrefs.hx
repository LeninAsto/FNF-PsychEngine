package backend;

import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;
import backend.ExtraKeysHandler;

import states.TitleState;

// Add a variable here and it will get automatically saved
@:structInit class SaveVariables {
	// Mobile and Mobile Controls Releated
	public var extraButtons:String = "NONE"; // mobile extra button option
	public var hitboxPos:Bool = true; // hitbox extra button position option
	public var dynamicColors:Bool = true; // yes cause its cool -Karim
	public var controlsAlpha:Float = FlxG.onMobile ? 0.6 : 0;
	public var screensaver:Bool = false;
	public var wideScreen:Bool = false;
	public var hitboxType:String = "Gradient";
	public var popUpRating:Bool = true;
	public var vsync:Bool = false;
	public var gameOverVibration:Bool = false;
	public var fpsRework:Bool = false;
	
	// ✅ Mod con permiso para ejecutar custom states
	// Si es "NONE" o null, no se ejecutarán custom states de ningún mod
	// Solo el mod especificado aquí podrá ejecutar sus custom states
	public var activeModState:String = "NONE";
	
	public var downScroll:Bool = false;
	public var middleScroll:Bool = false;
	public var opponentStrums:Bool = true;
	public var showFPS:Bool = true;
	public var flashing:Bool = true;
	public var autoPause:Bool = true;
	public var antialiasing:Bool = true;
	public var noteSkin:String = 'Default';
	public var splashSkin:String = 'Psych';
	public var splashAlpha:Float = 0.6;
	public var lowQuality:Bool = false;
	public var shaders:Bool = true;
	public var cacheOnGPU:Bool = #if !switch false #else true #end; // GPU Caching made by Raltyro
	public var framerate:Int = 60;
	public var camZooms:Bool = true;
	public var hideHud:Bool = false;
	public var showKeyViewer:Bool = false;
	public var judgementCounter:Bool = true;
	public var comboInGame:Bool = false;
	public var useFreakyFont:Bool = false;
	public var showStateInFPS:Bool = true;
	public var showEndCountdown:Bool = false; // Activa/desactiva la cuenta regresiva
    public var endCountdownSeconds:Int = 10;  // Segundos de cuenta regresiva (10-30)
	public var enableModcharting:Bool = false; // Habilita/deshabilita el sistema de modcharting
	public var holdSubdivisions:Int = 4; // Subdivisiones para las notas hold (1-32)
	public var debugData:Bool = false;
	public var noteOffset:Int = 0;
	public var arrowRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]];
	public var arrowRGBPixel:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]];

	public var ghostTapping:Bool = true;
	public var timeBarType:String = 'Time Left';
	public var scoreZoom:Bool = true;
	public var noReset:Bool = false;
	public var healthBarAlpha:Float = 1;
	public var hitsoundVolume:Float = 0;
	public var pauseMusic:String = 'Tea Time';
	public var checkForUpdates:Bool = true;
	public var comboStacking:Bool = true;
	public var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		// -kade
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public var comboOffset:Array<Int> = [0, 0, 0, 0];
	public var keyViewerOffset:Array<Int> = [0, 0]; // X, Y offset for key viewer
	public var keyViewerColor:String = 'Gray'; // Color name for key viewer
	public var ratingOffset:Int = 0;
	public var epicWindow:Float = 20.0;
	public var sickWindow:Float = 45.0;
	public var goodWindow:Float = 90.0;
	public var badWindow:Float = 135.0;
	public var safeFrames:Float = 10.0;
	public var guitarHeroSustains:Bool = true;
	public var discordRPC:Bool = true;
	public var loadingScreen:Bool = true;
	public var language:String = 'en-US';
	public var abbreviateScore:Bool = true;
}

class ClientPrefs {
	public static var data:SaveVariables = {};
	public static var defaultData:SaveVariables = {};
	public static var judgementCounter:Bool = true;
	

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		// 1K
		'note_one1'		=> [SPACE, NONE],

		// 2K  
		'note_two1'		=> [D, NONE],
		'note_two2'		=> [K, NONE],

		// 3K
		'note_three1'	=> [D, NONE],
		'note_three2'	=> [SPACE, NONE],
		'note_three3'	=> [K, NONE],

		// 4K (Default)
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],

		// 5K
		'note_five1'	=> [D, NONE],
		'note_five2'	=> [F, NONE],
		'note_five3'	=> [SPACE, NONE],
		'note_five4'	=> [J, NONE],
		'note_five5'	=> [K, NONE],

		// 6K
		'note_six1'		=> [S, NONE],
		'note_six2'		=> [D, NONE],
		'note_six3'		=> [F, NONE],
		'note_six4'		=> [J, NONE],
		'note_six5'		=> [K, NONE],
		'note_six6'		=> [L, NONE],

		// 7K
		'note_seven1'	=> [S, NONE],
		'note_seven2'	=> [D, NONE],
		'note_seven3'	=> [F, NONE],
		'note_seven4'	=> [SPACE, NONE],
		'note_seven5'	=> [J, NONE],
		'note_seven6'	=> [K, NONE],
		'note_seven7'	=> [L, NONE],

		// 8K
		'note_eight1'	=> [A, NONE],
		'note_eight2'	=> [S, NONE],
		'note_eight3'	=> [D, NONE],
		'note_eight4'	=> [F, NONE],
		'note_eight5'	=> [H, NONE],
		'note_eight6'	=> [J, NONE],
		'note_eight7'	=> [K, NONE],
		'note_eight8'	=> [L, NONE],

		// 9K
		'note_nine1'	=> [A, NONE],
		'note_nine2'	=> [S, NONE],
		'note_nine3'	=> [D, NONE],
		'note_nine4'	=> [F, NONE],
		'note_nine5'	=> [SPACE, NONE],
		'note_nine6'	=> [H, NONE],
		'note_nine7'	=> [J, NONE],
		'note_nine8'	=> [K, NONE],
		'note_nine9'	=> [L, NONE],

		// 10K
		'note_ten1'		=> [A, NONE],
		'note_ten2'		=> [S, NONE],
		'note_ten3'		=> [D, NONE],
		'note_ten4'		=> [F, NONE],
		'note_ten5'		=> [G, NONE],
		'note_ten6'		=> [SPACE, NONE],
		'note_ten7'		=> [H, NONE],
		'note_ten8'     => [J, NONE],
		'note_ten9'		=> [K, NONE],
		'note_ten10'	=> [L, NONE],

		// 11K
		'note_elev1'	=> [A, NONE],
		'note_elev2'	=> [S, NONE],
		'note_elev3'	=> [D, NONE],
		'note_elev4'	=> [F, NONE],
		'note_elev5'	=> [G, NONE],
		'note_elev6'	=> [SPACE, NONE],
		'note_elev7'	=> [H, NONE],
		'note_elev8'    => [J, NONE],
		'note_elev9'	=> [K, NONE],
		'note_elev10'	=> [L, NONE],
		'note_elev11'	=> [PERIOD, NONE],

		// 12K
		'note_twelve1'	=> [Q, NONE],
		'note_twelve2'	=> [W, NONE],
		'note_twelve3'	=> [E, NONE],
		'note_twelve4'	=> [R, NONE],
		'note_twelve5'	=> [T, NONE],
		'note_twelve6'	=> [Y, NONE],
		'note_twelve7'	=> [U, NONE],
		'note_twelve8'	=> [I, NONE],
		'note_twelve9'	=> [O, NONE],
		'note_twelve10'	=> [P, NONE],
		'note_twelve11'	=> [LBRACKET, NONE],
		'note_twelve12'	=> [RBRACKET, NONE],

		// 13K  
		'note_thirteen1' => [Q, NONE],
		'note_thirteen2' => [W, NONE],
		'note_thirteen3' => [E, NONE],
		'note_thirteen4' => [R, NONE],
		'note_thirteen5' => [T, NONE],
		'note_thirteen6' => [Y, NONE],
		'note_thirteen7' => [SPACE, NONE],
		'note_thirteen8' => [U, NONE],
		'note_thirteen9' => [I, NONE],
		'note_thirteen10' => [O, NONE],
		'note_thirteen11' => [P, NONE],
		'note_thirteen12' => [LBRACKET, NONE],
		'note_thirteen13' => [RBRACKET, NONE],

		// 14K
		'note_fourteen1' => [Q, NONE],
		'note_fourteen2' => [W, NONE],
		'note_fourteen3' => [E, NONE],
		'note_fourteen4' => [R, NONE],
		'note_fourteen5' => [T, NONE],
		'note_fourteen6' => [Y, NONE],
		'note_fourteen7' => [U, NONE],
		'note_fourteen8' => [I, NONE],
		'note_fourteen9' => [O, NONE],
		'note_fourteen10' => [P, NONE],
		'note_fourteen11' => [LBRACKET, NONE],
		'note_fourteen12' => [RBRACKET, NONE],
		'note_fourteen13' => [BACKSLASH, NONE],
		'note_fourteen14' => [ENTER, NONE],

		// 15K
		'note_fifteen1' => [Q, NONE],
		'note_fifteen2' => [W, NONE],
		'note_fifteen3' => [E, NONE],
		'note_fifteen4' => [R, NONE],
		'note_fifteen5' => [T, NONE],
		'note_fifteen6' => [Y, NONE],
		'note_fifteen7' => [U, NONE],
		'note_fifteen8' => [SPACE, NONE],
		'note_fifteen9' => [I, NONE],
		'note_fifteen10' => [O, NONE],
		'note_fifteen11' => [P, NONE],
		'note_fifteen12' => [LBRACKET, NONE],
		'note_fifteen13' => [RBRACKET, NONE],
		'note_fifteen14' => [BACKSLASH, NONE],
		'note_fifteen15' => [ENTER, NONE],

		// 16K
		'note_sixteen1' => [ONE, NONE],
		'note_sixteen2' => [TWO, NONE],
		'note_sixteen3' => [THREE, NONE],
		'note_sixteen4' => [FOUR, NONE],
		'note_sixteen5' => [FIVE, NONE],
		'note_sixteen6' => [SIX, NONE],
		'note_sixteen7' => [SEVEN, NONE],
		'note_sixteen8' => [EIGHT, NONE],
		'note_sixteen9' => [NINE, NONE],
		'note_sixteen10' => [ZERO, NONE],
		'note_sixteen11' => [MINUS, NONE],
		'note_sixteen12' => [GRAVEACCENT, NONE],
		'note_sixteen13' => [BACKSPACE, NONE],
		'note_sixteen14' => [TAB, NONE],
		'note_sixteen15' => [Q, NONE],
		'note_sixteen16' => [W, NONE],

		// 17K
		'note_seventeen1' => [ONE, NONE],
		'note_seventeen2' => [TWO, NONE],
		'note_seventeen3' => [THREE, NONE],
		'note_seventeen4' => [FOUR, NONE],
		'note_seventeen5' => [FIVE, NONE],
		'note_seventeen6' => [SIX, NONE],
		'note_seventeen7' => [SEVEN, NONE],
		'note_seventeen8' => [EIGHT, NONE],
		'note_seventeen9' => [SPACE, NONE],
		'note_seventeen10' => [NINE, NONE],
		'note_seventeen11' => [ZERO, NONE],
		'note_seventeen12' => [MINUS, NONE],
		'note_seventeen13' => [GRAVEACCENT, NONE],
		'note_seventeen14' => [BACKSPACE, NONE],
		'note_seventeen15' => [TAB, NONE],
		'note_seventeen16' => [Q, NONE],
		'note_seventeen17' => [W, NONE],

		// 18K
		'note_eighteen1' => [ONE, NONE],
		'note_eighteen2' => [TWO, NONE],
		'note_eighteen3' => [THREE, NONE],
		'note_eighteen4' => [FOUR, NONE],
		'note_eighteen5' => [FIVE, NONE],
		'note_eighteen6' => [SIX, NONE],
		'note_eighteen7' => [SEVEN, NONE],
		'note_eighteen8' => [EIGHT, NONE],
		'note_eighteen9' => [NINE, NONE],
		'note_eighteen10' => [ZERO, NONE],
		'note_eighteen11' => [MINUS, NONE],
		'note_eighteen12' => [GRAVEACCENT, NONE],
		'note_eighteen13' => [BACKSPACE, NONE],
		'note_eighteen14' => [TAB, NONE],
		'note_eighteen15' => [Q, NONE],
		'note_eighteen16' => [W, NONE],
		'note_eighteen17' => [E, NONE],
		'note_eighteen18' => [R, NONE],
		
		// UI Controls (no tocar)
		'ui_up'			=> [W, UP],
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R],
		
		'volume_mute'	=> [ZERO],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN],
		'debug_2'		=> [EIGHT],
		
		'fullscreen'	=> [F11]
	];
	public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
		'note_up'		=> [DPAD_UP, Y],
		'note_left'		=> [DPAD_LEFT, X],
		'note_down'		=> [DPAD_DOWN, A],
		'note_right'	=> [DPAD_RIGHT, B],
		
		'ui_up'			=> [DPAD_UP, LEFT_STICK_DIGITAL_UP],
		'ui_left'		=> [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
		'ui_down'		=> [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
		'ui_right'		=> [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
		
		'accept'		=> [A, START],
		'back'			=> [B],
		'pause'			=> [START],
		'reset'			=> [BACK]
	];
	public static var mobileBinds:Map<String, Array<MobileInputID>> = [
		'note_up'		=> [NOTE_UP],
		'note_left'		=> [NOTE_LEFT],
		'note_down'		=> [NOTE_DOWN],
		'note_right'	=> [NOTE_RIGHT],

		'ui_up'			=> [UP],
		'ui_left'		=> [LEFT],
		'ui_down'		=> [DOWN],
		'ui_right'		=> [RIGHT],

		'accept'		=> [A],
		'back'			=> [B],
		'pause'			=> [#if android NONE #else P #end],
		'reset'			=> [NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;
	public static var defaultMobileBinds:Map<String, Array<MobileInputID>> = null;

	public static function resetKeys(controller:Null<Bool> = null) //Null = both, False = Keyboard, True = Controller
	{
		if(controller != true)
			for (key in keyBinds.keys())
				if(defaultKeys.exists(key))
					keyBinds.set(key, defaultKeys.get(key).copy());

		if(controller != false)
			for (button in gamepadBinds.keys())
				if(defaultButtons.exists(button))
					gamepadBinds.set(button, defaultButtons.get(button).copy());
	}

	public static function clearInvalidKeys(key:String)
	{
		var keyBind:Array<FlxKey> = keyBinds.get(key);
		var gamepadBind:Array<FlxGamepadInputID> = gamepadBinds.get(key);
		var mobileBind:Array<MobileInputID> = mobileBinds.get(key);
		while(keyBind != null && keyBind.contains(NONE)) keyBind.remove(NONE);
		while(gamepadBind != null && gamepadBind.contains(NONE)) gamepadBind.remove(NONE);
		while(mobileBind != null && mobileBind.contains(NONE)) mobileBind.remove(NONE);
	}

	public static function loadDefaultKeys()
	{
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
		defaultMobileBinds = mobileBinds.copy();
		setupExtraKeys(); // Configurar extra keys dinámicamente
	}

	// Función para configurar las extra keys dinámicamente
	public static function setupExtraKeys()
	{
		if (ExtraKeysHandler.instance == null || ExtraKeysHandler.instance.data == null) 
			return;

		var data = ExtraKeysHandler.instance.data;
		
		// Configurar keybinds para cada mania
		for (mania in 0...data.maxKeys + 1) {
			if (data.keybinds != null && mania < data.keybinds.length) {
				var maniaKeybinds = data.keybinds[mania];
				for (keyIndex in 0...maniaKeybinds.length) {
					var keyCodes = maniaKeybinds[keyIndex];
					var keyName = '${mania}_key_$keyIndex';
					
					// Convertir keycodes a FlxKey
					var flxKeys:Array<FlxKey> = [];
					for (code in keyCodes) {
						// Convertir código numérico directamente a FlxKey
						var flxKey:FlxKey = cast(code, FlxKey);
						flxKeys.push(flxKey);
					}
					
					// Si no hay suficientes keys, agregar NONE
					while (flxKeys.length < 2) {
						flxKeys.push(NONE);
					}
					
					keyBinds.set(keyName, flxKeys);
				}
			}
		}
		
		// Actualizar defaultKeys
		if (defaultKeys == null) defaultKeys = new Map();
		for (key => value in keyBinds) {
			if (key.contains('_key_')) {
				defaultKeys.set(key, value.copy());
			}
		}
	}

	public static function saveSettings() {
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		#if ACHIEVEMENTS_ALLOWED Achievements.save(); #end
		FlxG.save.flush();

        //Wow counter =p
        Reflect.setField(FlxG.save.data, "judgementCounter", judgementCounter);
		data.judgementCounter = judgementCounter;

		//Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		save.data.keyboard = keyBinds;
		save.data.gamepad = gamepadBinds;
		save.data.mobile = mobileBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

		for (key in Reflect.fields(data))
			if (key != 'gameplaySettings' && Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
		
		if(Main.fpsVar != null)
			Main.fpsVar.visible = data.showFPS;

		#if (!html5 && !switch)
		FlxG.autoPause = ClientPrefs.data.autoPause;

		if(FlxG.save.data.framerate == null) {
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			data.framerate = Std.int(FlxMath.bound(refreshRate, 60, 240));
		}
		#end

		if (Reflect.hasField(FlxG.save.data, "judgementCounter"))
            judgementCounter = !!Reflect.field(FlxG.save.data, "judgementCounter");
		    judgementCounter = data.judgementCounter;

		if (data.fpsRework)
			FlxG.stage.window.frameRate = data.framerate;
		else
		{
			if (data.framerate > FlxG.drawFramerate)
			{
				FlxG.updateFramerate = data.framerate;
				FlxG.drawFramerate = data.framerate;
			}
			else
			{
				FlxG.drawFramerate = data.framerate;
				FlxG.updateFramerate = data.framerate;
			}
		}

		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
				data.gameplaySettings.set(name, value);
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		#if DISCORD_ALLOWED DiscordClient.check(); #end

		// controls on a separate save file
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		if(save != null)
		{
			if(save.data.keyboard != null)
			{
				var loadedControls:Map<String, Array<FlxKey>> = save.data.keyboard;
				for (control => keys in loadedControls)
					if(keyBinds.exists(control)) keyBinds.set(control, keys);
			}
			if(save.data.gamepad != null)
			{
				var loadedControls:Map<String, Array<FlxGamepadInputID>> = save.data.gamepad;
				for (control => keys in loadedControls)
					if(gamepadBinds.exists(control)) gamepadBinds.set(control, keys);
			}
			if(save.data.mobile != null) {
				var loadedControls:Map<String, Array<MobileInputID>> = save.data.mobile;
				for (control => keys in loadedControls)
					if(mobileBinds.exists(control)) mobileBinds.set(control, keys);
			}
			reloadVolumeKeys();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic = null, ?customDefaultValue:Bool = false):Dynamic
	{
		if(!customDefaultValue) defaultValue = defaultData.gameplaySettings.get(name);
		return /*PlayState.isStoryMode ? defaultValue : */ (data.gameplaySettings.exists(name) ? data.gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadVolumeKeys()
	{
		TitleState.muteKeys = keyBinds.get('volume_mute').copy();
		TitleState.volumeDownKeys = keyBinds.get('volume_down').copy();
		TitleState.volumeUpKeys = keyBinds.get('volume_up').copy();
		toggleVolumeKeys(true);
	}
	public static function toggleVolumeKeys(?turnOn:Bool = true)
	{
		final emptyArray = [];
		FlxG.sound.muteKeys = (!Controls.instance.mobileC && turnOn) ? TitleState.muteKeys : emptyArray;
		FlxG.sound.volumeDownKeys = (!Controls.instance.mobileC && turnOn) ? TitleState.volumeDownKeys : emptyArray;
		FlxG.sound.volumeUpKeys = (!Controls.instance.mobileC && turnOn) ? TitleState.volumeUpKeys : emptyArray;
	}
}
