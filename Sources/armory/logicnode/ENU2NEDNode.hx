package armory.logicnode;

import iron.math.Vec4;
import iron.math.Quat;
import iron.math.Mat4;

class ENU2NEDNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var ENU: Vec4 = inputs[0].get();

		var NED: Vec4 = new Vec4();
		NED.x =  ENU.y;
		NED.y =  ENU.x;
		NED.z = -ENU.z;
		NED.w =  0;

		return NED;
	}
}
