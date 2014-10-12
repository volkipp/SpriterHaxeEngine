package spriter.flambe;

import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Entity;
import spriter.definitions.ScmlObject;
import spriter.definitions.SpatialInfo;
import spriter.engine.Spriter;
import spriter.library.FlambeLibrary;


/**
 * Used in Flambe as the root controller for the Spriter animations.
 *
 * @author Quinn Hoener
 */
class SpriterMovie extends Component
{
	// The Flambe library that updates the graphics. 
	private var _library 	:FlambeLibrary;
	// The spriter object to update.
	private var _spriter 	:Spriter;
	// The AssetPack with all the assets.
	private var _pack 		:AssetPack;
	// The base path to get assets from.
	private var _basePath	:String;
	// The scml object this is using. 
	private var _scml 		:ScmlObject;
	// The root entity to render to.
	private var _container 	:Entity;
	

	public function new(pack:AssetPack, scmlFilePath:String, spriterEntityName:String)
	{
		_pack = pack;
		
		// Get the base path.
		var aPath:Array<String> = scmlFilePath.split("/");
		aPath.pop();
		_basePath = aPath.join("/");

		// Get the SCML Object.
		var scml_str:String = _pack.getFile(scmlFilePath).toString();
		_scml = new ScmlObject(Xml.parse(scml_str));

		_container = new Entity().add( new Sprite() );
		// Setup the library for rendering. 
		_library = new FlambeLibrary(_container, _pack, _basePath);

		// Create the Spriter element. 
		_spriter = new Spriter(spriterEntityName, _scml, _library, new SpatialInfo());
	}

	override public function onStart():Void
	{
		owner.addChild(_container);
	}

	override public function onUpdate(dt:Float):Void
	{
		_library.clear(); // Won't need this in future. 

		_spriter.advanceTime(Std.int(dt * 1000));
	}

	/**
	 * Chainable method for playing an animation. 
	 * @param  sAnimName Name of the animation to play. 
	 * @return           [description]
	 */
	public function playAnim(sAnimName:String):SpriterMovie
	{
		_spriter.playAnim(sAnimName);
		return this;
	}
}