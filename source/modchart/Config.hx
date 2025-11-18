package modchart;

#if (FM_ENGINE_VERSION == "1.0" || FM_ENGINE_VERSION == "0.7")
import backend.ClientPrefs;
#else
import ClientPrefs;
#end

/**
 * Configuration settings for modchart behavior.
 * 
 * This class contains various static variables that control rendering,
 * performance optimizations, and visual settings for modcharts.
 * Adjust these settings to customize how elements behave and render.
 */
class Config {
	/**
	 * Enables or disables 3D cameras.
	 * 
	 * Setting this to `false` will disable 3D camera functionality, which may improve performance.
	 * When disabled, all 3D-related transformations and rendering will be skipped.
	 * 
	 * Default: `true` (3D cameras enabled).
	 */
	public static var CAMERA3D_ENABLED(get, never):Bool;
	static inline function get_CAMERA3D_ENABLED():Bool {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.camera3dEnabled;
		#else
		return ClientPrefs.camera3dEnabled;
		#end
	}

	/**
	 * Defines the order of rotation axes.
	 * 
	 * Determines the sequence in which rotations are applied around the X, Y, and Z axes.
	 * Different orders can produce different final orientations due to rotational dependency.
	 * 
	 * Default: `Z_Y_X` (Rotates around the X-axis last).
	 */
	public static var ROTATION_ORDER:RotationOrder = Z_Y_X;

	/**
	 * Optimizes the rendering of hold arrows.
	 * 
	 * Theoretically, this makes calculations twice as fast by reducing redundant computations.
	 * However, it is not recommended for complex modcharts, as it may cause holds to look incorrect,
	 * especially when rotation or complex paths are applied.
	 * 
	  	 * Default: `false` (Regular hold rendering using the unit circle).
	 */
	public static var OPTIMIZE_HOLDS(get, never):Bool;
	static inline function get_OPTIMIZE_HOLDS():Bool {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.optimizeHolds;
		#else
		return ClientPrefs.optimizeHolds;
		#end
	}

	/**
	 * Scales the Z-axis values.
	 * 
	 * This value is used to multiply the Z coordinate, effectively scaling depth.
	 * A higher value increases the perceived depth, while a lower value flattens it.
	 * 
	 * Default: `1` (No scaling applied).
	 */
	public static var Z_SCALE(get, never):Float;
	static inline function get_Z_SCALE():Float {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.zScale;
		#else
		return ClientPrefs.zScale;
		#end
	}

	/**
	 * Ignores or renders the arrow path lines.
	 * 
	 * When enabled, performance will be affected
	 * due to path computation. (and Cairo graphics :sob::sob::sob:)
	 */
	public static var RENDER_ARROW_PATHS(get, never):Bool;
	static inline function get_RENDER_ARROW_PATHS():Bool {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.renderArrowPaths;
		#else
		return ClientPrefs.renderArrowPaths;
		#end
	}

	/**
	 * Applies the `visuals` function from modifiers to
	 * give the arrow path more style by changing its color,
	 * scale, and alpha.
	 * NOTE: Arrow paths also have thickness and color properties,
	 * but they are not affected by the arrow's alpha and color.
	 */
	public static var STYLED_ARROW_PATHS(get, never):Bool;
	static inline function get_STYLED_ARROW_PATHS():Bool {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.styledArrowPaths;
		#else
		return ClientPrefs.styledArrowPaths;
		#end
	}

	/**
	 * Scales the hold end size.
	 */
	public static var HOLD_END_SCALE(get, never):Float;
	static inline function get_HOLD_END_SCALE():Float {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.holdEndScale;
		#else
		return ClientPrefs.holdEndScale;
		#end
	}

	/**
	 * Boundary margin for arrow path rendering (pixels outside screen).
	 * Paths outside this boundary won't be rendered for better performance.
	 */
	public static var ARROW_PATH_BOUNDARY(get, never):Int;
	static inline function get_ARROW_PATH_BOUNDARY():Int {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.arrowPathBoundary;
		#else
		return 300;
		#end
	}

	/**
	 * Enables hold graphics caching for better performance.
	 */
	public static var HOLD_CACHE_ENABLED(get, never):Bool;
	static inline function get_HOLD_CACHE_ENABLED():Bool {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.holdCacheEnabled;
		#else
		return true;
		#end
	}

	/**
	 * Number of pre-calculated alpha variants for hold cache (10-30).
	 */
	public static var HOLD_ALPHA_DIVISIONS(get, never):Int;
	static inline function get_HOLD_ALPHA_DIVISIONS():Int {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.holdAlphaDivisions;
		#else
		return 20;
		#end
	}

	/**
	 * Extension for hold segments to prevent visual gaps.
	 */
	public static var SEAMLESS_HOLD_EXTENSION(get, never):Float;
	static inline function get_SEAMLESS_HOLD_EXTENSION():Float {
		#if (FM_ENGINE_VERSION >= "0.7")
		return ClientPrefs.data.seamlessHoldExtension;
		#else
		return 2.0;
		#end
	}
}
