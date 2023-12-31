package myleft.bounds
{
	import myleft.core.IIsoDisplayObject;
	import myleft.geom.Pt;
	
	/**
	 * The IBounds implementation for Primitive-type classes
	 */
	public class PrimitiveBounds implements IBounds
	{
		////////////////////////////////////////////////////////////////
		//	W / L / H
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get width ():Number
		{
			return _target.width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length ():Number
		{
			return _target.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get height ():Number
		{
			return _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	LEFT / RIGHT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get left ():Number
		{
			return _target.x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get right ():Number
		{
			return _target.x + _target.width;
		}
		
		////////////////////////////////////////////////////////////////
		//	BACK / FRONT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get back ():Number
		{
			return _target.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get front ():Number
		{
			return _target.y + _target.length;
		}
		
		////////////////////////////////////////////////////////////////
		//	BOTTOM / TOP
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get bottom ():Number
		{
			return _target.z;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get top ():Number
		{
			return _target.z + _target.height;
		}
		
		////////////////////////////////////////////////////////////////
		//	CENTER PT
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function get centerPt ():Pt
		{
			var pt:Pt = new Pt();
			pt.x = _target.x + _target.width / 2;
			pt.y = _target.y + _target.length / 2;
			pt.z = _target.z + _target.height / 2;
			
			return pt;
		}
		
		////////////////////////////////////////////////////////////////
		//	COLLISION
		////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function intersects (bounds:IBounds):Boolean
		{
			if (Math.abs(centerPt.x - bounds.centerPt.x) <= _target.width / 2 + bounds.width / 2 &&
				Math.abs(centerPt.y - bounds.centerPt.y) <= _target.length / 2 + bounds.length / 2 &&
				Math.abs(centerPt.z - bounds.centerPt.z) <= _target.height / 2 + bounds.height / 2)
				
				return true;
			
			else
				return false;
		}
		
		private var _target:IIsoDisplayObject;
		
		////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function PrimitiveBounds (target:IIsoDisplayObject)
		{
			this._target = target;
		}
	}
}