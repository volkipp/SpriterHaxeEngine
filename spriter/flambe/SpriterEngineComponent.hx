package spriter.flambe;

import flambe.Component;
import spriter.engine.SpriterEngine;
import spriter.library.AbstractLibrary;

/**
 * Provides a Flambe-style component wrapper for the Spriter Engine.
 * 
 * @author Quinn Hoener
 */
class SpriterEngineComponent extends Component
{
	// Keeps track of the Spriter Engine.
	public var engine:SpriterEngine;

	/**
	 * Same parameters to start the Spriter Engine.
	 * @param  scml_str  [description]
	 * @param  library   Should be a FlambeLibrary since this is meant for Flambe usage. 
	 * @param  frameRate [description]
	 * @return           [description]
	 */
	public function new(scml_str:String, library:AbstractLibrary, frameRate:Int = 60)
	{
		engine = new SpriterEngine(scml_str, library, frameRate);
	}

	override public function onUpdate(dt:Float):Void
	{
		// Multiply from seconds to milliseconds.
		engine.update(Math.floor(dt * 1000));
	}
}