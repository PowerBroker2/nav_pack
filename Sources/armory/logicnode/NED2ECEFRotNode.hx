package armory.logicnode;

import iron.math.Mat4;
import iron.math.Vec4;
import iron.math.Quat;

class NED2ECEFRotNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://www.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html

		var NED_origin_LLA: Vec4 = inputs[0].get();
		if (NED_origin_LLA == null) return 0.0;

		var lat: Float = NED_origin_LLA.x * (Math.PI  / 180.0);
		var lon: Float = NED_origin_LLA.y * (Math.PI  / 180.0);
		var alt: Float = NED_origin_LLA.z;

		var NED_R_ECEF: Mat4 = Mat4.identity();
		NED_R_ECEF._00 = -Math.sin(lat) * Math.cos(lon);
		NED_R_ECEF._01 = -Math.sin(lat) * Math.sin(lon);
		NED_R_ECEF._02 =  Math.cos(lat);
		NED_R_ECEF._10 = -Math.sin(lon);
		NED_R_ECEF._11 =  Math.cos(lon);
		NED_R_ECEF._12 =  0;
		NED_R_ECEF._20 = -Math.cos(lat) * Math.cos(lon);
		NED_R_ECEF._21 = -Math.cos(lat) * Math.sin(lon);
		NED_R_ECEF._22 = -Math.sin(lat);

		var rot: Quat = new Quat().fromMat(NED_R_ECEF.transpose());
		
		return rot;
	}
}
