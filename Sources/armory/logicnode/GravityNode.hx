package armory.logicnode;

import iron.math.Mat4;
import iron.math.Vec4;
import iron.math.Quat;

class GravityNode extends LogicNode
{
	var G: Float = 6.6743015 * Math.pow(10, -11);
	
	function NED2ECEF_rot(NED_origin_LLA: Vec4): Quat
	{
		var lat: Float = NED_origin_LLA.x * (Math.PI  / 180.0);
		var lon: Float = NED_origin_LLA.y * (Math.PI  / 180.0);
		var alt: Float = NED_origin_LLA.z;

		var NED_R_ECEF: Mat4 = Mat4.identity();
		NED_R_ECEF._00 = -Math.sin(lat) * Math.cos(lon);
		NED_R_ECEF._10 = -Math.sin(lat) * Math.sin(lon);
		NED_R_ECEF._20 =  Math.cos(lat);
		NED_R_ECEF._01 = -Math.sin(lon);
		NED_R_ECEF._11 =  Math.cos(lon);
		NED_R_ECEF._21 =  0;
		NED_R_ECEF._02 = -Math.cos(lat) * Math.cos(lon);
		NED_R_ECEF._12 = -Math.cos(lat) * Math.sin(lon);
		NED_R_ECEF._22 = -Math.sin(lat);

		var rot: Quat = new Quat().fromMat(NED_R_ECEF.transpose());
		
		return rot;
	}

	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://en.wikipedia.org/wiki/Gravity

		var planet_m:  Float = inputs[0].get();
		var vehicle_m: Float = inputs[1].get();
		var ECEF:      Vec4  = inputs[2].get();
		if ((planet_m == null) || (vehicle_m == null) || (ECEF == null)) return 0.0;

		var mag: Float = G * planet_m * vehicle_m / Math.pow(ECEF.length(), 2);

		var grav_NED: Vec4 = new Vec4();
		grav_NED.z = mag;

		var grav_ECEF: Vec4 = new Vec4(grav_NED.x,
									   grav_NED.y,
									   grav_NED.z,
									   grav_NED.w);
		grav_ECEF = grav_ECEF.applyQuat(NED2ECEF_rot(grav_NED));
		
		if (from == 0)
		{
			return grav_ECEF;
		}

		return grav_NED;
	}
}
