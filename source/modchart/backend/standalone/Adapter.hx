package modchart.backend.standalone;

import haxe.macro.Compiler;

class Adapter {
	public static var instance:IAdapter;
	private static var ENGINE_NAME:String = Compiler.getDefine("FM_ENGINE");

	public static function init() {
		if (instance != null)
			return;

		final possibleClientName = ENGINE_NAME.substr(0, 1).toUpperCase() + ENGINE_NAME.substr(1).toLowerCase();
		final adapter = Type.createInstance(Type.resolveClass('modchart.backend.standalone.adapters.${ENGINE_NAME.toLowerCase()}.' + possibleClientName), []);

		#if FM_VERBOSE
		trace('[FunkinModchart Verbose] Finding possible adapter from "modchart.backend.standalone.adapters.${ENGINE_NAME.toLowerCase()}.${possibleClientName}"');
		#end

		if (adapter == null)
			throw 'Adapter not found for $ENGINE_NAME';

		#if FM_VERBOSE
		trace('[FunkinModchart Verbose] Found Adapter!');
		#end

		instance = adapter;
	}
}
