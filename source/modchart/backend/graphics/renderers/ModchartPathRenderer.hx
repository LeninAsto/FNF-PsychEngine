package modchart.backend.graphics.renderers;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxDestroyUtil;
import openfl.geom.ColorTransform;

var pathVector = new Vector3();

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
final class ModchartPathRenderer extends ModchartRenderer<FlxSprite> {
	var __lineGraphic:FlxGraphic;
	var __lastDivisions:Int = -1;

	var uvt:DrawData<Float>;
	var indices:DrawData<Int>;

	public function updateTris(divisions:Int) {
		final segs = divisions - 1;
		if (divisions != __lastDivisions) {
			uvt = new DrawData<Float>(segs * 12, true);
			indices = new DrawData<Int>(segs * 6, true);
			var ui = 0, ii = 0, vertCount = 0;
			for (div in 0...divisions) {
				for (_ in 0...4) {
					uvt.set(ui++, 0);
					uvt.set(ui++, 0);
					uvt.set(ui++, 1);
				}

				// indices
				indices.set(ii++, vertCount);
				indices.set(ii++, vertCount + 1);
				indices.set(ii++, vertCount + 2);
				indices.set(ii++, vertCount + 1);
				indices.set(ii++, vertCount + 3);
				indices.set(ii++, vertCount + 2);

				vertCount += 4;
			}
		}

		__lastDivisions = divisions;
	}

	public function new(instance:PlayField) {
		super(instance);

		__lineGraphic = FlxG.bitmap.create(10, 10, 0xFFFFFFFF);
	}

	var __lastPlayer:Int = -1;
	var __lastAlpha:Float = 0;
	var __lastThickness:Float = 0;

	// the entry sprite should be A RECEPTOR / STRUM !!
	override public function prepare(item:FlxSprite) {
		final lane = Adapter.instance.getLaneFromArrow(item);
		final fn = Adapter.instance.getPlayerFromArrow(item);

		final canUseLast = fn == __lastPlayer;

		final pathAlpha = canUseLast ? __lastAlpha : instance.getPercent('arrowPathAlpha', fn);
		final pathThickness = canUseLast ? __lastThickness : instance.getPercent('arrowPathThickness', fn);

		if (pathAlpha <= 0 || pathThickness <= 0)
			return;

		__lastAlpha = pathAlpha;
		__lastThickness = pathThickness;
		__lastPlayer = fn;

		final divisions = Std.int(20 * Config.ARROW_PATHS_CONFIG.RESOLUTION);
		final limit = 1500 + Config.ARROW_PATHS_CONFIG.LENGTH;
		final interval = limit / divisions;
		final songPos = Adapter.instance.getSongPosition();

		final segs = divisions - 1;
		final vertices = new DrawData<Float>(segs * 8, true);

		var vi = 0, vertCount = 0;

		var lastOutput:ModifierOutput = null;
		pathVector.setTo(Adapter.instance.getDefaultReceptorX(lane, fn), Adapter.instance.getDefaultReceptorY(lane, fn), 0);
		pathVector.incrementBy(ModchartUtil.getHalfPos());

		final colored = Config.ARROW_PATHS_CONFIG.APPLY_COLOR;
		final applyAlpha = Config.ARROW_PATHS_CONFIG.APPLY_ALPHA;

		final transforms:Array<ColorTransform> = [];
		var tID:Int = 0;
		transforms.resize(segs);

		for (index in 0...divisions) {
			var hitTime = -500 + interval * index;

			var output = instance.modifiers.getPath(pathVector.clone(), {
				hitTime: songPos + hitTime,
				distance: hitTime,
				lane: lane,
				player: fn,
				isTapArrow: true
			});

			if (lastOutput != null) {
				final p0 = lastOutput;
				final p1 = output;

				final pos0 = p0.pos;
				final pos1 = p1.pos;

				final dx = pos1.x - pos0.x;
				final dy = pos1.y - pos0.y;
				final len = Math.sqrt(dx * dx + dy * dy);
				final nx = -dy / len;
				final ny = dx / len;

				final t0 = (pathThickness * (Config.ARROW_PATHS_CONFIG.APPLY_SCALE ? p1.visuals.scaleX : 1) * (Config.ARROW_PATHS_CONFIG.APPLY_DEPTH ? 1 / pos0.z : 1)) * 0.5;
				final t1 = (pathThickness * (Config.ARROW_PATHS_CONFIG.APPLY_SCALE ? p1.visuals.scaleX : 1) * (Config.ARROW_PATHS_CONFIG.APPLY_DEPTH ? 1 / pos1.z : 1)) * 0.5;

				final a1x = pos0.x + nx * t0;
				final a1y = pos0.y + ny * t0;
				final a2x = pos0.x - nx * t0;
				final a2y = pos0.y - ny * t0;

				final b1x = pos1.x + nx * t1;
				final b1y = pos1.y + ny * t1;
				final b2x = pos1.x - nx * t1;
				final b2y = pos1.y - ny * t1;

				// vertices
				vertices.set(vi++, a1x);
				vertices.set(vi++, a1y);
				vertices.set(vi++, a2x);
				vertices.set(vi++, a2y);
				vertices.set(vi++, b1x);
				vertices.set(vi++, b1y);
				vertices.set(vi++, b2x);
				vertices.set(vi++, b2y);

				final glow = (colored ? p0.visuals.glow : 0);
				final fAlpha = (applyAlpha ? p0.visuals.alpha : 1);
				final negGlow = 1 - glow;
				final absGlow = glow * 255;
				transforms[tID++] = new ColorTransform(negGlow, negGlow, negGlow, fAlpha * pathAlpha, Math.round(p0.visuals.glowR * absGlow),
					Math.round(p0.visuals.glowG * absGlow), Math.round(p0.visuals.glowB * absGlow));

				vertCount += 4;
			}

			lastOutput = output;
		}

		updateTris(divisions);

		var newInstruction:FMDrawInstruction = {};
		newInstruction.extra = [vertices, indices, uvt, transforms];
		queue[count++] = newInstruction;
	}

	override public function shift() {
		if (count == 0 || queue.length <= 0)
			return;

		final cameras = Adapter.instance.getArrowCamera();
		for (instruction in queue) {
			if (instruction == null)
				continue;
			final vertices:DrawData<Float> = cast instruction.extra[0];
			final indices:DrawData<Int> = cast instruction.extra[1];
			final uvt:DrawData<Float> = cast instruction.extra[2];
			final transforms:Array<ColorTransform> = cast instruction.extra[3];

			for (camera in cameras) {
				var item = camera.startTrianglesBatch(__lineGraphic, false, true, NORMAL, true);
				@:privateAccess
				item.addGradientTriangles(vertices, indices, uvt, null, camera._bounds, transforms);
			}
		}
	}

	override function dispose() {
		__lineGraphic = FlxDestroyUtil.destroy(__lineGraphic);
	}

	inline static final ARROW_PATH_BOUNDARY_OFFSET:Float = 300;
}
