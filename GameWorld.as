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
		
		[Embed(source = 'data/bgm.mp3')]
		private const SndBgm:Class;
		
		public static var world:GameWorld;
		public var ground:Ground;
		public var player:Player;
		public var basket:Basket;
		public var ball:Ball;
		public var effects:Effects;
		public var status:Status;
		
		private var _bg:Entity;
		private var _bgm:Sfx;
		private var _froze_cnt:int = 40;
		
		public function GameWorld()
		{
			world = this; // set singleton
			_bg = new Entity(0, 0, new Stamp(ImgBg));
			_bgm = new Sfx(SndBgm);
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
			effects = new Effects(ball);
			status = new Status(ball);
			
			// adding
			add(_bg);
			add(ground);
			add(effects);
			add(basket);
			add(player);
			add(player.head) // add for collision and debug drawing
			add(ball);
			add(status);
			
			// debugs
			if (Com.isDebugPlayer())
			{
				_froze_cnt = 2;
				FP.console.enable();
				
				status.text.y += 30;
				status.info.y += 30;
				status.hud.y  += 30;
			}
			
			// inits
			status.setup();
			status.info.visible = false;
		}
		
		override public function update():void
		{
			if (_froze_cnt > 0) {
				--_froze_cnt;
				if (_froze_cnt < 1)
					_bgm.loop(0.7);
				return;
			}
			
			if (Input.pressed("reset") && ball.state >= Ball.SHOOTED)
			{
				ball.sprite.play("fadeout");
			}
			super.update();
		}
		
	}
}