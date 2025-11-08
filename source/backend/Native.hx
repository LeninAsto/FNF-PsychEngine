package backend;

import lime.app.Application;
import lime.system.Display;
import lime.system.System;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

#if cpp
import cpp.vm.Gc;
#end

#if (cpp && windows)
@:buildXml('
<target id="haxe">
	<lib name="dwmapi.lib" if="windows"/>
	<lib name="gdi32.lib" if="windows"/>
</target>
')
@:cppFileCode('
#include <windows.h>
#include <dwmapi.h>
#include <winuser.h>
#include <wingdi.h>

#define attributeDarkMode 20
#define attributeDarkModeFallback 19

#define attributeCaptionColor 34
#define attributeTextColor 35
#define attributeBorderColor 36

struct HandleData {
	DWORD pid = 0;
	HWND handle = 0;
};

BOOL CALLBACK findByPID(HWND handle, LPARAM lParam) {
	DWORD targetPID = ((HandleData*)lParam)->pid;
	DWORD curPID = 0;

	GetWindowThreadProcessId(handle, &curPID);
	if (targetPID != curPID || GetWindow(handle, GW_OWNER) != (HWND)0 || !IsWindowVisible(handle)) {
		return TRUE;
	}

	((HandleData*)lParam)->handle = handle;
	return FALSE;
}

HWND curHandle = 0;
void getHandle() {
	if (curHandle == (HWND)0) {
		HandleData data;
		data.pid = GetCurrentProcessId();
		EnumWindows(findByPID, (LPARAM)&data);
		curHandle = data.handle;
	}
}
')
#end
class Native
{
	public static function __init__():Void
	{
		registerDPIAware();
	}

	public static function registerDPIAware():Void
	{
		#if (cpp && windows)
		// DPI Scaling fix for windows 
		// this shouldn't be needed for other systems
		// Credit to YoshiCrafter29 for finding this function
		untyped __cpp__('
			SetProcessDPIAware();	
			#ifdef DPI_AWARENESS_CONTEXT
			SetProcessDpiAwarenessContext(
				#ifdef DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2
				DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2
				#else
				DPI_AWARENESS_CONTEXT_SYSTEM_AWARE
				#endif
			);
			#endif
		');
		#end
	}

	private static var fixedScaling:Bool = false;
	public static function fixScaling():Void
	{
		if (fixedScaling) return;
		fixedScaling = true;

		#if (cpp && windows)
		final display:Null<Display> = System.getDisplay(0);
		if (display != null)
		{
			final dpiScale:Float = display.dpi / 96;
			@:privateAccess Application.current.window.width = Std.int(Main.game.width * dpiScale);
			@:privateAccess Application.current.window.height = Std.int(Main.game.height * dpiScale);

			Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
			Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);
		}

		untyped __cpp__('
			getHandle();
			if (curHandle != (HWND)0) {
				HDC curHDC = GetDC(curHandle);
				RECT curRect;
				GetClientRect(curHandle, &curRect);
				FillRect(curHDC, &curRect, (HBRUSH)GetStockObject(BLACK_BRUSH));
				ReleaseDC(curHandle, curHDC);
			}
		');
		#end
	}

	/**
	 * Builds a simplified system information report.
	 * Shows only GPU name and OpenGL version.
	 */
	public static function buildSystemInfo():String
	{
		var info = '';
		
		// GPU Detection
		var driverInfo = FlxG?.stage?.context3D?.driverInfo ?? 'N/A';
		var gpuName = parseGPUName(driverInfo);
		
		if (gpuName != null && gpuName != 'N/A') {
			info += 'GPU: ${gpuName}\n';
		} else {
			info += 'GPU: Unknown\n';
		}
		
		// OpenGL Version Detection
		#if (!flash && sys)
		try {
			@:privateAccess
			var gl = FlxG.stage.context3D.gl;
			if (gl != null) {
				var glslVersion = gl.getParameter(gl.SHADING_LANGUAGE_VERSION);
				
				// Check for modern rendering support
				var supportsModern = checkModernGLSupport(glslVersion);
				
				if (supportsModern) {
					info += 'OpenGL: Modern (GLSL 3.3+)\n';
				} else {
					info += 'OpenGL: Legacy (GLSL 1.2) - Limited shader support\n';
				}
			}
		} catch (e:Dynamic) {
			info += 'OpenGL: Unable to detect\n';
		}
		#end
		
		return info;
	}

	/**
	 * Parses GPU name from driver info string.
	 * Examples: "OpenGL ES 3.0 NVIDIA GeForce RTX 3050" -> "NVIDIA GeForce RTX 3050"
	 */
	private static function parseGPUName(driverInfo:String):Null<String>
	{
		if (driverInfo == null || driverInfo == 'N/A') return null;
		
		// Remove common prefixes
		var info = driverInfo;
		info = StringTools.replace(info, 'OpenGL ES 3.0 ', '');
		info = StringTools.replace(info, 'OpenGL ES 2.0 ', '');
		info = StringTools.replace(info, 'OpenGL ', '');
		
		// Common GPU vendor patterns
		if (info.indexOf('NVIDIA') != -1 || info.indexOf('GeForce') != -1 || info.indexOf('RTX') != -1 || info.indexOf('GTX') != -1) {
			// NVIDIA card detected
			var start = info.indexOf('NVIDIA');
			if (start == -1) start = info.indexOf('GeForce');
			if (start == -1) start = info.indexOf('RTX');
			if (start == -1) start = info.indexOf('GTX');
			if (start != -1) {
				return info.substring(start).split('/')[0].trim();
			}
		}
		
		if (info.indexOf('AMD') != -1 || info.indexOf('Radeon') != -1) {
			// AMD card detected
			var start = info.indexOf('AMD');
			if (start == -1) start = info.indexOf('Radeon');
			if (start != -1) {
				return info.substring(start).split('/')[0].trim();
			}
		}
		
		if (info.indexOf('Intel') != -1) {
			// Intel card detected
			var start = info.indexOf('Intel');
			if (start != -1) {
				return info.substring(start).split('/')[0].trim();
			}
		}
		
		// If no specific pattern matched, return cleaned info
		return info.length > 0 && info.length < 100 ? info : null;
	}

	/**
	 * Checks if the system supports modern OpenGL (3.3+) or OpenGL ES (3.0+)
	 */
	private static function checkModernGLSupport(glslVersion:String):Bool
	{
		if (glslVersion == null || glslVersion == '') return false;
		
		#if lime_opengles
		// OpenGL ES - check for 3.0+
		var version_part = StringTools.replace(glslVersion, "OpenGL ES GLSL ES ", "");
		var versionNum = Std.parseInt(StringTools.replace(version_part, ".", ""));
		return versionNum != null && versionNum >= 300;
		#else
		// Desktop OpenGL - check for 3.3+
		var versionNum = Std.parseInt(glslVersion.split(" ")[0].replace(".", ""));
		return versionNum != null && versionNum >= 330;
		#end
	}

	/**
	 * Gets enhancement status based on detected GPU
	 */
	public static function getGPUEnhancements():String
	{
		var driverInfo = FlxG?.stage?.context3D?.driverInfo ?? 'N/A';
		var gpuName = parseGPUName(driverInfo);
		
		if (gpuName == null) return "Unknown GPU - Using standard settings";
		
		var gpu = gpuName.toLowerCase();
		
		// Check for high-end GPUs
		if (gpu.indexOf('rtx') != -1 || gpu.indexOf('rx 7') != -1 || gpu.indexOf('rx 6') != -1) {
			return "High-end GPU detected - All features enabled";
		}
		
		// Check for mid-range GPUs
		if (gpu.indexOf('gtx 16') != -1 || gpu.indexOf('gtx 10') != -1 || gpu.indexOf('rx 5') != -1 || gpu.indexOf('vega') != -1) {
			return "Mid-range GPU detected - Full shader support";
		}
		
		// Check for integrated/low-end GPUs
		if (gpu.indexOf('intel') != -1 || gpu.indexOf('uhd') != -1 || gpu.indexOf('iris') != -1) {
			return "Integrated GPU detected - Consider lowering quality for better performance";
		}
		
		return "GPU detected - Standard features enabled";
	}
}