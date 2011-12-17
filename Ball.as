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
		
		public var sprite:Spritemap;
		// well maybe we don't need a real ball here
		//private var _ballmask:BallMask;
		public var velocity_x:Number;
		public var velocity_y:Number;
		public var state:int;
		
		private const ROLL_THRESH:Number = 50*50;
		private var _gravity:Number;
		private var _roll_counter:Number;
		
		public function Ball(x:Number=0, y:Number=0)
		{
			sprite = new Spritemap(ImgBall, 8, 8);
			super(x, y, sprite);
			setHitbox(8, 8, 0, 0);
			
			sprite.frame = 0;
			state = FREE;
		}
		
		public function roll():void
		{
			sprite.frame = (sprite.frame + 1) % 4;
		}
		
		
		override public function update():void
		{
			if (state > HOLDED) {
				_roll_counter += velocity_x*velocity_x + velocity_y*velocity_y;
				if (_roll_counter > ROLL_THRESH) {
					roll();
				}
			}
			
			super.update();
		}
		
	}
}