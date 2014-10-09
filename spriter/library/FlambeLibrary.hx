package spriter.library;

import flambe.asset.AssetPack;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.Texture;
import flambe.Entity;
import flambe.math.FMath;
import flambe.math.Point;
import flambe.math.Matrix;
import spriter.definitions.PivotInfo;
import spriter.definitions.SpatialInfo;
import spriter.util.ColorUtils;
import spriter.util.SpriterUtil;

/**
 * ...
 * @author Loudo, Quinn Hoener
 */
class FlambeLibrary extends AbstractLibrary
{
	
    private var _point 		:Point;
    private var _matrix 	:Matrix;
    private var _pack 		:AssetPack;
    // The root entity that stores all the graphics for this Spriter Library. 
    private var _rootEntity :Entity;
	
	/**
	 * Creates a new Flambe Spriter Library.
	 * @param  entity   The entity to add the graphics to.
	 * @param  pack     AssetPack to load assets from.
	 * @param  basePath The base path to the assets.
	 * @return          [description]
	 */
	public function new(rootEntity:Entity, pack:AssetPack, basePath:String) 
	{
		super(basePath);
		_pack = pack;
        _point = new Point();
        _matrix = new Matrix();
        _rootEntity = rootEntity;
        // _rootEntity = new Entity().add( new Sprite() );
	}
	override public function getFile(name:String):Dynamic
	{
		return null;
	}

	private function getTexture(name:String):Texture
	{
		var aSplitName:Array<String> = name.split(".");
		aSplitName.pop();
		name = aSplitName.join("");
		return _pack.getTexture(_basePath + "/" + name);
	}

	override public function clear():Void
	{
        _rootEntity.disposeChildren();
        _rootEntity.add( new Sprite() );
    }
	override public function addGraphic(group:String, timeline:Int, key:Int, name:String, info:SpatialInfo, pivots:PivotInfo):Void
	{
		var bmp:Texture = getTexture(name);

		var spatialResult:SpatialInfo = compute(info, pivots, bmp.width, bmp.height);
		
		// Setup the Flambe Sprite.		
		var sprite:ImageSprite = new ImageSprite(bmp);
		var localMatrix:Matrix = sprite.getLocalMatrix();
		localMatrix.compose(spatialResult.x, spatialResult.y, spatialResult.scaleX, spatialResult.scaleY, FMath.toRadians(SpriterUtil.fixRotation(spatialResult.angle)));
        // localMatrix.translate(-anchorX._, -anchorY._);

		// sprite.setXY(spatialResult.x, spatialResult.y);
		// sprite.setRotation(SpriterUtil.fixRotation(spatialResult.angle));
		// sprite.setScaleXY(spatialResult.scaleX, spatialResult.scaleY);
		sprite.alpha._ = spatialResult.a;
		
		// Add as new child to the root. 
		_rootEntity.addChild(new Entity().add(sprite));
	}

	override public function render():Void
	{

	}
	override public function destroy():Void
	{
		clear();
		_point = null;
        _matrix = null;
        _pack = null;
        _rootEntity.dispose();
        _rootEntity = null;
	}
	
}