package armory.logicnode;

import iron.math.Mat4;
import iron.math.Vec4;
import iron.math.Quat;

class RotVecNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var in_vec:   Vec4 = inputs[0].get();
		var rotation: Quat = inputs[1].get();
		if ((in_vec == null) || (rotation == null)) return 0.0;

		var out_vec: Vec4 = new Vec4(in_vec.x,
									 in_vec.y,
									 in_vec.z,
									 in_vec.w);
		out_vec = out_vec.applyQuat(rotation);
		
		return out_vec;
	}
}
