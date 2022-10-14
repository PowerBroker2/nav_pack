package armory.logicnode;

class DragNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://en.wikipedia.org/wiki/Drag_equation

		var rho:  Float = inputs[0].get();
		var v:    Float = inputs[1].get();
		var Sref: Float = inputs[2].get();
		var Cl:   Float = inputs[3].get();
		if ((rho == null) || (v == null) || (Sref == null) || (Cl == null)) return 0.0;

		var drag: Float = 0.5 * rho * Math.pow(v, 2) * Sref * Cl;

		return drag;
	}
}
