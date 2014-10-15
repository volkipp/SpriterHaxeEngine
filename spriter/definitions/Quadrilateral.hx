package spriter.definitions;
// import openfl.geom.Point;

/**
 * ...
 * @author Loudo
 */
class Quadrilateral
{
	public var p1:QuadPoint;
	public var p2:QuadPoint;
	public var p3:QuadPoint;
	public var p4:QuadPoint;

	public function new(p1:QuadPoint, p2:QuadPoint, p3:QuadPoint, p4:QuadPoint) 
	{
		this.p1 = p1;
		this.p2 = p2;
		this.p3 = p3;
		this.p4 = p4;
	}
}

class QuadPoint {
	
	/** The x position. */
	public var x :Float;
	/** The y position */
	public var y :Float;

	public function new(?x :Float = 0, ?y :Float = 0):Void
	{
		this.x = x;
		this.y = y;
	}
}