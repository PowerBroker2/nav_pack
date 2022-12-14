package armory.logicnode;

import kha.FastFloat;
import iron.math.Vec4;
import iron.math.Quat;

class CamTrackPtNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var pt_NED:  Vec4  = inputs[0].get();
		var cam_NED: Vec4  = inputs[1].get();
		trace("Reading roll:");
		var roll:    Float = inputs[2].get();
		trace(roll);

		var cam_to_pt_dcs: Vec4 = new Vec4(pt_NED.x - cam_NED.x,
										   pt_NED.y - cam_NED.y,
										   pt_NED.z - cam_NED.z,
										   0).normalize();

		var x_1_rot_axis:  Vec4      = new Vec4(1, 0, 0, 0);
		var x_1_rot_angle: FastFloat = Math.PI / 2.0;
		var x_1_rot:       Quat      = new Quat().fromAxisAngle(x_1_rot_axis, x_1_rot_angle);

		var y_rot_axis:  Vec4      = new Vec4(0, -1, 0, 0);
		var y_rot_angle: FastFloat = Math.atan2(cam_to_pt_dcs.y, cam_to_pt_dcs.x);
		var y_rot:       Quat      = new Quat().fromAxisAngle(y_rot_axis, y_rot_angle);

		var x_2_rot_axis:  Vec4      = new Vec4(-1, 0, 0, 0);
		var x_2_rot_angle: FastFloat = Math.asin(cam_to_pt_dcs.z);
		var x_2_rot:       Quat      = new Quat().fromAxisAngle(x_2_rot_axis, x_2_rot_angle);

		var z_rot_axis:  Vec4      = new Vec4(0, 0, 1, 0);
		var z_rot_angle: FastFloat = roll;
		var z_rot:       Quat      = new Quat().fromAxisAngle(z_rot_axis, z_rot_angle);

		var cam_rot: Quat = new Quat();
		cam_rot = cam_rot.mult(x_1_rot).mult(y_rot).mult(x_2_rot).mult(z_rot);

		trace("Output rotation:");
		trace(cam_rot);
		trace(" ");
		
		return cam_rot;
	}
}
