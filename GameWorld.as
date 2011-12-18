package
{
	import flash.display.BitmapData;
	
	import net.flashpunk.*;
	import net.flashpunk.debug.Console;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.*;
	
	public class GameWorld extends World
	{
		[Embed(source = 'data/bg.png')]
		private const ImgBg:Class;
		
		public static var world:GameWorld;
		public var ground:Ground;
		public var player:Player;
		public var basket:Basket;
		public var ball:Ball;
		
		private var _bg:Entity;
		
		public function GameWorld()
		{
			world = this; // set singleton
			_bg = new Entity(0, 0, new Stamp(ImgBg));
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
			add(_bg);
			add(ground);
			add(basket);
			add(player);
			add(player.head) // add for collision and debug drawing
			
			// debugs
			add(ball);
			FP.console.enable();
		}
		
		override public function update():void
		{
			if (Input.pressed("reset") && ball.state == Ball.SHOOTED)
			{
				ball.sprite.play("fadeout");
			}
			super.update();
		}
		
	}
}