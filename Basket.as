package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.*;
	
	public class Basket extends Entity
	{
		[Embed(source = 'data/basket.png')]
		private const ImgBasket:Class;
		
		[Embed(source = 'data/high.mp3')]
		private const SndHigh:Class;
		
		[Embed(source = 'data/mid.mp3')]
		private const SndMid:Class;
		
		[Embed(source = 'data/low.mp3')]
		private const SndLow:Class;
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
		private var _high:Sfx;
		private var _mid:Sfx;
		private var _low:Sfx;
		
		public var sensor1:Entity;
		public var sensor2:Entity;
		public var sensor3:Entity;
		
		
		public function trigger(sensor:Entity):Boolean
		{
			var world:GameWorld = GameWorld.world;
			if (sensor == sensor1) {
				if (!_b1_cd)
				{
					_low.play()
					world.score("getscore", "1pt", 1);
					_b1_cd = true;
					return true;
				}
			} else if (sensor == sensor2) {
				if (!_b2_cd)
				{
					_mid.play();
					world.score("getscore", "2pt", 2);
					_b2_cd = true;
					return true;
				}
			} else if (sensor == sensor3) {
				if (!_b3_cd)
				{
					_high.play();
					world.score("getscore", "3pt", 3);
					_b3_cd = true;
					return true;
				}
			}
			return false;
		}
		
		public function check_sensor(ix:int):Boolean
		{
			switch (ix)
			{
				case 0:
					return _b1_cd;
					break;
				case 1:
					return _b2_cd;
					break;
				case 2:
					return _b3_cd;
					break;
				default:
					throw "wrong ix, shoudl be 0-2"
			}
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
			
			_high = new Sfx(SndHigh);
			_mid  = new Sfx(SndMid);
			_low  = new Sfx(SndLow);
			
			// add corresponding hit boxes
			var world:GameWorld = GameWorld.world;
			world.add_block(212, 53, 2, 5, "block");
			world.add_block(230, 36, 4, 18, "block");
			world.add_block(212, 107, 2, 5, "block");
			world.add_block(230, 90, 4, 18, "block");
			world.add_block(212, 161, 2, 5, "block");
			world.add_block(230, 144, 4, 18, "block");
			
			sensor3 = world.add_block(213,  55, 14, 3, "sensor");
			sensor2 = world.add_block(213, 109, 14, 3, "sensor");
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