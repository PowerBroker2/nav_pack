package armory.logicnode;

import iron.object.Object;
import iron.math.Vec4;

class LLA2ECEFNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var object: Object = inputs[0].get();
		var LLA:    Vec4   = inputs[1].get();
		if (LLA == null) return 0.0;

		var a:        Float = object.properties.get("a");
		var ecc_sqrd: Float = object.properties.get("ecc_sqrd");

		var ECEF: Vec4 = new Vec4();

		var lat: Float = LLA.x * (Math.PI  / 180.0);
		var lon: Float = LLA.y * (Math.PI  / 180.0);
		var alt: Float = LLA.z;

		var Rns: Float = a / Math.sqrt(1 - (ecc_sqrd * Math.pow(Math.sin(lat), 2)));

		ECEF.x = (Rns + alt) * Math.cos(lat) * Math.cos(lon);
		ECEF.y = (Rns + alt) * Math.cos(lat) * Math.sin(lon);
		ECEF.z = ((1 - ecc_sqrd) * Rns + alt) * Math.sin(lat);

		return ECEF;
	}
}
