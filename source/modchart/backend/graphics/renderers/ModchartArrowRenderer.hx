package modchart.backend.graphics.renderers;

final matrix:Matrix = new Matrix();
final fMatrix:FlxMatrix = new FlxMatrix();
final rotationVector = new Vector3();
final helperVector = new Vector3();

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
final class ModchartArrowRenderer extends ModchartRenderer<FlxSprite> {
	inline private function getGraphicVertices(planeWidth:Float, planeHeight:Float, flipX:Bool, flipY:Bool) {
		var x1 = flipX ? planeWidth : -planeWidth;
		var x2 = flipX ? -planeWidth : planeWidth;
		var y1 = flipY ? planeHeight : -planeHeight;
		var y2 = flipY ? -planeHeight : planeHeight;

		return [
			// top left
			x1,
			y1,
			// top right
			x2,
			y1,
			// bottom left
			x1,
			y2,
			// bottom right
			x2,
			y2
		];
	}

	var __lastOrient:Float = 0;
	var __lastC2:Float = 0;
	var __lastPlayer:Int = -1;

	override public function prepare(arrow:FlxSprite) {
		if (arrow.alpha <= 0)
			return;

		// Validar que el sprite tiene frames válidos antes de procesarlo
		if (arrow.frame == null || arrow.frame.frame == null) {
			return; // Skip sprites sin frames válidos (ej: SustainSplash con makeGraphic fallback)
		}

		final arrowPosition = helperVector;

		final player = Adapter.instance.getPlayerFromArrow(arrow);

		// setup the position
		var arrowTime = Adapter.instance.getTimeFromArrow(arrow);
		var songPos = Adapter.instance.getSongPosition();
		var arrowDiff = arrowTime - songPos;

		final canUseLast = player == __lastPlayer;

		final centered2 = canUseLast ? __lastC2 : (__lastC2 = instance.getPercent('centered2', player));
		final orient = canUseLast ? __lastOrient : (__lastOrient = instance.getPercent('orient', player));

		// apply centered 2 (aka centered path)
		if (Adapter.instance.isTapNote(arrow)) {
			arrowDiff += FlxG.height * 0.25 * centered2;
		} else {
			arrowTime = songPos + (FlxG.height * 0.25 * centered2);
			arrowDiff = arrowTime - songPos;
		}
		var arrowData:ArrowData = {
			hitTime: arrowTime,
			distance: arrowDiff,
			lane: Adapter.instance.getLaneFromArrow(arrow),
			player: player,
			isTapArrow: Adapter.instance.isTapNote(arrow)
		};

		arrowPosition.setTo(Adapter.instance.getDefaultReceptorX(arrowData.lane, arrowData.player) + Manager.ARROW_SIZEDIV2,
			Adapter.instance.getDefaultReceptorY(arrowData.lane, arrowData.player) + Manager.ARROW_SIZEDIV2, 0);

		final output = instance.modifiers.getPath(arrowPosition, arrowData);
		arrowPosition.copyFrom(output.pos.clone());

		// internal mods
		if (orient != 0) {
			final nextOutput = instance.modifiers.getPath(new Vector3(Adapter.instance.getDefaultReceptorX(arrowData.lane, arrowData.player)
				+ Manager.ARROW_SIZEDIV2,
				Adapter.instance.getDefaultReceptorY(arrowData.lane, arrowData.player)
				+ Manager.ARROW_SIZEDIV2),
				arrowData, 1, false, true);
			final thisPos = output.pos;
			final nextPos = nextOutput.pos;

			output.visuals.angleZ += FlxAngle.wrapAngle((-90 + (Math.atan2(nextPos.y - thisPos.y, nextPos.x - thisPos.x) * FlxAngle.TO_DEG)) * orient);
		}

		__lastPlayer = player;

		// prepare the instruction for drawing
		final projectionDepth = arrowPosition.z;
		final depth = projectionDepth;

		var depthScale = 1 / depth;
		var planeWidth = arrow.frame.frame.width * arrow.scale.x * .5;
		var planeHeight = arrow.frame.frame.height * arrow.scale.y * .5;

		arrow._z = (depth - 1) * 1000;

		var planeVertices = getGraphicVertices(planeWidth, planeHeight, arrow.flipX, arrow.flipY);
		var projectionZ:haxe.ds.Vector<Float> = new haxe.ds.Vector(Math.ceil(planeVertices.length / 2));

		var vertPointer = 0;
		@:privateAccess do {
			rotationVector.setTo(planeVertices[vertPointer], planeVertices[vertPointer + 1], 0);

			// The result of the vert rotation
			var rotation = ModchartUtil.rotate3DVector(rotationVector, output.visuals.angleX, output.visuals.angleY,
				ModchartUtil.getFrameAngle(arrow) + output.visuals.angleZ + arrow.angle);

			// apply skewness
			if (output.visuals.skewX != 0 || output.visuals.skewY != 0) {
				matrix.identity();

				matrix.b = ModchartUtil.tan(output.visuals.skewY * FlxAngle.TO_RAD);
				matrix.c = ModchartUtil.tan(output.visuals.skewX * FlxAngle.TO_RAD);

				rotation.x = matrix.__transformX(rotation.x, rotation.y);
				rotation.y = matrix.__transformY(rotation.x, rotation.y);
			}
			rotation.x = rotation.x * depthScale * output.visuals.scaleX;
			rotation.y = rotation.y * depthScale * output.visuals.scaleY;

			var view = new Vector3(rotation.x + arrowPosition.x, rotation.y + arrowPosition.y, rotation.z);
			if (Config.CAMERA3D_ENABLED)
				view = instance.camera3D.applyViewTo(view);
			view.z *= 0.001 * Config.Z_SCALE;

			// The result of the perspective projection of rotation
			final projection = this.projection.transformVector(view);

			planeVertices[vertPointer] = projection.x;
			planeVertices[vertPointer + 1] = projection.y;

			// stores depth from this vert to use it for perspective correction on uv's
			projectionZ[Math.floor(vertPointer / 2)] = Math.max(0.0001, projection.z);

			vertPointer = vertPointer + 2;
		} while (vertPointer < planeVertices.length);

        // @formatter:off
		// this is confusing af
		var vertices = new DrawData<Float>(12, true, [
			// triangle 1
			planeVertices[0], planeVertices[1], // top left
			planeVertices[2], planeVertices[3], // top right
			planeVertices[6], planeVertices[7], // bottom left
			// triangle 2
			planeVertices[0], planeVertices[1], // top right
			planeVertices[4], planeVertices[5], // top left
			planeVertices[6], planeVertices[7] // bottom right
		]);
		final uvRectangle = arrow.frame.uv;
		var uvData = new DrawData<Float>(18, true, [
			#if (flixel >= "6.1.0")
			// uv for triangle 1
			uvRectangle.left, uvRectangle.right,  1 / projectionZ[0], // top left
			uvRectangle.top,  uvRectangle.right,  1 / projectionZ[1], // top right
			uvRectangle.top,  uvRectangle.bottom, 1 / projectionZ[3], // bottom left
			// uv for triangle 2
			uvRectangle.left, uvRectangle.right,  1 / projectionZ[0], // top right
			uvRectangle.left, uvRectangle.bottom, 1 / projectionZ[2], // top left
			uvRectangle.top,  uvRectangle.bottom, 1 / projectionZ[3]  // bottom right
			#else
			// uv for triangle 1
			uvRectangle.x,     uvRectangle.y,      1 / projectionZ[0], // top left
			uvRectangle.width, uvRectangle.y,      1 / projectionZ[1], // top right
			uvRectangle.width, uvRectangle.height, 1 / projectionZ[3], // bottom left
			// uv for triangle 2
			uvRectangle.x,      uvRectangle.y,      1 / projectionZ[0], // top right
			uvRectangle.x,      uvRectangle.height, 1 / projectionZ[2], // top left
			uvRectangle.width,  uvRectangle.height, 1 / projectionZ[3]  // bottom right
			#end
		]);
        // @formatter:on
		final absGlow = output.visuals.glow * 255;
		final negGlow = 1 - output.visuals.glow;
		var color = new ColorTransform(negGlow, negGlow, negGlow, arrow.alpha * output.visuals.alpha, Math.round(output.visuals.glowR * absGlow),
			Math.round(output.visuals.glowG * absGlow), Math.round(output.visuals.glowB * absGlow));

		// make the instruction
		var newInstruction:FMDrawInstruction = {};
		newInstruction.item = arrow;
		newInstruction.vertices = vertices;
		newInstruction.uvt = uvData;
		newInstruction.indices = new Vector<Int>(vertices.length, true, [for (i in 0...vertices.length) i]);
		newInstruction.colorData = [color];
		queue[count] = newInstruction;

		count++;
	}

	override public function shift() {
		__drawInstruction(queue[postCount++]);
	}

	private function __drawInstruction(instruction:FMDrawInstruction) {
		if (instruction == null)
			return;

		final item = instruction.item;
		final cameras = ModchartUtil.resolveCameras(item);

		@:privateAccess
		for (camera in cameras) {
			final cTransform = instruction.colorData[0];
			cTransform.alphaMultiplier *= camera.alpha;

			camera.drawTriangles(item.graphic, instruction.vertices, instruction.indices, instruction.uvt, new Vector<Int>(), null, item.blend, false,
				item.antialiasing, cTransform, item.shader);
		}
	}
}
