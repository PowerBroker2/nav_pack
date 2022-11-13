package armory.logicnode;

import iron.math.Vec4;

class WorldNED2DAENode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var world_NED_loc: Vec4 = inputs[0].get();

		var horiz: Vec4 = new Vec4(world_NED_loc.x,
								   world_NED_loc.y,
								   0,
								   0);

		var arc_distance: Float = horiz.length();

		if (from == 0)
		{
			return arc_distance; // Arc distance
		}
		else if (from == 1)
		{
			return (Math.atan2(world_NED_loc.y, world_NED_loc.x) * (180.0 / Math.PI) + 360) % 360; // Azimuth
		}

		return -Math.atan2(world_NED_loc.z, arc_distance) * (180.0 / Math.PI); // Elevation
	}
}
