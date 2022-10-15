package armory.logicnode;

import iron.math.Vec4;
import iron.math.Quat;
import iron.math.Mat4;

class ECEF2NEDNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var a:       Float = inputs[0].get();
		var ecc:     Float = inputs[1].get();
		var ECEF:    Vec4  = inputs[2].get();
		var LLA_ref: Vec4  = inputs[3].get();
		if ((a == null) || (ecc == null) || (ECEF == null) || (LLA_ref == null)) return 0.0;

		var ecc_sqrd: Float = Math.pow(ecc, 2);

		var lat_ref: Float = LLA_ref.x * (Math.PI  / 180.0);
		var lon_ref: Float = LLA_ref.y * (Math.PI  / 180.0);
		var alt_ref: Float = LLA_ref.z;

		var Rns: Float = a / Math.sqrt(1 - (ecc_sqrd * Math.pow(Math.sin(lat_ref), 2)));

		var ECEF_ref: Vec4 = new Vec4();
		ECEF_ref.x = (Rns + alt_ref) * Math.cos(lat_ref) * Math.cos(lon_ref);
		ECEF_ref.y = (Rns + alt_ref) * Math.cos(lat_ref) * Math.sin(lon_ref);
		ECEF_ref.z = ((1 - ecc_sqrd) * Rns + alt_ref) * Math.sin(lat_ref);

		var ECEF_ref_to_ECEF: Vec4 = new Vec4();
		ECEF_ref_to_ECEF.x = ECEF.x - ECEF_ref.x;
		ECEF_ref_to_ECEF.y = ECEF.y - ECEF_ref.y;
		ECEF_ref_to_ECEF.z = ECEF.z - ECEF_ref.z;
		ECEF_ref_to_ECEF.w = 0;

		var ECEF_ref_to_ECEF_quat: Quat = new Quat();
		ECEF_ref_to_ECEF_quat.x = ECEF_ref_to_ECEF.x;
		ECEF_ref_to_ECEF_quat.y = ECEF_ref_to_ECEF.y;
		ECEF_ref_to_ECEF_quat.z = ECEF_ref_to_ECEF.z;
		ECEF_ref_to_ECEF_quat.w = 0;

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

		var rot: Quat = new Quat().fromMat(NED_R_ECEF).normalize();

		var rot_inv: Quat = new Quat();
		rot_inv.x = -rot.x;
		rot_inv.y = -rot.y;
		rot_inv.z = -rot.z;
		rot_inv.w =  rot.w;

		var NED_quat: Quat = rot_inv.mult(rot.mult(ECEF_ref_to_ECEF_quat));

		var NED: Vec4 = new Vec4();
		NED.x = NED_quat.x;
		NED.y = NED_quat.y;
		NED.z = NED_quat.z;
		NED.w = 0;

		return NED;
	}
}
