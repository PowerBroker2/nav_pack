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

	override function get(from:Int):Dynamic
	{
		var air_density:                   Float = inputs[0].get();
		var gravity_NED:                   Vec4  = inputs[1].get();
		var vehicle_mass:                  Float = inputs[2].get();
		var vehicle_cg_body:               Vec4  = inputs[3].get();
		var vehicle_location_lla:          Vec4  = inputs[4].get();
		var NED_R_body:                    Quat  = inputs[5].get();
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


		// Find NED to body rotation
		var body_R_NED: Quat = inv_rot(NED_R_body);


		// Find gravity vector in the vehicle's body frame
		var gravity_body: Vec4 = new Vec4(gravity_NED.x,
										  gravity_NED.y,
										  gravity_NED.z,
										  gravity_NED.w);
		gravity_body = gravity_body.applyQuat(body_R_NED);
		

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
		var alpha: Float = Math.asin(-tot_air_velocity_unit_body.z);
		var beta:  Float = Math.atan2(-tot_air_velocity_unit_body.x, tot_air_velocity_unit_body.y) - (Math.PI / 2.0);


		// Sanitize alpha and beta values
		if (Math.isNaN(alpha))
		{
			alpha = 0;
		}
		else if (alpha > Math.PI)
		{
			alpha = alpha % Math.PI;
		}
		else if (alpha < -Math.PI)
		{
			alpha = -(alpha % Math.PI);
		}

		if (Math.isNaN(beta))
		{
			beta = 0;
		}
		else if (beta > Math.PI)
		{
			beta = beta % Math.PI;
		}
		else if (beta < -Math.PI)
		{
			beta = -(beta % Math.PI);
		}


		// Total air force
		var tot_air_force: Float = 0.5 * air_density * Math.pow(tot_air_veolcity_magnitude, 2);
		

		if (from == 0)
		{
			// Find the lift and drag forces
			var lift_drag_body: Vec4 = new Vec4();
			lift_drag_body.x = -(tot_air_force * (((cd_scale * Math.sin(alpha)) + cd_offset) * Math.cos(beta))); // Drag
			lift_drag_body.y = 0;
			lift_drag_body.z = -(tot_air_force * (((cl_scale * Math.sin(alpha)) + cl_offset) * Math.cos(beta))); // Lift


			// Find the lateral aerodynamic forces
			var lateral_aero_forces_body: Vec4 = new Vec4();
			lateral_aero_forces_body.x = tot_air_force * (((cfx_scale * -Math.cos(alpha)) + cfx_offset) *  Math.cos(beta));
			lateral_aero_forces_body.y = tot_air_force * (((cfy_scale *  Math.cos(alpha)) + cfy_offset) * -Math.sin(beta));
			lateral_aero_forces_body.z = tot_air_force * (((cfz_scale * -Math.sin(alpha)) + cfz_offset));


			// Compile forces
			var tot_forces_body: Vec4 = new Vec4();
			tot_forces_body = tot_forces_body.add(gravity_body);
			tot_forces_body = tot_forces_body.add(lift_drag_body);
			tot_forces_body = tot_forces_body.add(lateral_aero_forces_body);


			return tot_forces_body;
		}


		// Find the moment vector that counteracts the airplane's rotation due to drag/air friction
		var dampening_moments_body: Vec4 = new Vec4(0.5 * air_density * Math.pow(vehicle_angular_velocity_body.x, 2) * angular_dampening.x,
													0.5 * air_density * Math.pow(vehicle_angular_velocity_body.y, 2) * angular_dampening.y,
													0.5 * air_density * Math.pow(vehicle_angular_velocity_body.z, 2) * angular_dampening.z,
													0);
		
		if (vehicle_angular_velocity_body.x > 0)
		{
			dampening_moments_body.x *= -1;
		}

		if (vehicle_angular_velocity_body.y > 0)
		{
			dampening_moments_body.y *= -1;
		}

		if (vehicle_angular_velocity_body.z > 0)
		{
			dampening_moments_body.z *= -1;
		}


		// Find the local aerodynamic moments
		var aero_moments_body: Vec4 = new Vec4();
		aero_moments_body.x = tot_air_force * (((cmx_scale * Math.cos(alpha)) + cmx_offset) * Math.sin(beta));
		aero_moments_body.y = tot_air_force * (((cmy_scale * Math.cos(alpha)) + cmy_offset) * Math.cos(beta));
		aero_moments_body.z = tot_air_force * (((cmz_scale * Math.sin(beta))  + cmz_offset) * Math.cos(alpha));


		// Find the moment vector due to gravity and the lever arm between the CG and aerodynamic center
		var cg_moments_body: Vec4 = new Vec4().crossvecs(vehicle_cg_body, gravity_body);

		//compile moments
		var tot_moments_body: Vec4 = new Vec4();
		tot_moments_body = tot_moments_body.add(dampening_moments_body);
		tot_moments_body = tot_moments_body.add(aero_moments_body);
		tot_moments_body = tot_moments_body.add(cg_moments_body);


		return tot_moments_body;
	}
}
