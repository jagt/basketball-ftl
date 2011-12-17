package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.*;
	
	public class Player extends Entity
	{
		[Embed(source = 'data/player.png')]
		private const ImgPlayer:Class;
		
		public var sprite:Spritemap;
		public var ball:Ball; // current ball or empty
		
		private const MAX_VELO:Number = 60;
		private const ACC:Number = 30;
		private const DRAG:Number = 15;
		private const SLIDE_THRASH:Number = 20;
		
		
		private var _velo_x:Number = 0;
		private var _velo_y:Number = 0;
		private var _on_floor:Boolean = true;
		private var _walk_counter:Number;
		private var _hold_roll:int;
		
		public function Player()
		{
			sprite = new Spritemap(ImgPlayer, 12, 16);
			setHitbox(12, 16);
			super(20, 200 - height, sprite);
			
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("jump", Key.Z);
			
			type = "player";
			
			sprite.add("walk", [1, 2], 10);
			sprite.frame = 0;
		}
		
		public function hold_ball(free_ball:Ball):void
		{
			if (free_ball == null || free_ball.state != Ball.FREE) {
				throw "get an bad ball";	
			}
			ball = free_ball;
			ball.state = Ball.HOLDED;
		}
		
		public function shoot_ball():void
		{
			ball.state = Ball.SHOOTED;
			ball = null;
		}
		
		
		override public function update():void
		{
			// player controls and moving
			if (y >= 200 - height)
			{
				y = 200 - height;
				_on_floor = true;
				_velo_y = 0;
			}
			
			if (_on_floor)
			{
				if (Input.check("left"))
					_velo_x = Math.max(-MAX_VELO, _velo_x - ACC)
				else if (Input.check("right"))
					_velo_x = Math.min(MAX_VELO, _velo_x + ACC)
				else
				{
					if (_velo_x > 0)
						_velo_x = Math.max(0, _velo_x - DRAG);
					else
						_velo_x = Math.min(0, _velo_x + DRAG)
				}
			}
			
			// animation
			if (_on_floor)
			{
				if (Math.abs(_velo_x) < SLIDE_THRASH) {
					sprite.frame = 0;
					_walk_counter = 0;
				} else {
					_walk_counter += _velo_x;	
					// only 2 frames of walking
					if (Math.abs(_walk_counter) > MAX_VELO * 2) {
						sprite.frame = sprite.frame == 1 ? 2 : 1; 
						_walk_counter = 0;
						if (ball != null) {
							// roll the ball if has one
							_hold_roll += 1;
							if (_hold_roll > 8) {
								ball.roll();
							}
						}
					} 
				}
			}
			
			if (ball != null) {
				ball.do_predict = true;
				ball.velocity_x = 100;
				ball.velocity_y = -200;
				if (Input.check("down")) {
					shoot_ball();
				}
			}
			
			// update ball before player moving
			// to get a attached effect
			if (ball != null) {
				// player holding the ball
				ball.x = x + 3;
				ball.y = y - 8;
			}
			
			// update with velocity
			x += _velo_x * FP.elapsed;
			y += _velo_y * FP.elapsed;
			if (x < 0) x = 0;
			else if (x > Com.WIDTH - width) x = Com.WIDTH - width;
			
			super.update();
		}
	}
}