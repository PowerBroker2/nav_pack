package armory.logicnode;

import iron.math.Vec4;

class GravityVecNode extends LogicNode
{
	var G: Float = 6.6743015 * Math.pow(10, −11);

	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://en.wikipedia.org/wiki/Gravity

		var planet_m:  Float = inputs[0].get();
		var vehicle_m: Float = inputs[1].get();
		var ECEF:      Vec4  = inputs[2].get();
		if ((planet_m == null) || (vehicle_m == null) || (ECEF == null)) return 0.0;

		var mag: Float = G * planet_m * vehicle_m / Math.pow(ECEF.length(), 2);

		var gravity: Vec4 = ECEF.normalize();
		gravity = gravity.mult(-mag);
		
		return gravity;
	}
}
