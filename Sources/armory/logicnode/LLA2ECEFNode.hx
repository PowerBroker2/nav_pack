package armory.logicnode;

import iron.math.Vec4;

class LLA2ECEFNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var a:   Float = inputs[0].get();
		var ecc: Float = inputs[1].get();
		var LLA: Vec4  = inputs[2].get();
		if ((a == null) || (ecc == null) || (LLA == null)) return 0.0;

		var ecc_sqrd: Float = Math.pow(ecc, 2);

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
