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
		// https://stackoverflow.com/a/25428344/9860973

		var a:         Float = inputs[0].get();
		var b:         Float = inputs[1].get();
		var f:         Float = inputs[2].get();
		var ecc:       Float = inputs[3].get();
		var ecc_prime: Float = inputs[4].get();
		var ECEF:      Vec4  = inputs[5].get();
		if ((a == null) || (b == null) || (f == null) || (ecc == null) || (ecc_prime == null) || (ECEF == null)) return 0.0;

		var a_sqrd:   Float = Math.pow(a,   2);
		var b_sqrd:   Float = Math.pow(b,   2);
		var ecc_sqrd: Float = Math.pow(ecc, 2);

		var LLA: Vec4 = new Vec4();

		var x: Float = ECEF.x;
		var y: Float = ECEF.y;
		var z: Float = ECEF.z;

		var x_sqrd: Float = Math.pow(x, 2);
		var y_sqrd: Float = Math.pow(x, 2);

		var p:  Float = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
		var th: Float = Math.atan2(a*z, b*p);
	  
		var lon: Float = Math.atan2(y, x);
		var lat: Float = Math.atan2((z + Math.pow(ecc_prime, 2) * b * Math.pow(Math.sin(th), 3)),
		                            (p - ecc_sqrd * a * Math.pow(Math.cos(th), 3)));

		var N: Float = a / (Math.sqrt(1 - ecc_sqrd * Math.pow(Math.sin(lat), 2)));
		var h: Float = p / Math.cos(lat) - N;

		lat = lat * (180.0 / Math.PI);
		lon = (lon * (180.0 / Math.PI)) % 360.0;

		if (lat >= 90.0)
		{
			lat = lat % 90.0;
		}
		else if (lat <= -90.0)
		{
			lat = -(lat % 90.0);
		}

		LLA.x = lat;
		LLA.y = lon;
		LLA.z = h;

		return LLA;
	}
}
