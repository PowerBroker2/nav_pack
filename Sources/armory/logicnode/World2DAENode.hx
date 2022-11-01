package armory.logicnode;

import iron.math.Vec4;

class World2DAENode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var world_loc: Vec4 = inputs[0].get();

		var horiz: Vec4 = new Vec4(world_loc.x,
								   world_loc.y,
								   0,
								   0);

		var distance: Float = horiz.length();

		if (from == 0)
		{
			return distance;
		}
		else if (from == 1)
		{
			return azimuth;
		}

		return elevation;
	}
}
