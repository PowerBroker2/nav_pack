package armory.logicnode;

import haxe.macro.Expr.QuoteStatus;
import iron.math.Mat4;
import iron.math.Vec4;
import iron.math.Quat;

class FixedWingNode extends LogicNode
{
	var G: Float = 6.6743015 * Math.pow(10, -11);

	public function new(tree:LogicTree)
	{
		super(tree);
	}

	function inv_rot(rotation: Quat): Quat
	{
		var rotation_inv: Quat = new Quat(-rotation.x,
										  -rotation.y,
										  -rotation.z,
										   rotation.w);
		rotation_inv.normalize();

		return rotation_inv;
	}

	function ECEF2NED_rot(NED_origin_LLA: Vec4): Quat
	{
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

	override function get(from:Int):Dynamic
	{
		var air_density:                   Float = inputs[0].get();
		var gravity_ECEF:                  Vec4  = inputs[1].get();
		var vehicle_mass:                  Float = inputs[2].get();
		var vehicle_cg_body:               Vec4  = inputs[3].get();
		var vehicle_location_lla:          Vec4  = inputs[4].get();
		var body_R_NED:                    Quat  = inputs[5].get();
		var vehicle_angular_velocity_body: Vec4  = inputs[6].get();
		var vehicle_velocity_body:         Vec4  = inputs[7].get();
		var wind_velocity_NED:             Vec4  = inputs[8].get();
		var angular_dampening:             Vec4  = inputs[9].get();
		var cl_scale:                      Float = inputs[10].get();
		var cl_offset:                     Float = inputs[11].get();
		var cd_scale:                      Float = inputs[12].get();
		var cd_offset:                     Float = inputs[13].get();
		var cfx_scale:                     Float = inputs[14].get();
		var cfx_offset:                    Float = inputs[15].get();
		var cfy_scale:                     Float = inputs[16].get();
		var cfy_offset:                    Float = inputs[17].get();
		var cfz_scale:                     Float = inputs[18].get();
		var cfz_offset:                    Float = inputs[19].get();
		var cmx_scale:                     Float = inputs[20].get();
		var cmx_offset:                    Float = inputs[21].get();
		var cmy_scale:                     Float = inputs[22].get();
		var cmy_offset:                    Float = inputs[23].get();
		var cmz_scale:                     Float = inputs[24].get();
		var cmz_offset:                    Float = inputs[25].get();
		var ref_airspeed:                  Float = inputs[26].get();
		var ref_pitch_moment:              Float = inputs[27].get();
		var ref_roll_moment:               Float = inputs[28].get();
		var ref_yaw_moment:                Float = inputs[29].get();
		var pitch_command:                 Float = inputs[30].get();
		var roll_command:                  Float = inputs[31].get();
		var yaw_command:                   Float = inputs[32].get();
		var throttle_command:              Float = inputs[33].get();


		// Find gravity vector in the vehicle's body frame
		var gravity_body: Vec4 = new Vec4(gravity_ECEF.x,
										  gravity_ECEF.y,
										  gravity_ECEF.z,
										  0);
		gravity_body = gravity_body.applyQuat(ECEF2NED_rot(vehicle_location_lla));
		gravity_body = gravity_body.applyQuat(body_R_NED);


		// Find the moment vector that counteracts the airplane's rotation due to drag/air friction
		var dampening_body: Vec4 = new Vec4(0.5 * air_density * Math.pow(vehicle_angular_velocity_body.x, 2) * angular_dampening.x,
											0.5 * air_density * Math.pow(vehicle_angular_velocity_body.y, 2) * angular_dampening.y,
											0.5 * air_density * Math.pow(vehicle_angular_velocity_body.z, 2) * angular_dampening.z,
											0);
		
		if (vehicle_angular_velocity_body.x > 0)
		{
			dampening_body.x *= -1;
		}

		if (vehicle_angular_velocity_body.y > 0)
		{
			dampening_body.y *= -1;
		}

		if (vehicle_angular_velocity_body.z > 0)
		{
			dampening_body.z *= -1;
		}
		

		// Find the angle of attack (alpha) and angle of sideslip (beta)
		var wind_velocity_body: Vec4 = new Vec4(wind_velocity_NED.x,
												wind_velocity_NED.y,
												wind_velocity_NED.z,
												0);
		wind_velocity_body = wind_velocity_body.applyQuat(body_R_NED);

		var tot_air_velocity_body: Vec4 = wind_velocity_body;
		tot_air_velocity_body.x -= vehicle_velocity_body.x;
		tot_air_velocity_body.y -= vehicle_velocity_body.y;
		tot_air_velocity_body.z -= vehicle_velocity_body.z;
		tot_air_velocity_body.w  = 0;

		var tot_air_veolcity_magnitude: Float = tot_air_velocity_body.length();
		
		var tot_air_velocity_unit_body: Vec4 = new Vec4(tot_air_velocity_body.x / tot_air_veolcity_magnitude,
														tot_air_velocity_body.y / tot_air_veolcity_magnitude,
														tot_air_velocity_body.z / tot_air_veolcity_magnitude,
														0);
		var alpha = Math.asin(-tot_air_velocity_unit_body.z) * (180.0 / Math.PI);
		var beta  = Math.atan2(tot_air_velocity_unit_body.x, tot_air_velocity_unit_body.y) * (180.0 / Math.PI);

		if (Math.isNaN(alpha))
		{
			alpha = 0;
		}

		if (Math.isNaN(beta))
		{
			beta = 0;
		}
		

		trace(vehicle_velocity_body);
		trace(alpha);
		trace(beta);
		trace('');


		if (from == 0)
		{
			return 0.0;
		}

		return 0.0;
	}
}
