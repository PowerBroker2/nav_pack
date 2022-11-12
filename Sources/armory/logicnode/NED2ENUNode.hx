package armory.logicnode;

import iron.math.Vec4;
import iron.math.Quat;
import iron.math.Mat4;

class NED2ENUNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var NED: Vec4 = inputs[0].get();

		var ENU: Vec4 = new Vec4();
		ENU.x =  NED.y;
		ENU.y =  NED.x;
		ENU.z = -NED.z;
		ENU.w =  0;

		return ENU;
	}
}
