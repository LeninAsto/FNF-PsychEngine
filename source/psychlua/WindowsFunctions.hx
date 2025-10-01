package psychlua;

#if WINDOWS_FUNCTIONS_ALLOWED
import psychlua.WindowTweens;
#end

class WindowsFunctions
{
	public static function implement(funk:FunkinLua) {
		#if WINDOWS_FUNCTIONS_ALLOWED
		var lua = funk.lua;
		
		// Window Tween Functions
		Lua_helper.add_callback(lua, "winTweenSize", function(width:Int, height:Int, duration:Float = 1, ease:String = "linear") {
			return WindowTweens.winTweenSize(width, height, duration, ease);
		});
		
		Lua_helper.add_callback(lua, "winTweenX", function(tag:String, targetX:Int, duration:Float = 1, ease:String = "linear") {
			return WindowTweens.winTweenX(tag, targetX, duration, ease);
		});
		
		Lua_helper.add_callback(lua, "winTweenY", function(tag:String, targetY:Int, duration:Float = 1, ease:String = "linear") {
			return WindowTweens.winTweenY(tag, targetY, duration, ease);
		});

		// Window Position Functions (Immediate)
		Lua_helper.add_callback(lua, "setWindowX", function(x:Int) {
			WindowTweens.setWindowX(x);
		});
		
		Lua_helper.add_callback(lua, "setWindowY", function(y:Int) {
			WindowTweens.setWindowY(y);
		});
		
		Lua_helper.add_callback(lua, "setWindowSize", function(width:Int, height:Int) {
			WindowTweens.setWindowSize(width, height);
		});
		
		// Window Information Functions
		Lua_helper.add_callback(lua, "getWindowX", function() {
			return WindowTweens.getWindowX();
		});
		
		Lua_helper.add_callback(lua, "getWindowY", function() {
			return WindowTweens.getWindowY();
		});
		
		Lua_helper.add_callback(lua, "getWindowWidth", function() {
			return WindowTweens.getWindowWidth();
		});
		
		Lua_helper.add_callback(lua, "getWindowHeight", function() {
			return WindowTweens.getWindowHeight();
		});
		
		// Window State Control Functions
		Lua_helper.add_callback(lua, "centerWindow", function() {
			WindowTweens.centerWindow();
		});
		
		// Window Properties Functions
		Lua_helper.add_callback(lua, "setWindowTitle", function(title:String) {
			WindowTweens.setWindowTitle(title);
		});
		
		Lua_helper.add_callback(lua, "getWindowTitle", function() {
			return WindowTweens.getWindowTitle();
		});
		
		Lua_helper.add_callback(lua, "setWindowIcon", function(iconPath:String) {
			WindowTweens.setWindowIcon(iconPath);
		});
		
		Lua_helper.add_callback(lua, "setWindowResizable", function(enable:Bool) {
			WindowTweens.setWindowResizable(enable);
		});
		
		// Window Effects Functions
		Lua_helper.add_callback(lua, "shakeWindow", function(?intensity:Float = 5.0, ?duration:Float = 0.5) {
			WindowTweens.shakeWindow(intensity, duration);
		});
		
		Lua_helper.add_callback(lua, "bounceWindow", function(?bounces:Int = 3, ?height:Float = 50.0, ?duration:Float = 1.0) {
			WindowTweens.bounceWindow(bounces, height, duration);
		});
		
		Lua_helper.add_callback(lua, "orbitWindow", function(centerX:Int, centerY:Int, ?radius:Float = 100.0, ?speed:Float = 1.0, ?duration:Float = 5.0) {
			WindowTweens.orbitWindow(centerX, centerY, radius, speed, duration);
		});
		
		Lua_helper.add_callback(lua, "pulseWindow", function(?minScale:Float = 0.8, ?maxScale:Float = 1.2, ?pulseSpeed:Float = 2.0, ?duration:Float = 3.0) {
			WindowTweens.pulseWindow(minScale, maxScale, pulseSpeed, duration);
		});
		
		Lua_helper.add_callback(lua, "spinWindow", function(?rotations:Int = 1, ?duration:Float = 2.0) {
			WindowTweens.spinWindow(rotations, duration);
		});
		
		Lua_helper.add_callback(lua, "randomizeWindowPosition", function(?minX:Int = 0, ?maxX:Int = -1, ?minY:Int = 0, ?maxY:Int = -1) {
			WindowTweens.randomizeWindowPosition(minX, maxX, minY, maxY);
		});
		
		// Screen Information Functions
		Lua_helper.add_callback(lua, "getScreenWidth", function() {
			return WindowTweens.getScreenResolution().width;
		});
		
		Lua_helper.add_callback(lua, "getScreenHeight", function() {
			return WindowTweens.getScreenResolution().height;
		});
		
		Lua_helper.add_callback(lua, "getScreenResolution", function() {
			return WindowTweens.getScreenResolution();
		});
		
		// Window Fullscreen Functions
		Lua_helper.add_callback(lua, "setWindowFullscreen", function(enable:Bool) {
			WindowTweens.setWindowFullscreen(enable);
		});
		
		Lua_helper.add_callback(lua, "isWindowFullscreen", function() {
			return WindowTweens.isWindowFullscreen();
		});
		
		// Window State Management Functions
		Lua_helper.add_callback(lua, "saveWindowState", function() {
			return WindowTweens.saveWindowState();
		});
		
		Lua_helper.add_callback(lua, "loadWindowState", function(stateJson:String) {
			WindowTweens.loadWindowState(stateJson);
		});
		
		// === NUEVAS FUNCIONES CON WINDOWS API ===
		
		// Window State Information Functions
		Lua_helper.add_callback(lua, "getWindowState", function() {
			return WindowTweens.getWindowState();
		});
		
		// Window Animation Functions
		Lua_helper.add_callback(lua, "slideInWindow", function(direction:String, ?duration:Int = 500) {
			WindowTweens.slideInWindow(direction, duration);
		});
		
		Lua_helper.add_callback(lua, "fadeInWindow", function(?duration:Int = 500) {
			WindowTweens.fadeInWindow(duration);
		});
		
		Lua_helper.add_callback(lua, "expandWindow", function(?duration:Int = 500) {
			WindowTweens.expandWindow(duration);
		});
		
		// System Audio Control Functions
		Lua_helper.add_callback(lua, "setSystemVolume", function(volume:Float) {
			WindowTweens.setSystemVolume(volume);
		});
		
		Lua_helper.add_callback(lua, "muteSystem", function(mute:Bool) {
			WindowTweens.muteSystem(mute);
		});
		
		// System Utilities Functions
		Lua_helper.add_callback(lua, "createDesktopShortcut", function(name:String, targetPath:String, ?iconPath:String = "") {
			WindowTweens.createDesktopShortcut(name, targetPath, iconPath);
		});
		
		// === FUNCIONES DISPONIBLES CON SL-WINDOWS-API ===
		
		// Desktop/System Control Functions
		Lua_helper.add_callback(lua, "setDesktopWallpaper", function(path:String) {
			WindowTweens.setDesktopWallpaper(path);
		});
		
		Lua_helper.add_callback(lua, "hideDesktopIcons", function(hide:Bool) {
			WindowTweens.hideDesktopIcons(hide);
		});
		
		Lua_helper.add_callback(lua, "hideTaskBar", function(hide:Bool) {
			WindowTweens.hideTaskBar(hide);
		});
		
		Lua_helper.add_callback(lua, "moveDesktopElements", function(x:Int, y:Int) {
			WindowTweens.moveDesktopElements(x, y);
		});
		
		Lua_helper.add_callback(lua, "setDesktopTransparency", function(alpha:Float) {
			WindowTweens.setDesktopTransparency(alpha);
		});
		
		Lua_helper.add_callback(lua, "setTaskBarTransparency", function(alpha:Float) {
			WindowTweens.setTaskBarTransparency(alpha);
		});
		
		// System Information Functions
		Lua_helper.add_callback(lua, "getCursorPosition", function() {
			return WindowTweens.getCursorPosition();
		});
		
		Lua_helper.add_callback(lua, "getSystemRAM", function() {
			return WindowTweens.getSystemRAM();
		});
		
		// System Notification Functions
		Lua_helper.add_callback(lua, "showNotification", function(title:String, message:String) {
			WindowTweens.showNotification(title, message);
		});
		
		// System Reset Functions
		Lua_helper.add_callback(lua, "resetSystemChanges", function() {
			WindowTweens.resetSystemChanges();
		});
		
		// === ANIMACIONES AVANZADAS Y ESPECTACULARES ===
		
		// Animaciones de Deformación
		Lua_helper.add_callback(lua, "elasticWindow", function(intensity:Float = 1.5, cycles:Int = 3, duration:Float = 2.0) {
			WindowTweens.elasticWindow(intensity, cycles, duration);
		});
		
		Lua_helper.add_callback(lua, "waveWindow", function(amplitude:Float = 50.0, frequency:Float = 2.0, duration:Float = 3.0) {
			WindowTweens.waveWindow(amplitude, frequency, duration);
		});
		
		Lua_helper.add_callback(lua, "liquidWindow", function(viscosity:Float = 0.8, amplitude:Float = 20.0, duration:Float = 3.0) {
			WindowTweens.liquidWindow(viscosity, amplitude, duration);
		});
		
		Lua_helper.add_callback(lua, "breathingWindow", function(breathRate:Float = 1.0, intensity:Float = 0.1, duration:Float = 5.0) {
			WindowTweens.breathingWindow(breathRate, intensity, duration);
		});
		
		// Animaciones de Movimiento Complejo
		Lua_helper.add_callback(lua, "spiralWindow", function(spirals:Float = 2.0, radius:Float = 100.0, duration:Float = 3.0) {
			WindowTweens.spiralWindow(spirals, radius, duration);
		});
		
		Lua_helper.add_callback(lua, "zigzagWindow", function(zigzags:Int = 5, amplitude:Float = 100.0, duration:Float = 2.0) {
			WindowTweens.zigzagWindow(zigzags, amplitude, duration);
		});
		
		Lua_helper.add_callback(lua, "teleportWindow", function(targetX:Int, targetY:Int, glitchIntensity:Float = 20.0, teleportDuration:Float = 0.5) {
			WindowTweens.teleportWindow(targetX, targetY, glitchIntensity, teleportDuration);
		});
		
		// Animaciones de Efectos Especiales
		Lua_helper.add_callback(lua, "earthquakeWindow", function(intensity:Float = 10.0, frequency:Float = 15.0, duration:Float = 1.5) {
			WindowTweens.earthquakeWindow(intensity, frequency, duration);
		});
		
		Lua_helper.add_callback(lua, "magnetWindow", function(magnetX:Int, magnetY:Int, strength:Float = 1.0, duration:Float = 2.0) {
			WindowTweens.magnetWindow(magnetX, magnetY, strength, duration);
		});
		
		Lua_helper.add_callback(lua, "windWindow", function(windDirection:Float = 0, windStrength:Float = 5.0, turbulence:Float = 2.0, duration:Float = 3.0) {
			WindowTweens.windWindow(windDirection, windStrength, turbulence, duration);
		});
		
		// Animaciones de Transformación
		Lua_helper.add_callback(lua, "morphWindow", function(targetWidth:Int, targetHeight:Int, morphStyle:String = "smooth", duration:Float = 2.0) {
			WindowTweens.morphWindow(targetWidth, targetHeight, morphStyle, duration);
		});
		
		// === ANIMACIONES COMBINADAS Y ESPECIALES ===
		
		// Animaciones Combinadas
		Lua_helper.add_callback(lua, "comboAnimation", function(animations:Array<String>, duration:Float = 1.0) {
			WindowTweens.comboAnimation(animations, duration);
		});
		
		Lua_helper.add_callback(lua, "rhythmWindow", function(bpm:Float = 120.0, pattern:String = "pulse", intensity:Float = 1.0, duration:Float = 8.0) {
			WindowTweens.rhythmWindow(bpm, pattern, intensity, duration);
		});
		
		// Animaciones de Danza y Movimiento
		Lua_helper.add_callback(lua, "danceWindow", function(danceType:String = "sway", tempo:Float = 1.0, amplitude:Float = 30.0, duration:Float = 5.0) {
			WindowTweens.danceWindow(danceType, tempo, amplitude, duration);
		});
		
		// Efectos Especiales Avanzados
		Lua_helper.add_callback(lua, "glitchWindow", function(glitchIntensity:Float = 50.0, glitchFrequency:Float = 0.1, duration:Float = 2.0) {
			WindowTweens.glitchWindow(glitchIntensity, glitchFrequency, duration);
		});
		
		Lua_helper.add_callback(lua, "matrixWindow", function(fallSpeed:Float = 2.0, duration:Float = 3.0) {
			WindowTweens.matrixWindow(fallSpeed, duration);
		});
		
		Lua_helper.add_callback(lua, "gravityWindow", function(gravityStrength:Float = 0.5, bounce:Float = 0.7, duration:Float = 4.0) {
			WindowTweens.gravityWindow(gravityStrength, bounce, duration);
		});
		
		// Legacy/Compatibility Functions (mantener al final)
		Lua_helper.add_callback(lua, "hideWindowBorder", function(enable:Bool) {
			WindowTweens.setWindowBorderless(enable);
		});
		
		Lua_helper.add_callback(lua, "setWinRCenter", function(width:Int, height:Int, ?skip:Bool = false) {
			WindowTweens.winResizeCenter(width, height, skip);
		});
		#end
	}
}