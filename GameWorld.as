package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.Console;
	import net.flashpunk.utils.*;
	
	public class GameWorld extends World
	{
		public var ground:Ground;
		public var player:Player;
		
		public function GameWorld()
		{
			super();
		}
		
		override public function begin():void {
			// inits
			ground = new Ground();
			player = new Player();
			var testball:Ball = new Ball(0, 0);
			
			// adding
			add(ground);
			add(player);
			
			// debugs
			add(testball);
			FP.console.enable();
			player.hold_ball(testball);
			FP.console.log(FP.buffer.height);
			FP.console.log(FP.buffer.width);
		}
		
		override public function update():void
		{
			if (Input.check(Key.R))
			{
				FP.world = new GameWorld();
			}
			super.update();
		}
	}
}