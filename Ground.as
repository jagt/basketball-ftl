package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Stamp;
	
	public class Ground extends Entity
	{
		[Embed(source = 'data/ground.png')]
		private const ImgGround:Class;
		
		public function Ground()
		{
			var stamp:Stamp = new Stamp(ImgGround);
			super(0, 200, stamp);
			setHitbox(240, 40);
			type = "block";
		}
	}
}