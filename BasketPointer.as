package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	
	public class BasketPointer extends Entity
	{
		[Embed(source = 'data/arrow.png')]
		private const ImgArrow:Class;
		
		public var basket:Basket;
		private var _sprite:Spritemap;
		public var sensor_id:int;
		
		public function BasketPointer(basket:Basket)
		{
			this.basket = basket;
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
			
			sensor_id = FP.rand(3);
			switch (sensor_id)
			{
				case 2:
					y = 44;
					break;
				case 1:
					y = 100;
					break;
				case 0:
					y = 153;
					break;
			}
		}
	}
}