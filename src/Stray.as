package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.*;
	
	[SWF(width="240", height="240")]
	[Frame(factoryClass="Preloader")]
	
	public class Stray extends Engine
	{
		public function Stray()
		{
			super(240, 240, 30, false);
		}
		
		override public function init():void
		{
			
			Input.define("left", Key.LEFT, Key.A);
			Input.define("right", Key.RIGHT, Key.D);
			Input.define("up", Key.UP, Key.W);
			Input.define("down", Key.DOWN, Key.S);
			Input.define("jump", Key.Z, Key.SPACE);
			Input.define("reset", Key.X, Key.R);
			
			if (Com.isDebugPlayer())
			{
				FP.world = new GameWorld();
			} 
			else
			{
				FP.world = new MenuWorld();
			}
			
			FP.screen.color = Com.COLOR_0;
			// ditch box2d, implement ball collision by hand
			// since it is relatively easy and more controlled.
		}
	}
}