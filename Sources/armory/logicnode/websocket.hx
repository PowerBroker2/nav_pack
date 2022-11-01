package armory.logicnode;

import hx.ws.Log;
import hx.ws.WebSocketServer;

class TraceNode extends LogicNode
{
	var ws;

	public function new(tree:LogicTree)
	{
		super(tree);
	}

	override function run(from: Int)
	{
		var port: Int = inputs[1].get();

        Log.mask = Log.INFO | Log.DEBUG | Log.DATA;
        var server = new WebSocketServer<MyHandler>("localhost", port, 10);
        server.start();

		runOutput(0);
	}

	override function get(from:Int):Dynamic
	{
		return ws;
	}
}
