package armory.logicnode;

import iron.math.Mat4;

class TraceNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function run(from: Int)
	{
		trace(inputs[1].get());
		runOutput(0);
	}
}
