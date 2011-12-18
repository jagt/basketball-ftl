package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="240", height="240")]
	
	public class Stray extends Engine
	{
		public function Stray()
		{
			super(240, 240, 30, false);
		}
		
		override public function init():void
		{
			FP.world = new MenuWorld();
			FP.screen.color = Com.COLOR_0;
			// ditch box2d, implement ball collision by hand
			// since it is relatively easy and more controlled.
		}
	}
}