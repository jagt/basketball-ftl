package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Text;
	
	public class Status extends Entity
	{
		public var text:Text;
		private var _ball:Ball;
		
		public function Status(ball:Ball)
		{
			text = new Text("Placehold Long Long Long Long lOng\n LOng Long LOng lOng Long", 0, 0, {
				"font" : "GameGirl"
			  , "size" : 8
			  , "align" : "left"
			  , "width" : 240
			  , "height" : 20
			  , "color" : Com.COLOR_3
			}); 
			_ball = ball;
			super(0, 30, text);
		}
		
		public function calculate():String
		{
			var desc:Vector.<String> = new Vector.<String>();
			var tricks:Vector.<String> = _ball.tricks;
			
			if (tricks.indexOf("score") < 0)
			{
				return "";
			}
			
			if (tricks.indexOf("ranged") >= 0)
			{
				if (tricks.indexOf("stand") >= 0) {
					desc.push("inplace");
				}
				desc.push("long range");
			}
			
			if (tricks.indexOf("layback") >= 0)
			{
				desc.push("layback");
			}
			else if (tricks.indexOf("forward") >= 0)
			{
				desc.push("rush");
			}
			
			var alley_index:int = tricks.indexOf("alley");
			var ground_index:int = tricks.indexOf("ground");
			
			if (alley_index >= 0 && ground_index < 0)
			{
				desc.push("air");
			} 
			else if (ground_index >= 0 && alley_index < 0)
			{
				desc.push("floor");
			}
			else if (ground_index >= 0 && alley_index >=0 && ground_index < alley_index)
			{
					desc.push("solo");
					desc.push("alley");
					desc.push("oop");
			}
			else if (ground_index >= 0 && alley_index >=0 && ground_index > alley_index)
			{
					desc.push("air");
					desc.push("to");
					desc.push("ground");
			}
			
			var score_cnt:int = 0;
			for each (var trick:String in tricks)
			{
				if (trick == "score") ++score_cnt;	
			}
			
			switch (score_cnt)
			{
				case 0:
					throw "wtf";
					break;
				case 1:
					desc.push("shot");
					break;
				case 2:
					desc.push("double");
					desc.push("shot");
					break;
				default:
					desc.push("full");
					desc.push("house");
					break;
			}
			
			if (desc.length > 4) {
				desc.splice(4, 0, '\n');
				FP.console.log("wtf");
				FP.console.log(desc.join(" "));
			}
			else if (desc.length == 1)
			{
				desc.splice(0, 0, "plain");
			}
			
			return "  " + desc.join(" ");
		}
		
	}
}