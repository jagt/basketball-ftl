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
		public var info:Text;
		public var hud:Text;
		public var plate:BonusPlate;
		public var arrow:BasketPointer;
		public var score:int;
		public var highest:int = 0;
		public var is_show_time:Boolean;
		private var _ball:Ball;
		private var _info_timer:Number = -1;
		private const DISPLAY_TIME:Number = 2.0;
		private var _clear_score:Boolean;
		
		public var total_shots:int;
		
		public function Status(ball:Ball)
		{
			var config:Object = {
				"font" : "GameGirl"
			  , "size" : 8
			  , "align" : "left"
			  , "width" : 240
			  , "height" : 20
			  , "color" : Com.COLOR_3
			}; 
			text = new Text("", 8, 12, config); 
			info = new Text("", 8, 42, config);
			hud  = new Text(" highscore:0", 8, 2, config);
			_ball = ball;
			total_shots = 0;
			
			plate = new BonusPlate();
			arrow = new BasketPointer(GameWorld.world.basket);
			super(0, 0);
			addGraphic(text);
			addGraphic(info);
			addGraphic(hud);
		}
		
		public function game_over():void
		{
			if (score != 0)
			{
				info.visible = true;
				_info_timer = 0;
				info.text = " this run:" + score;	
				text.text = "";
			}
			highest = score > highest ? score : highest;
			_clear_score = true;
			score = 0;
		}
		
		// called during ball reset
		public function setup():void
		{
			text.text = calculate();
			hud.text = " highscore:" + highest + "  score:" + score;
			total_shots += 1;
			
			plate.reset();
			arrow.reset();
			if (is_show_time)
			{
				is_show_time = false;
				info.visible = false;
			}
			_clear_score = false;
//			arrow.enable();
//			plate.enable();
			var type:int = total_shots % 6;
			switch(type)
			{
				case 0:
				case 2:
					plate.enable();
					break;
				case 1:
				case 3:
					arrow.enable();
					break;
				case 4:
					arrow.enable();
					plate.enable();
					break;
				case 5:
					is_show_time = true;
					GameWorld.world.effects.trail_on = true;
					_info_timer = -1;
					info.text = " show time!"
					info.visible = true;
					break;
			}
		}
		
		override public function update():void
		{
			if (_info_timer >= 0)
			{
				_info_timer += FP.elapsed;
				if (_info_timer > DISPLAY_TIME)
				{
					_info_timer = -1;
					info.visible = false;
				}
			}
			
			super.update();
		}
		
		override public function added():void
		{
			super.added();
			world.add(plate);
			world.add(arrow);
		}
		
		public function calculate():String
		{
			var desc:Vector.<String> = new Vector.<String>();
			var tricks:Vector.<String> = _ball.tricks;
			
			if (arrow.visible && !arrow.basket.check_sensor(arrow.sensor_id))
			{
				game_over();	
			}
			
			if (tricks.indexOf("score") < 0)
			{
				game_over();	
				return "";
			}
			
			var cur_score:int = 0;
			var delta:int = 1;
			
			if (tricks.indexOf("ranged") >= 0)
			{
				if (tricks.indexOf("stand") >= 0) {
					desc.push("inplace");
					delta += 1;
				}
				desc.push("long range");
				delta += 2;
			}
			
			if (tricks.indexOf("layback") >= 0)
			{
				desc.push("layback");
				delta += 2;
			}
			else if (tricks.indexOf("forward") >= 0)
			{
				desc.push("rush");
				delta += 1;
			}
			
			var alley_index:int = tricks.indexOf("alley");
			var ground_index:int = tricks.indexOf("ground");
			
			if (alley_index >= 0 && ground_index < 0)
			{
				if (_ball.collided)
				{
					desc.push("rebound");
					delta += 4;
				}
				desc.push("alley");
				desc.push("oop");
				delta += 3;
			} 
			else if (ground_index >= 0 && alley_index < 0)
			{
				desc.push("floor");
				delta += 5;
			}
			else if (ground_index >= 0 && alley_index >=0 && ground_index < alley_index)
			{
					desc.push("floor");
					desc.push("alley");
					desc.push("oop");
					delta += 6;
			}
			else if (ground_index >= 0 && alley_index >=0 && ground_index > alley_index)
			{
					desc.push("air");
					desc.push("to");
					desc.push("ground");
					delta += 6;
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
			
			if (!_ball.collided)
			{
				desc.push("direct");
				delta += 10;
			}
			
			if (desc.length >= 4) {
				desc.splice(4, 0, '\n');
				FP.console.log("wtf");
				FP.console.log(desc.join(" "));
			}
			else if (desc.length == 1)
			{
				desc.splice(0, 0, "plain");
			}
			
			// multiply the scores
			cur_score = delta * score_cnt;
			
			if (!_clear_score)
			{
				var calc:String = delta + " skill x " + score_cnt + " pt";
				desc.push("\n");
				desc.push(calc);
				score += cur_score;
			}
			
			return " " + desc.join(" ");
		}
		
	}
}