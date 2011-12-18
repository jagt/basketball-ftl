package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.FP;
	
	public class BonusPlate extends Entity
	{
		[Embed(source = 'data/indic.png')]
		private const ImgBasket:Class;
	
		public function BonusPlate()
		{
			var stamp:Stamp = new Stamp(ImgBasket);
			super(0, 200 - 6, stamp);
			setHitbox(21, 6);
			
			type = "plate";
			visible = false;
			collidable = false;
		}
		
		public function reset():void
		{
			visible = false;	
			collidable = false;
		}
		
		public function enable():void
		{
			visible = true;
			collidable = true;
			x = 30 + FP.random * 130;
		}
	}
}