package
{
	public class Com {
		import flash.system.Capabilities;
		
		[Embed(source = 'data/Gamegirl.ttf', embedAsCFF="false", fontFamily = "GameGirl")]
		public static const FntGameGirl:Class;
		
		public static const INTERVAL:Number = 0.0333;
		public static const WIDTH:int = 240;
		public static const HEIGHT:int = 240;
		
		// physics unit to pixel scale
		// say a ball with 0.2m as radius, displayed as a 8x8 ball
		public static const SCALE:Number = 20.0;
		
		public static const COLOR_0:uint = 0xE7D79C;
		public static const COLOR_1:uint = 0xB5A66B;
		public static const COLOR_2:uint = 0x7B7163;
		public static const COLOR_3:uint = 0x393829;
		
		public static function length(x:Number, y:Number):Number
		{
			return Math.sqrt(x*x+y*y);
		}
		
		public static function isDebugPlayer() : Boolean
		{
			return Capabilities.isDebugger;
		}
	}
	
}