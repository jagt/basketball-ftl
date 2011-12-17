package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Spritemap;
	
	public class Ball extends Entity
	{
		[Embed(source = 'data/ball.png')]
		private const ImgBall:Class;
		
		public var sprite:Spritemap;
		
		// well maybe we don't need a real ball here
		//private var _ballmask:BallMask;
		
		public function Ball(x:Number=0, y:Number=0)
		{
			sprite = new Spritemap(ImgBall, 8, 8);
			super(x, y, sprite);
			setHitbox(8, 8, 0, 0);
			
			sprite.frame = 0;
		}
		
		override public function update():void
		{
			
		}
	}
}