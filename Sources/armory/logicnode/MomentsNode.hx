package armory.logicnode;

import iron.math.Vec4;

class MomentsNode extends LogicNode
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
		var Cm:   Vec4  = inputs[3].get();
		if ((rho == null) || (v == null) || (Sref == null) || (Cm == null)) return 0.0;

		var moments: Vec4 = new Vec4();
		
		moments.x = 0.5 * rho * Math.pow(v, 2) * Sref * Cm.x;
		moments.y = 0.5 * rho * Math.pow(v, 2) * Sref * Cm.y;
		moments.z = 0.5 * rho * Math.pow(v, 2) * Sref * Cm.z;

		return moments;
	}
}
