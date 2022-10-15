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
		// https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation

		var in_vec:   Vec4 = inputs[0].get();
		var rotation: Quat = inputs[1].get();
		if ((in_vec == null) || (rotation == null)) return 0.0;

		in_vec.w = 0;
		rotation = rotation.normalize();

		var in_vec_quat: Quat = new Quat();
		in_vec_quat.x = in_vec.x;
		in_vec_quat.y = in_vec.y;
		in_vec_quat.z = in_vec.z;
		in_vec_quat.w = in_vec.w;

		var rotation_inv: Quat = new Quat();
		rotation_inv.x = -rotation.x;
		rotation_inv.y = -rotation.y;
		rotation_inv.z = -rotation.z;
		rotation_inv.w =  rotation.w;

		var out_vec_quat: Quat = rotation_inv.mult(rotation.mult(in_vec_quat));

		var out_vec: Vec4 = new Vec4();
		out_vec.x = out_vec_quat.x;
		out_vec.y = out_vec_quat.y;
		out_vec.z = out_vec_quat.z;
		out_vec.w = 0;
		
		return out_vec;
	}
}
