package
{
	import flash.utils.Endian;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.*;
	
	public class MenuWorld extends World
	{
		[Embed(source = 'data/menu.png')]
		private const ImgMenu:Class;
		
		[Embed(source = 'data/cursor.png')]
		private const ImgCursor:Class;
		
		[Embed(source = 'data/howto.png')]
		private const ImgHowto:Class;
		
		[Embed(source = 'data/menu.mp3')]
		private const SndMenu:Class;
		
		private var _menu:Entity;
		private var _cur:Entity;
		private var _how:Entity;
		private var _option:int = 0;
		private var _bgm:Sfx;
		
		override public function begin():void
		{
			_menu = addGraphic(new Stamp(ImgMenu, 0, 0));
			_menu.y = -120;
			_cur  = addGraphic(new Stamp(ImgCursor, 0, 0));
			_cur.visible = false;
			_cur.x = 78;
			_how = addGraphic(new Stamp(ImgHowto, 0, 0));
			_how.visible = false;
			
			_bgm = new Sfx(SndMenu);
			
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("jump", Key.Z, Key.SPACE);
			Input.define("reset", Key.X, Key.R);
			
			_bgm.loop(0.7);
		}
		
		override public function update():void
		{
			if (_menu.y < 0) {
				_menu.y += 2;
				return super.update();
			}
			
			_cur.visible = true;
			if (_option == 0)
			{
				_cur.y = 174;	
			} else {
				_cur.y = 197;	
			}
			
			if (Input.pressed("left") || Input.pressed("right")
				|| Input.pressed("up") || Input.pressed("down"))
			{
				_option = 1-_option;
			}
			
			if (Input.pressed("jump"))
			{
				if (_how.visible)
				{
					_how.visible = false;
					return super.update();
				} 
				
				if (_option == 0)
				{
					_bgm.stop();
					FP.world = new GameWorld();
				}
				
				if (_option == 1)
				{
					_how.visible = true;
				}
				
			}
			super.update();
		}
	}
}