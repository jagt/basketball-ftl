package
{
	import net.flashpunk.Mask;
	
	public class BallMask extends Mask
	{
		private var _ox:Number;
		private var _oy:Number;
		private var _radius:Number;
		
		public function BallMask(ox:Number, oy:Number, radius:Number)
		{
			_ox = ox;
			_oy = oy;
			_radius = radius;
			_check[Mask] = collideMask;
		}
		
		// collide another entity, here we only implement this
		private function collideMask(other:Mask):Boolean
		{
			var other_realx = other.parent.x - other.parent.originX;
			var other_realy = other.parent.y - other.parent.originY;
			
			var max_diff_x = Math.max( Math.abs(_ox - other_realx),
					Math.abs(_ox - other_realx - other.parent.width));
			var max_diff_y = Math.max( Math.abs(_oy - other_realy),
					Math.abs(_oy - other_realy - other.parent.height));
			
			return max_diff_x < _radius || max_diff_y < _radius);
		}
	}
}