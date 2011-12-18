package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.*;
	
	public class Basket extends Entity
	{
		[Embed(source = 'data/basket.png')]
		private const ImgBasket:Class;
		
		// -   <- basket 3
		
		// -   <- basket 2
		//
		// -   <- basket 1
		
		// use a score counter to prevent buggy constant
		// cause it may happen sometimes
		private const COOLDOWN:Number = 10 * Com.INTERVAL;
		private var _b1_cd:Number = -1;
		private var _b2_cd:Number = -1;
		private var _b3_cd:Number = -1;
		
		private var _sensor1:Entity;
		private var _sensor2:Entity;
		private var _sensor3:Entity;
		
		public function trigger(sensor:Entity):Boolean
		{
			var world:GameWorld = GameWorld.world;
			if (sensor == _sensor1) {
				if (_b1_cd < 0)
				{
					world.score("getscore", "1pt", 1);
					_b1_cd = 0;
					return true;
				}
			} else if (sensor == _sensor2) {
				if (_b2_cd < 0)
				{
					world.score("getscore", "2pt", 2);
					_b2_cd = 0;
					return true;
				}
			} else if (sensor == _sensor3) {
				if (_b3_cd < 0)
				{
					world.score("getscore", "3pt", 3);
					_b3_cd = 0;
					return true;
				}
			}
			return false;
		}
		
		public function Basket()
		{
			var stamp:Stamp = new Stamp(ImgBasket);
			super(205, 0, stamp);
			
			// add corresponding hit boxes
			var world:GameWorld = GameWorld.world;
			world.add_block(212, 53, 2, 5, "block");
			world.add_block(230, 36, 4, 23, "block");
			world.add_block(212, 108, 2, 5, "block");
			world.add_block(230, 91, 4, 23, "block");
			world.add_block(212, 161, 2, 5, "block");
			world.add_block(230, 144, 4, 23, "block");
			
			_sensor3 = world.add_block(217,  57, 11, 3, "sensor");
			_sensor2 = world.add_block(217, 112, 11, 3, "sensor");
			_sensor1 = world.add_block(217, 165, 11, 3, "sensor");
		}
		
		override public function update():void
		{
			// update sensor cool downs
			_b1_cd += FP.elapsed;
			_b2_cd += FP.elapsed;
			_b3_cd += FP.elapsed;
			if (_b1_cd > 10 * Com.INTERVAL) {
				_b1_cd = -1;
			}
			if (_b2_cd > 10 * Com.INTERVAL) {
				_b2_cd = -1;
			}
			if (_b3_cd > 10 * Com.INTERVAL) {
				_b3_cd = -1;
			}
			
			if (Input.pressed(Key.T))
			{
				GameWorld.world.effects.score_effect(_sensor3);
			}
			
			
			super.update();
		}
		
	}
}