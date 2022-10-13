package armory.logicnode;

class AirDensityNode extends LogicNode
{
	var alt_arr: Array<Float> = [-1000,
								     0,
								  1000,
								  2000,
								  3000,
								  4000,
								  5000,
								  6000,
								  7000,
								  8000,
								  9000,
								 10000,
								 15000,
								 20000,
								 25000,
								 30000,
								 40000,
								 50000,
								 60000,
								 70000,
								 80000];
	var rho_arr: Array<Float> = [1.347,
								 1.225,
								 1.112,
								 1.007,
								 0.9093,
								 0.8194,
								 0.7364,
								 0.6601,
								 0.5900,
								 0.5258,
								 0.4671,
								 0.4135,
								 0.1948,
								 0.08891,
								 0.04008,
								 0.01841,
								 0.003996,
								 0.001027,
								 0.0003097,
								 0.00008283,
								 0.00001846];
	
	var arr_len: Int = 21;

	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function get(from:Int):Dynamic
	{
		// https://www.engineeringtoolbox.com/standard-atmosphere-d_604.html

		var alt: Float = inputs[0].get();
		if (alt == null) return 0.0;

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
