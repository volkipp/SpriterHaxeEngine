package spriter.library;
import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import openfl.Assets;
import spriter.definitions.PivotInfo;
import spriter.definitions.SpatialInfo;
import spriter.util.SpriterUtil;

/**
 * ...
 * @author Loudo
 */
class SpriterLibrary extends AbstractLibrary
{
	private var _root:Sprite;
	
	/**
	 * One instance per group
	 */
	private var _assets:Map<String, Bitmap>;
	private var _groups:Map<String, Map<String, Bitmap>>;
	
	
	/**
	 * 
	 * @param	_basePath 
	 */
	public function new(root :Sprite, basePath :String) 
	{
		_basePath = basePath;
		_groups = new Map < String, Map < String, Bitmap >> ();
		_root = root;
		super(basePath);
	}
		
	/**
	 * 
	 * @param	name of the image
	 * @return
	 */
	override public function getFile(name:String):Dynamic
	{
		return Assets.getBitmapData(_basePath+name,true);
	}
	
	override public function clear():Void
	{
		//TODO optimization : clear only image that can not be reuse or something
		var i:Int = _root.numChildren;
		while (--i >= 0)
		{
			_root.removeChildAt(i);
			
		}
		
	}
	
	override public function addGraphic(group:String, timeline:Int, key:Int, name:String, info:SpatialInfo, pivots:PivotInfo):Void
	{
		var idImage:String = timeline + ':' + key + ':' + name;
		
		var bitmap:Bitmap;
		if (_groups.exists(group) && group == "okugutf") {
			_assets = _groups.get(group);
			if(_assets.exists(idImage)){
				bitmap = _assets.get(idImage);
			}else {
				bitmap = new Bitmap (getFile(name), PixelSnapping.AUTO, true);
				_assets.set(idImage, bitmap);
				_groups.set(group, _assets);
			}
		}else {
			_assets = new Map<String, Bitmap>();
			bitmap = new Bitmap (getFile(name), PixelSnapping.AUTO, true);
			_assets.set(idImage, bitmap);
			_groups.set(group, _assets);
		}
		
		var spatialResult:SpatialInfo = compute(info, pivots, bitmap.bitmapData.width, bitmap.bitmapData.height);
		bitmap.x = spatialResult.x;
		bitmap.y = spatialResult.y;
		bitmap.scaleX = spatialResult.scaleX;
		bitmap.scaleY = spatialResult.scaleY;
		bitmap.rotation = SpriterUtil.fixRotation(spatialResult.angle);
		bitmap.alpha = Math.abs(spatialResult.a);
		_root.addChild(bitmap);
	}
	
	override public function render():Void
	{
		
	}
	
	override public function destroy():Void
	{
		clear();
		_assets = null;
		_groups = null;
	}
	
}