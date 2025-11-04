package backend;

import openfl.events.UncaughtErrorEvent;
import openfl.events.ErrorEvent;
import openfl.errors.Error;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;
using flixel.util.FlxArrayUtil;

/**
 * Crash Handler.
 * @author YoshiCrafter29, Ne_Eo, MAJigsaw77 and Homura Akemi (HomuHomu833)
 */
class CrashHandler
{
	// Link de ayuda/repositorio para mostrar en caso de crash
	public static final HELP_LINK:String = "https://github.com/LeninAsto/FNF-PlusEngine";
	
	public static function init():Void
	{
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onError);
		#elseif hl
		hl.Api.setErrorHandler(onError);
		#end
	}

	private static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();

		var m:String = e.error;
		if (Std.isOfType(e.error, Error))
		{
			var err = cast(e.error, Error);
			m = '${err.message}';
		}
		else if (Std.isOfType(e.error, ErrorEvent))
		{
			var err = cast(e.error, ErrorEvent);
			m = '${err.text}';
		}
		var stack = haxe.CallStack.exceptionStack();
		var stackLabelArr:Array<String> = [];
		var stackLabel:String = "";
		for (e in stack)
		{
			switch (e)
			{
				case CFunction:
					stackLabelArr.push("Non-Haxe (C) Function");
				case Module(c):
					stackLabelArr.push('Module ${c}');
				case FilePos(parent, file, line, col):
					switch (parent)
					{
						case Method(cla, func):
							stackLabelArr.push('${file.replace('.hx', '')}.$func() [line $line]');
						case _:
							stackLabelArr.push('${file.replace('.hx', '')} [line $line]');
					}
				case LocalFunction(v):
					stackLabelArr.push('Local Function ${v}');
				case Method(cl, m):
					stackLabelArr.push('${cl} - ${m}');
			}
		}
		stackLabel = stackLabelArr.join('\r\n');

		// Mostrar error en la consola/terminal
		trace('\n\n$m\n\n$stackLabel\n======================\nFor help, visit: $HELP_LINK');
		
		#if sys
		saveErrorMessage('$m\n$stackLabel');
		#end

		// Mensaje con link de ayuda
		var errorMsg = '$m\n\n$stackLabel\n\n━━━━━━━━━━━━━━━━━━━━━━\nNeed help? Visit:\n$HELP_LINK';
		CoolUtil.showPopUp(errorMsg, "Error!");
		#if DISCORD_ALLOWED DiscordClient.shutdown(); #end
		lime.system.System.exit(1);
	}

	#if (cpp || hl)
	private static function onError(message:Dynamic):Void
	{
		final log:Array<String> = [];

		if (message != null && message.length > 0)
			log.push(message);

		log.push(haxe.CallStack.toString(haxe.CallStack.exceptionStack(true)));
		
		var errorLog = log.join('\n');
		
		// Mostrar error en la consola/terminal
		trace('=== CRITICAL ERROR ===');
		trace(errorLog);
		trace('======================');
		trace('For help, visit: $HELP_LINK');

		#if sys
		saveErrorMessage(errorLog);
		#end

		// Mensaje con link de ayuda
		var errorMsg = '$errorLog\n\n━━━━━━━━━━━━━━━━━━━━━━\nNeed help? Visit:\n$HELP_LINK';
		CoolUtil.showPopUp(errorMsg, "Critical Error!");
		#if DISCORD_ALLOWED DiscordClient.shutdown(); #end
		lime.system.System.exit(1);
	}
	#end

	#if sys
	private static function saveErrorMessage(message:String):Void
	{
		final folder:String = #if android StorageUtil.getExternalStorageDirectory() + #else Sys.getCwd() + #end 'logs/';

		try
		{
			if (!FileSystem.exists(folder))
				FileSystem.createDirectory(folder);

			var fullLog = message + '\n\n━━━━━━━━━━━━━━━━━━━━━━\nFor help, visit: $HELP_LINK\n━━━━━━━━━━━━━━━━━━━━━━';
			File.saveContent(folder + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', fullLog);
		}
		catch (e:haxe.Exception)
			trace('Couldn\'t save error message. (${e.message})');
	}
	#end
}
