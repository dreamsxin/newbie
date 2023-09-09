package myleft.engine.core
{
	public class BaseMove
	{
		public var dir:Number;
		public var dirx:Number;
		public var diry:Number;
		public var dirz:Number;
		public var speed:Number;
		public var angle:Number;
		public function BaseMove(_dir:Number=0, _dirx:Number=0,_diry:Number=0,_dirz:Number=0)
		{
			this.dir = _dir;
			this.dirx = _dirx;
			this.diry = _diry;
			this.dirz = _dirz;
		}
	}
}