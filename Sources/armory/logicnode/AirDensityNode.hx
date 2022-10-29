package armory.logicnode;

class AirDensityNode extends LogicNode
{
	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		var alt:     Float        = inputs[0].get();
		var alt_arr: Array<Float> = inputs[1].get();
		var rho_arr: Array<Float> = inputs[2].get();
		var arr_len: Int          = inputs[3].get();

		var rho:   Float = 0.0;
		var idx_l: Int   = 0;
		var idx_h: Int   = 0;

		for (i in 0...arr_len)
		{
			idx_l = i;
			idx_h = i + 1;

			if (i == 0)
			{
				if (alt <= alt_arr[i])
				{
					break;
				}
			}
			else if (i == arr_len)
			{
				if (alt > alt_arr[i])
				{
					idx_l = i - 1;
					idx_h = i;
					
					break;
				}
			}
			else
			{
				if ((alt > alt_arr[i - 1]) && (alt <= alt_arr[i]))
				{
					break;
				}
			}
		}

		var x0: Float = alt_arr[idx_l];
		var x1: Float = alt_arr[idx_h];

		var y0: Float = rho_arr[idx_l];
		var y1: Float = rho_arr[idx_h];

		rho = y0 + ((alt - x0) * ((y1 - y0) / (x1 - x0)));

		return rho;
	}
}
