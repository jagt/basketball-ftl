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
		private const ACC:Number = 100;
		private const DRAG:Number = 140;
		private const SLIDE_THRASH:Number = 20;
		private const GRAVITY:Number = 90;
		private const BALL_CHARGE_Y:Number = 180;
		private const BALL_DRAG_CHARGE_Y:Number = 90;
		private const BALL_DRAG_X:Number = 70;
		private const BALL_CHARGE_X_RIGHT:Number = 40;
		private const BALL_CHARGE_X_LEFT:Number = 20;
		private const BALL_BONUS_CHARGE_Y:Number = 10;
		
		
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
			var dt:Number = FP.elapsed;
			// player controls and moving
			if (y >= 200 - height)
			{
				y = 200 - height;
				if (!_on_floor && ball)
				{
					// just hit the floor
					shoot_ball();
				}
				_on_floor = true;
				_velo_y = 0;
			}
			
			if (_on_floor)
			{
				if (Input.check("left"))
				{
					_velo_x = Math.max(-MAX_VELO,
						_velo_x - (ACC + 60 * (_velo_x > 0 ? 1 : 0))*dt)
				}
				else if (Input.check("right"))
				{
					_velo_x = Math.min(MAX_VELO,
						_velo_x + (ACC + 60 * (_velo_x < 0 ? 1 : 0))*dt)
				}
				else
				{
					if (_velo_x > 0)
						_velo_x = Math.max(0, _velo_x - DRAG*dt);
					else
						_velo_x = Math.min(0, _velo_x + DRAG*dt)
				}
				
				if (Input.check("jump")) {
					_velo_y = -80;
					_on_floor = false;
					// reduce velo_x for a more real feeling
					if (_velo_x > 40) _velo_x -= 10;
					if (_velo_x < -40) _velo_x += 20;
					sprite.frame = 3;
				}
				
				// sync player velo to ball with a fraction
				if (ball != null) {
					ball.velocity_x = Ball.SHOOT_VELO_X + _velo_x * 0.5;
				}
			} 
			else if (ball != null)
			{
				
				// aerial controlling with ball
				if (Input.check("jump")) {
					// hold jump to charge ball Y velo
					if (_velo_y < 0)
					{
						ball.velocity_y -= BALL_CHARGE_Y * dt;
						if (Input.check("right"))
						{
							ball.velocity_x += BALL_CHARGE_X_RIGHT * dt;	
						} 
						else if (Input.check("left"))
						{
							ball.velocity_x -= BALL_CHARGE_X_LEFT * dt;	
						}
						if (_velo_y > -10)
						{
							ball.velocity_y -= BALL_BONUS_CHARGE_Y * dt;
						}
					}
					else
					{
						// drag shoot spead when falling
						ball.velocity_y -= BALL_DRAG_CHARGE_Y * dt;
						ball.velocity_x -= BALL_DRAG_X * dt;
					}
				}
				
				if (Input.released("jump")) {
					shoot_ball();
					sprite.frame = 4;
				}
			}
			
			// animation
			if (_on_floor)
			{
				if (!Input.check("left") && !Input.check("right") && Math.abs(_velo_x) < SLIDE_THRASH) {
					sprite.frame = 0;
					_walk_counter = 0;
				} else {
					if (sprite.frame == 0) {
						// for walking anime on starting
						sprite.frame = 1;
					}
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
			}
			
			// update ball before player moving
			// to get a attached effect
			if (ball != null) {
				// player holding the ball
				ball.x = x + 3;
				ball.y = y - 8;
			}
			
			// update with velocity
			_velo_y += GRAVITY * FP.elapsed;
			x += _velo_x * FP.elapsed;
			y += _velo_y * FP.elapsed;
			if (x < 0) x = 0;
			else if (x > Com.WIDTH - width) x = Com.WIDTH - width;
			
			super.update();
		}
	}
}