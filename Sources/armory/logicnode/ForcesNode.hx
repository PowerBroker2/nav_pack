package armory.logicnode;

import iron.math.Vec4;

class ForcesNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://en.wikipedia.org/wiki/Drag_equation

		var rho:  Float = inputs[0].get();
		var v:    Float = inputs[1].get();
		var Sref: Float = inputs[2].get();
		var Cf:   Vec4  = inputs[3].get();
		if ((rho == null) || (v == null) || (Sref == null) || (Cf == null)) return 0.0;

		var forces: Vec4 = new Vec4();
		
		forces.x = 0.5 * rho * Math.pow(v, 2) * Sref * Cf[0];
		forces.y = 0.5 * rho * Math.pow(v, 2) * Sref * Cf[1];
		forces.z = 0.5 * rho * Math.pow(v, 2) * Sref * Cf[2];

		return forces;
	}
}
