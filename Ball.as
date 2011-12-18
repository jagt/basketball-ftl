package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Ball extends Entity
	{
		[Embed(source = 'data/ball.png')]
		private const ImgBall:Class;
		
		public static const HOLDED:int = 0;
		public static const FREE:int = 1
		public static const SHOOTED:int = 2;
		public static const SCORED:int = 3;
		public static const SHOOT_VELO_X:Number = 100;
		public static const SHOOT_VELO_Y:Number = -50;
		
		public var sprite:Spritemap;
		// well maybe we don't need a real ball here
		//private var _ballmask:BallMask;
		public var velocity_x:Number;
		public var velocity_y:Number;
		public var state:int;
		public var do_predict:Boolean;
		public var delta_x:Number;
		public var delta_y:Number;
		
		private const ROLL_THRESH:Number = 50*50;
		private const CTHRESH:Number = 10;
		private const FADE_THRESH:Number = 15;
		private var _gravity:Number = 250;
		private var _roll_counter:Number;
		private var _player:Player;
		
		public var tricks:Vector.<String>;
		
		public function Ball(player:Player)
		{
			sprite = new Spritemap(ImgBall, 8, 8);
			super(x, y, sprite);
			setHitbox(8, 8, 0, 0);
			sprite.add("fadeout", [4, 5, 6], 10, false);
			sprite.add("fadein", [6, 5, 4, 0], 10, false);
			_player = player;
			tricks = new Vector.<String>();
			velocity_x = 0;
			velocity_y = 0;
			
			sprite.play("fadein");
			tricks.length = 0; // clear tricks
			state = FREE;
			_player.hold_ball(this);
		}
		
		public function reset():void
		{
			sprite.play("fadein");
			FP.console.log("resetting ---------");
			for each (var trick:String in tricks) {
				FP.console.log(trick);
			}
			// update status
			GameWorld.world.status.text.text = 
				GameWorld.world.status.calculate();
			
			GameWorld.world.basket.reset();
			tricks.length = 0; // clear tricks
			state = FREE;
			_player.hold_ball(this);
		}
		
		public function roll():void
		{
			sprite.frame = (sprite.frame + 1) % 4;
		}
		
		override public function render():void
		{
			if (do_predict)
				predict_draw(velocity_x, velocity_y);
			super.render();
		}
		
		
		override public function update():void
		{
			if (state == HOLDED) return super.update();
			
			_roll_counter += velocity_x*velocity_x + velocity_y*velocity_y;
			if (_roll_counter > ROLL_THRESH) {
				roll();
			}
			// update with velocity only when not holded
			velocity_y += _gravity * FP.elapsed;
			delta_x = velocity_x * FP.elapsed;
			delta_y = velocity_y * FP.elapsed;
			x += delta_x;
			y += delta_y;
			
			if (state >= SHOOTED)
			{
				var dt:Number = FP.elapsed * 1;
				// handle collision
				var dx:Number = x + velocity_x * dt;
				var dy:Number = y + velocity_y * dt;
				// resolve in x and y seperately
				var other:Entity;
				
				// TODO fix the funky collision if has more time
				other = collide("block", dx, y);
				if (other != null)
				{
					// x axis causing collision
					if (velocity_x > CTHRESH && dx+width > other.left)
					{
						// hit right
						velocity_x = -velocity_x * 0.6;
					}
					else if (velocity_x < -CTHRESH && dx < other.right)
					{
						// hit left
						velocity_x = -velocity_x * 0.5;
					}
				}
				
				other = collide("block", x, dy);
				if (other != null) 
				{
					// y axis causing collision
					if (dy+height > other.top)
					{
						// hit bottom
						velocity_y = - velocity_y * 0.7;
						if (other is Ground && state == SHOOTED)
							tricks.push("ground");
					}
					else if (dy < other.bottom)
					{
						// hit top
						velocity_y = - velocity_y * 0.5;
					}
				}
				
				// recalc dx and dy, since next frame
				// velocity changes a lot
				dx = x + velocity_x * dt;
				dy = y + (velocity_y + _gravity * dt)  * dt;
				
				// TODO high speed ball are ignored this sucks
				// only test current position to avoid
				// fake scores
				sensor_collision(GameWorld.world.basket.sensor1, dx, dy);
				sensor_collision(GameWorld.world.basket.sensor2, dx, dy);
				sensor_collision(GameWorld.world.basket.sensor3, dx, dy);
				
//				other = collide("sensor", x, y);
//				if (other != null)
//				{
//					if (velocity_y > 0)
//					{
//						if (GameWorld.world.basket.trigger(other)) 
//						{
//							GameWorld.world.effects.score_effect(other);
//							tricks.push("score");
//							state = SCORED;
//						}
//					}
//				}
				
				// collide with head
				// test current ball position
				if (collideWith(_player.head, x, y))
				{
					// do not hold scored ball
					// nor get ball when standing on floor
					if (state == SHOOTED && !_player.on_floor)
						_player.hold_ball(this);
				}
			}
			
			// handle after shoot 
			// avoid ball fall into the ground
			if (y > 200-8) y = 200-8;
			
			if ( x < -20 
				|| x > Com.WIDTH + 20
				|| (y > 180 && Com.length(velocity_x, velocity_y) < FADE_THRESH))
			{
				sprite.play("fadeout");
			}
			
			if (state >= SHOOTED && sprite.frame == 6)
			{
				// fade done, reset to player
				reset();
			}
			
			
			super.update();
		}
		
		private function sensor_collision(sensor:Entity, dx:Number, dy:Number):void
		{
			if (velocity_y > 0 && y < sensor.y && dy > sensor.y)
			{
				var sx1:Number = sensor.x,
					sx2:Number = sensor.x + sensor.width,
					sy:Number = sensor.y;
				
				var ix:Number = x + (dx - x) * (sy - y) / (dy - y); 
				if ((sx1 < ix && ix < sx2))
				{
					// collided	
					GameWorld.world.effects.score_effect(sensor);
					tricks.push("score");
					state = SCORED;
				}
			}
		}
		
		private function predict_draw(vx:Number, vy:Number):void
		{
			var dt:Number = 0.0333; // use last frame elapsed
			var t:Number = 0;
			var px:Number, py:Number, px2:Number, py2:Number;
			// to predict
			FP.buffer.lock();
			for (var ix:int = 1; ix < 40; ++ix )
			{
				// TODO opt to an add fashion
				// TODO draw line based on curve so it would looks better
				//t = ix * 1.5 * dt;
				//FP.console.log( Math.abs(t + vy / _gravity) );
				px = ix * 7;
				t = px / vx;
				py  = vy * t + 0.5 * _gravity * t * t;
				if (py + centerY > 200 - 4) break;
				FP.buffer.setPixel(px + centerX, py + centerY, Com.COLOR_3);
				FP.buffer.setPixel(px + centerX, py + centerY +1, Com.COLOR_2);
//				t = (px + 1) / vx;
//				px = vx * t; 
//				py = vy * t + 0.5 * _gravity * t * t;
//				FP.buffer.setPixel(px + centerX, py + centerY, Com.COLOR_3);
			}
			FP.buffer.unlock();
		}
		
	}
}