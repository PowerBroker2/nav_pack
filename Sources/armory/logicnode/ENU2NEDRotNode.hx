package armory.logicnode;

import kha.FastFloat;
import iron.math.Vec4;
import iron.math.Quat;

class ENU2NEDRotNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var x_rot_axis:  Vec4      =  new Vec4(1, 0, 0, 0);
		var x_rot_angle: FastFloat = -Math.PI;
		var x_rot:       Quat      =  new Quat().fromAxisAngle(x_rot_axis, x_rot_angle);

		var z_rot_axis:  Vec4      =  new Vec4(0, 0, 1, 0);
		var z_rot_angle: FastFloat = -Math.PI / 2.0;
		var z_rot:       Quat      =  new Quat().fromAxisAngle(z_rot_axis, z_rot_angle);

		var rot: Quat = new Quat().mult(x_rot).mult(z_rot);

		return rot;
	}
}
