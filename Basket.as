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
		private var _b1_cd:Boolean;
		private var _b2_cd:Boolean;
		private var _b3_cd:Boolean;
		
		public var sensor1:Entity;
		public var sensor2:Entity;
		public var sensor3:Entity;
		
		public function trigger(sensor:Entity):Boolean
		{
			var world:GameWorld = GameWorld.world;
			if (sensor == sensor1) {
				if (!_b1_cd)
				{
					world.score("getscore", "1pt", 1);
					_b1_cd = true;
					return true;
				}
			} else if (sensor == sensor2) {
				if (!_b2_cd)
				{
					world.score("getscore", "2pt", 2);
					_b2_cd = true;
					return true;
				}
			} else if (sensor == sensor3) {
				if (!_b3_cd)
				{
					world.score("getscore", "3pt", 3);
					_b3_cd = true;
					return true;
				}
			}
			return false;
		}
		
		public function reset():void
		{
			_b1_cd = false;
			_b2_cd = false;
			_b3_cd = false;
			
		}
		
		public function Basket()
		{
			var stamp:Stamp = new Stamp(ImgBasket);
			super(205, 0, stamp);
			
			// add corresponding hit boxes
			var world:GameWorld = GameWorld.world;
			world.add_block(212, 53, 2, 5, "block");
			world.add_block(230, 36, 4, 18, "block");
			world.add_block(212, 108, 2, 5, "block");
			world.add_block(230, 91, 4, 18, "block");
			world.add_block(212, 161, 2, 5, "block");
			world.add_block(230, 144, 4, 18, "block");
			
			sensor3 = world.add_block(213,  55, 14, 3, "sensor");
			sensor2 = world.add_block(213, 110, 14, 3, "sensor");
			sensor1 = world.add_block(213, 163, 14, 3, "sensor");
			
			reset();
		}
		
		override public function update():void
		{
			
			if (Input.pressed(Key.T))
			{
				GameWorld.world.effects.score_effect(sensor3);
			}
			
			
			super.update();
		}
		
	}
}