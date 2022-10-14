package armory.logicnode;

import iron.object.Object;
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

		var object: Object = inputs[0].get();
		var ECEF:   Vec4   = inputs[1].get();
		if (ECEF == null) return 0.0;

		var a:         Float = object.properties.get("a");
		var a_sqrd:    Float = object.properties.get("a_sqrd");
		var b:         Float = object.properties.get("b");
		var b_sqrd:    Float = object.properties.get("b_sqrd");
		var f:         Float = object.properties.get("f");
		var ecc_sqrd:  Float = object.properties.get("ecc_sqrd");
		var ecc_prime: Float = object.properties.get("ecc_prime");

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
