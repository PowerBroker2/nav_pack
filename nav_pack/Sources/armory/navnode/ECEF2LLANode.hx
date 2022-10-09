package armory.logicnode;

import iron.math.Vec4;

class ECEF2LLANode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var object: Object = inputs[0].get();
		var ECEF:   Vec4   = inputs[1].get();
		if (ECEF == null) return 0.0;

		var a:        Float = object.properties.get("a");
		var f:        Float = object.properties.get("f");
		var ecc_sqrd: Float = object.properties.get("ecc_sqrd");

		LLA = new Vec4();

		var x: Float = ECEF.x;
		var y: Float = ECEF.y;
		var z: Float = ECEF.z;

		var x_sqrd: Float = Math.pow(x, 2);
		var y_sqrd: Float = Math.pow(x, 2);

		var lon: Float = Math.atan2(y, x);
		var lat: Float = 400.0;

		var s:      Float = sqrt(x_sqrd + y_sqrd);
		var beta:   Float = Math.atan2(z, (1 - f) * s);
		var mu_bar: Float = Math.atan2(z + (((ecc_sqrd * (1 - f)) / (1 - ecc_sqrd)) * a * Math.pow(Math.sin(beta), 3)),
						               s - (ecc_sqrd * a * Math.pow(cos(beta), 3)));

		while (Math.abs(lat - mu_bar) > 1e-10)
		{
			lat    = mu_bar;
			beta   = Math.atan2((1 - f) * Math.sin(lat),
			                    Math.cos(lat));
			mu_bar = Math.atan2(z + (((ecc_sqrd * (1 - f)) / (1 - ecc_sqrd)) * a * Math.pow(Math.sin(beta), 3)),
							    s - (ecc_sqrd * a * Math.pow(cos(beta), 3)));
		}

		lat = mu_bar;

		var N: Float = a / Math.sqrt(1 - (ecc_sqrd * Math.pow(Math.sin(lat), 2)));
		var h: Float = (s * Math.cos(lat)) + ((z + (ecc_sqrd * N * Math.sin(lat))) * Math.sin(lat)) - N;

		lat = lat * (180.0 / Math.PI);
		lon = lon * (180.0 / Math.PI);

		LLA.x = lat;
		LLA.y = lon;
		LLA.z = h;

		return LLA;
	}
}
