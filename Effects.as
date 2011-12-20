package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Emitter;
	
	public class Effects extends Entity
	{
		
		// fuck spelling
		[Embed(source = 'data/particle.png')]
		private const ImgParticles:Class;
		
		public var trail_on:Boolean = false;
		
		public var emit:Emitter;
		
		
		private const EMIT_DISTANCE:Number = 6;
		
		private var _ball:Ball;
		private var _ball_traveled:Number = 0;
		
		public function score_effect(sensor:Entity):void
		{
			var startx:Number = sensor.x;
			var endx:Number = sensor.x + sensor.width;
			for ( ; startx < endx; startx += 3)
			{
				emit.emit("score", startx, (startx % 2) * 2 + sensor.y - 5);
			}
		}
		
		public function edge_effect(edge:Entity):void
		{
			emit.emit("score", edge.x, edge.y);
		}
		
		public function Effects(ball:Ball)
		{
			emit = new Emitter(ImgParticles, 6, 6);
			_ball = ball;
			
			emit.newType("trail", [1, 2]);
			emit.setAlpha("trail", 1, 1);
			emit.setMotion("trail", -30, 0, 0.6, 60, 5, 0.1);
			
			emit.newType("score", [5, 4]);
			emit.setAlpha("score", 1, 1);
			emit.setMotion("score", 270, 4, 0.15, 20, 2, 0.1);
			
			super(0, 0, emit);
		}
		
		override public function update():void
		{
			if (trail_on && _ball.state >= Ball.SHOOTED && _ball.delta_x) // hack
			{
				_ball_traveled += Com.length(_ball.delta_x, _ball.delta_y);
				if (_ball_traveled > EMIT_DISTANCE)
				{
					emit.emit("trail", _ball.centerX, _ball.centerY);	
					_ball_traveled = 0;
				}
			}
			super.update();
		}
		
	}
}