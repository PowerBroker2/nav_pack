package armory.logicnode;

import iron.math.Vec4;
import iron.math.Quat;
import iron.math.Mat4;

class NED2ECEFNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var a:       Float = inputs[0].get();
		var ecc:     Float = inputs[1].get();
		var NED:     Vec4  = inputs[2].get();
		var LLA_ref: Vec4  = inputs[3].get();
		if ((a == null) || (ecc == null) || (NED == null) || (LLA_ref == null)) return 0.0;

		var ecc_sqrd: Float = Math.pow(ecc, 2);

		var lat_ref: Float = LLA_ref.x * (Math.PI  / 180.0);
		var lon_ref: Float = LLA_ref.y * (Math.PI  / 180.0);
		var alt_ref: Float = LLA_ref.z;

		var Rns: Float = a / Math.sqrt(1 - (ecc_sqrd * Math.pow(Math.sin(lat_ref), 2)));

		var ECEF_ref: Vec4 = new Vec4();
		ECEF_ref.x = (Rns + alt_ref) * Math.cos(lat_ref) * Math.cos(lon_ref);
		ECEF_ref.y = (Rns + alt_ref) * Math.cos(lat_ref) * Math.sin(lon_ref);
		ECEF_ref.z = ((1 - ecc_sqrd) * Rns + alt_ref) * Math.sin(lat_ref);

		var NED_R_ECEF: Mat4 = Mat4.identity();
		NED_R_ECEF._00 = -Math.sin(lat_ref) * Math.cos(lon_ref);
		NED_R_ECEF._01 = -Math.sin(lat_ref) * Math.sin(lon_ref);
		NED_R_ECEF._02 =  Math.cos(lat_ref);
		NED_R_ECEF._10 = -Math.sin(lon_ref);
		NED_R_ECEF._11 =  Math.cos(lon_ref);
		NED_R_ECEF._12 =  0;
		NED_R_ECEF._20 = -Math.cos(lat_ref) * Math.cos(lon_ref);
		NED_R_ECEF._21 = -Math.cos(lat_ref) * Math.sin(lon_ref);
		NED_R_ECEF._22 = -Math.sin(lat_ref);

		var rot: Quat = new Quat().fromMat(NED_R_ECEF.transpose()).normalize();

		var rot_inv: Quat = new Quat();
		rot_inv.x = -rot.x;
		rot_inv.y = -rot.y;
		rot_inv.z = -rot.z;
		rot_inv.w =  rot.w;

		var NED_quat: Quat = new Quat();
		NED_quat.x = NED.x;
		NED_quat.y = NED.y;
		NED_quat.z = NED.z;
		NED_quat.w = 0;

		var rot_NED_quat: Quat = rot_inv.mult(rot.mult(NED_quat));

		var rot_NED: Vec4 = new Vec4();
		rot_NED.x = rot_NED_quat.x;
		rot_NED.y = rot_NED_quat.y;
		rot_NED.z = rot_NED_quat.z;
		rot_NED.w = 0;

		var ECEF: Vec4 = new Vec4();
		ECEF.x = ECEF_ref.x + rot_NED.x;
		ECEF.y = ECEF_ref.y + rot_NED.y;
		ECEF.z = ECEF_ref.z + rot_NED.z;
		ECEF.w = 0;

		return ECEF;
	}
}
