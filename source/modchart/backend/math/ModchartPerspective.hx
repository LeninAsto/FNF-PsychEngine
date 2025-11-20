package modchart.backend.math;

import flixel.FlxG;

/**
 * Represents a perspective projection for modcharts.
 *
 * This class provides a basic perspective transformation based on OpenGL principles.
 * It allows transforming 3D world coordinates into 2D screen space, taking into account
 * field of view (FOV), aspect ratio, and depth scaling.
 *
 * Based on OpenGL tutorial:
 * @see https://ogldev.org/www/tutorial12/tutorial12.html
 */
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
final class ModchartPerspective {
	/**
	 * Distance to the near clipping plane.
	 * Objects closer than this distance will not be rendered.
	 */
	public var near(default, set):Float = 0;

	/**
	 * Distance to the far clipping plane.
	 * Objects farther than this distance will not be rendered.
	 */
	public var far(default, set):Float = 1;

	/**
	 * Field of View (FOV) in radians.
	 * Defines the extent of the observable world projected onto the screen.
	 * 
	 * **NOTE:** This value defaults to 90 degrees (PI / 2).
	 */
	public var fov(default, set):Float;

	/**
	 * Distance range between the near and far clipping planes.
	 * Calculated as `near - far`.
	 */
	public var range(get, never):Float;

	/**
	 * Internal projection components.
	 */
	private var __tanHalfFov:Float = 0;

	private var __depthRange:Float = 1;
	private var __depthScale:Float = 1;
	private var __depthOffset:Float = 0;

	public function new() {
		fov = Math.PI / 2;
		updateProperties();
	}

	private function set_near(value:Float):Float {
		updateProperties();
		return near = value;
	}

	private function set_far(value:Float):Float {
		updateProperties();
		return far = value;
	}

	private function set_fov(value:Float):Float {
		updateProperties();
		return fov = value;
	}

	private function get_range():Float {
		return near - far;
	}

	/**
	 * Updates internal projection properties based on current FOV and depth range.
	 */
	public function updateProperties():Void {
		__tanHalfFov = Math.tan(fov * 0.5);
		__depthRange = 1 / range;
		__depthScale = (near + far) * __depthRange;
		__depthOffset = 2 * near * (far * __depthRange);
	}

	/**
	 * Transforms a 3D vector into 2D screen space using perspective projection.
	 *
	 * @param vector The 3D vector to project.
	 * @param origin Optional origin point for transformation (defaults to screen center).
	 * @return The projected 2D vector.
	 */
	public inline function transformVector(vector:Vector3, ?origin:Null<Vector3>):Vector3 {
		if (origin == null) {
			origin = new Vector3(FlxG.width * 0.5, FlxG.height * 0.5);
		}

		var translation = vector - origin;

		final projectedZ = __depthScale * Math.min(translation.z - 1, 0) + __depthOffset;
		final projectedFov = (__tanHalfFov / projectedZ);

		translation.setTo(translation.x * projectedFov, translation.y * projectedFov, projectedZ);
		return translation += origin;
	}
}
