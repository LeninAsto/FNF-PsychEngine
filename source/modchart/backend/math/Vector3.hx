package modchart.backend.math;

import openfl.geom.Vector3D;

/**
 * Extended version of `Vector3D` with additional operators for convenience.
 * 
 * This abstract class provides operator overloading for arithmetic operations,
 * allowing for more intuitive vector math while maintaining compatibility
 * with OpenFL's `Vector3D`.
 */
@:keep
@:forward
abstract Vector3(Vector3D) from Vector3D to Vector3D {
	/**
	 * Creates a new `Vector3` instance.
	 * @param x The X component of the vector.
	 * @param y The Y component of the vector.
	 * @param z The Z component of the vector.
	 * @param w The W component of the vector (default: 0).
	 */
	@:keep
	public function new(x:Float = 0., y:Float = 0., z:Float = 0., w:Float = 0.) {
		this = new Vector3D(x, y, z, w);
	}

	/**
	 * Returns a new vector resulting from the addition of two vectors.
	 */
	@:op(A + B)
	inline public function __plusOp(addition:Vector3):Vector3 {
		return new Vector3(this.x + addition.x, this.y + addition.y, this.z + addition.z);
	}

	/**
	 * Returns a new vector resulting from the subtraction of two vectors.
	 */
	@:op(A - B)
	inline public function __minusOp(subtraction:Vector3):Vector3 {
		return new Vector3(this.x - subtraction.x, this.y - subtraction.y, this.z - subtraction.z);
	}

	/**
	 * Returns a new vector resulting from the component-wise multiplication of two vectors.
	 */
	@:op(A * B)
	inline public function __multOp(mult:Vector3):Vector3 {
		return new Vector3(this.x * mult.x, this.y * mult.y, this.z * mult.z);
	}

	/**
	 * Returns a new vector resulting from the component-wise division of two vectors.
	 */
	@:op(A / B)
	inline public function __divOp(div:Vector3):Vector3 {
		return new Vector3(this.x / div.x, this.y / div.y, this.z / div.z);
	}

	/**
	 * Adds another vector to this vector component-wise.
	 * @return This modified vector.
	 */
	@:op(A += B)
	inline public function __add(addition:Vector3):Vector3 {
		this.x += addition.x;
		this.y += addition.y;
		this.z += addition.z;
		return this;
	}

	/**
	 * Subtracts another vector from this vector component-wise.
	 * @return This modified vector.
	 */
	@:op(A -= B)
	inline public function __subtract(subtraction:Vector3):Vector3 {
		this.x -= subtraction.x;
		this.y -= subtraction.y;
		this.z -= subtraction.z;
		return this;
	}

	/**
	 * Multiplies this vector by another vector component-wise.
	 * @return This modified vector.
	 */
	@:op(A *= B)
	inline public function __multiply(mult:Vector3):Vector3 {
		this.x *= mult.x;
		this.y *= mult.y;
		this.z *= mult.z;
		return this;
	}

	/**
	 * Divides this vector by another vector component-wise.
	 * @return This modified vector.
	 */
	@:op(A /= B)
	inline public function __divide(div:Vector3):Vector3 {
		this.x /= div.x;
		this.y /= div.y;
		this.z /= div.z;
		return this;
	}

	/**
	 * Linearly interpolates between this vector and another vector.
	 * @param target The target vector to interpolate towards.
	 * @param alpha The interpolation factor (0 = this vector, 1 = target vector).
	 * @return A new interpolated vector.
	 */
	public function interpolate(target:Vector3, alpha:Float, ?vector:Vector3):Vector3 {
		if (vector == null)
			vector = new Vector3();

        // @formatter:off
        vector.setTo(
            this.x + (target.x - this.x) * alpha,
            this.y + (target.y - this.y) * alpha,
            this.z + (target.z - this.z) * alpha
        );
        // @formatter:on
		return vector;
	}
}
