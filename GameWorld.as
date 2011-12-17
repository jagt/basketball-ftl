package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.Console;
	
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
		}
	}
}