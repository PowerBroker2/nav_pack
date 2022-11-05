package armory.logicnode;

class RandomGaussianFloatNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://en.wikipedia.org/wiki/Marsaglia_polar_method

		var mean: Float = inputs[0].get();
		var std:  Float = inputs[1].get();

		var x: Float = (2 * Math.random()) - 1; // [-1, 1]
		var y: Float = (2 * Math.random()) - 1; // [-1, 1]
		var s: Float = Math.pow(x, 2) + Math.pow(y, 2);

		while ((s <= 0) || (s >= 1))
		{
			x = (2 * Math.random()) - 1; // [-1, 1]
			y = (2 * Math.random()) - 1; // [-1, 1]
			s = Math.pow(x, 2) + Math.pow(y, 2);
		}

		return mean + (std * x * Math.sqrt((-2 * Math.log(s)) / s));
	}
}
