package armory.logicnode;

import iron.math.Vec4;

class World2GlobalNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// http://www.movable-type.co.uk/scripts/latlong.html
		// https://en.wikipedia.org/wiki/Earth_radius

		var a:   Float = inputs[0].get();
		var ecc: Float = inputs[1].get();
		var LLA: Vec4  = inputs[2].get();
		var ENU: Vec4  = inputs[3].get();

		var ecc_sqrd: Float = Math.pow(ecc, 2);

		var lat: Float = LLA.x * (Math.PI / 180.0);
		var lon: Float = LLA.y * (Math.PI / 180.0);
		var alt: Float = LLA.z;

		var NED: Vec4 = new Vec4();
		NED.x =  ENU.y;
		NED.y =  ENU.x;
		NED.z = -ENU.z;
		NED.w =  0;

		var horiz: Vec4 = new Vec4(NED.x,
								   NED.y,
								   0,
								   0);

		var dist:      Float = horiz.length();
		var azimuth:   Float = ((Math.atan2(NED.y, NED.x) * (180.0 / Math.PI) + 360) % 360) * (Math.PI / 180.0);
		var elevation: Float = -Math.atan2(NED.z, dist);

		var R_N: Float = a / Math.sqrt(1 - (ecc_sqrd * Math.pow(Math.sin(lat), 2)));
		var R_M: Float = (a * (1 - ecc_sqrd)) / Math.pow((1 - (ecc_sqrd * Math.pow(Math.sin(lat), 2))), 1.5);

		var radius:   Float = alt + (1 / ((Math.pow(Math.cos(azimuth), 2) / R_M) + (Math.pow(Math.sin(azimuth), 2) / R_N)));
		var adj_dist: Float = dist / radius;

		var lat_2: Float = Math.asin(Math.sin(lat) * Math.cos(adj_dist) + Math.cos(lat) * Math.sin(adj_dist) * Math.cos(azimuth));
		var lon_2: Float = lon + Math.atan2(Math.sin(azimuth) * Math.sin(adj_dist) * Math.cos(lat),
                                            Math.cos(adj_dist) - Math.sin(lat) * Math.sin(lat_2));
		
		var LLA_2: Vec4 = new Vec4(lat_2  * (180.0 / Math.PI),
								   (lon_2 * (180.0 / Math.PI)) % 360.0,
								   alt + (dist * Math.tan(elevation)),
								   0);
		
		if (from == 0)
		{
			var ECEF: Vec4 = new Vec4();
			
			var lat_2: Float = LLA_2.x * (Math.PI  / 180.0);
			var lon_2: Float = LLA_2.y * (Math.PI  / 180.0);
			var alt_2: Float = LLA_2.z;
			
			var Rns: Float = a / Math.sqrt(1 - (ecc_sqrd * Math.pow(Math.sin(lat_2), 2)));
			
			ECEF.x = (Rns + alt_2) * Math.cos(lat_2) * Math.cos(lon_2);
			ECEF.y = (Rns + alt_2) * Math.cos(lat_2) * Math.sin(lon_2);
			ECEF.z = ((1 - ecc_sqrd) * Rns + alt_2)  * Math.sin(lat_2);

			return ECEF;
		}
		else if (from == 1)
		{
			return NED;
		}

		return LLA_2;
	}
}
