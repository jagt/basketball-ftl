package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	public class Block extends Entity
	{
		public function Block(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			super(x, y, graphic, mask);
		}
	}
}