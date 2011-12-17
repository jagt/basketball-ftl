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
			FP.console.enable();
			// inits
			ground = new Ground();
			player = new Player();
			
			// adding
			add(ground);
			add(player);
		}
	}
}