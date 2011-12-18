package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Stamp;
	
	public class Basket extends Entity
	{
		[Embed(source = 'data/basket.png')]
		private const ImgBasket:Class;
		
		public function Basket()
		{
			var stamp:Stamp = new Stamp(ImgBasket);
			super(205, 0, stamp);
			
			// add corresponding hit boxes
			var world:GameWorld = GameWorld.world;
			world.add_block(212, 53, 2, 5);
			world.add_block(230, 36, 4, 23);
			world.add_block(212, 108, 2, 5);
			world.add_block(230, 91, 4, 23);
			world.add_block(212, 161, 2, 5);
			world.add_block(230, 144, 4, 23);
		}
	}
}