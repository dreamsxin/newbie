package myleft.geom
{
	import flash.geom.Point;
	
	public class TilePt extends Point
	{
		public var z:Number = 0;
		public function TilePt (x:Number = 0, y:Number = 0, z:Number = 0)
		{
			super();
			
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		override public function toString ():String
		{
			return "x:" + x + " y:" + y + " z:" + z;
		}
	}
}