package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	
	public class BasketPointer extends Entity
	{
		[Embed(source = 'data/arrow.png')]
		private const ImgArrow:Class;
		
		private var _basket:Basket;
		private var _sprite:Spritemap;
		
		public function BasketPointer(basket:Basket)
		{
			_basket = basket;
			_sprite = new Spritemap(ImgArrow, 14, 9);
			_sprite.add("point", [0, 1], 4);
			super(189, 0, _sprite);
			
			visible = false;
		}
		
		public function reset():void
		{
			visible = false;
		}
		
		public function enable():void
		{
			_sprite.play("point", true);
			visible = true;
			
			switch (FP.rand(3))
			{
				case 0:
					y = 44;
					break;
				case 1:
					y = 100;
					break;
				case 2:
					y = 153;
					break;
			}
		}
	}
}