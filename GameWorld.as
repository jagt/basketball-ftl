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
		public var ball:Ball;
		
		public function GameWorld()
		{
			world = this;
			super();
		}
		
		public function add_block(x:int, y:int, width:int, height:int, type:String):Entity
		{
			// add block to the fucking world
			var block:Entity = new Entity(x, y);
			block.setHitbox(width, height);
			block.type = type;
			add(block);
			
			return block;
		}
		
		public function score(type:String, value:String, score:int):void
		{
			if (type == "getscore") {
				FP.console.log(value, score);
			}
			
		}
		
		override public function begin():void {
			// inits
			ground = new Ground();
			player = new Player();
			basket = new Basket();
			ball = new Ball(player);
			
			// adding
			add(ground);
			add(basket);
			add(player);
			
			// debugs
			add(ball);
			FP.console.enable();
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