package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.Console;
	import net.flashpunk.utils.*;
	
	public class GameWorld extends World
	{
		public static var world:GameWorld;
		public var ground:Ground;
		public var player:Player;
		public var basket:Basket;
		
		public function GameWorld()
		{
			super();
			world = this;
		}
		
		public function add_block(x:int, y:int, width:int, height:int):void
		{
			// add block to the fucking world
			var block:Entity = new Entity(x, y);
			block.setHitbox(width, height);
			block.type = "block";
			add(block);
		}
		
		override public function begin():void {
			// inits
			ground = new Ground();
			player = new Player();
			basket = new Basket();
			var testball:Ball = new Ball(0, 0);
			
			// adding
			add(ground);
			add(basket);
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