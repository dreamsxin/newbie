package myleft.core
{
	import myleft.bounds.IBounds;
	import myleft.bounds.PrimitiveBounds;
	import myleft.events.IsoEvent;
	import myleft.geom.IsoMath;
	import myleft.geom.Pt;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	use namespace myleft_internal;
	
	/**
	 * IsoDisplayObject is the base class that all primitive and complex isometric display objects should extend.
	 * Developers should not instantiate this class but rather extend it.
	 */
	public class IsoDisplayObject extends IsoContainer implements IIsoDisplayObject
	{		
		////////////////////////////////////////////////////////////////////////
		//	BOUNDS
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var _isoBounds:IBounds;
		
		/**
		 * @inheritDoc
		 */
		public function get isoBounds ():IBounds
		{
			if (!_isoBounds)
				_isoBounds = new PrimitiveBounds(this);
			
			return _isoBounds;
		}
		
		/**
		 * @private
		 */
		protected var _screenBounds:Rectangle;
		
		/**
		 * @inheritDoc
		 */
		public function get screenBounds ():Rectangle
		{
			_screenBounds = mainContainer.getBounds(mainContainer);				
			_screenBounds.x += mainContainer.x;
			_screenBounds.y += mainContainer.y;
			
			return _screenBounds;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle
		{
			var rect:Rectangle = mainContainer.getBounds(mainContainer);
			rect.x += mainContainer.x;
			rect.y += mainContainer.y;
			
			var pt:Point = new Point(rect.x, rect.y);
			pt = IIsoContainer(parent).container.localToGlobal(pt);
			pt = targetCoordinateSpace.globalToLocal(pt);
			
			rect.x = pt.x;
			rect.y = pt.y;
			
			return rect;
		}
		
			/////////////////////////////////////////////////////////
			//	POSITION
			/////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////
		//	DISTANCE
		////////////////////////////////////////////////////////////////////////
		
		private var _distance:Number;
		
		/**
		 * @private
		 */
		public function get distance ():Number
		{
			return _distance;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set distance (value:Number):void
		{
			_distance = value;
		}
		
			////////////////////////////////////////////////////////////////////////
			//	X, Y, Z
			////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function moveTo (x:Number, y:Number, z:Number):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * @inheritDoc
		 */
		public function moveBy (x:Number, y:Number, z:Number):void
		{
			this.x += x;
			this.y += y;
			this.z += z;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	X
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isoX:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldX:Number;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("move")]
		public function get x ():Number
		{
			return isoX;
		}
		
		/**
		 * @private
		 */
		public function set x (value:Number):void
		{
			value = Math.round(value);
			if (isoX != value)
			{
				oldX = isoX;
				
				isoX = value;
				invalidatePosition();
				
				if (autoUpdate)
					render();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get screenX ():Number
		{
			var b:IBounds = isoBounds;
			var pt:Pt = IsoMath.isoToScreen(new Pt(b.left, b.front, b.bottom));
						
			return pt.x//container.localToGlobal(pt).x;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	Y
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isoY:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldY:Number;
		
		/**
		 * @private
		 */
		[Bindable("move")]
		public function get y ():Number
		{
			return isoY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set y (value:Number):void
		{
			value = Math.round(value);
			if (isoY != value)
			{
				oldY = isoY;
				
				isoY = value;
				invalidatePosition();
				
				if (autoUpdate)
					render();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get screenY ():Number
		{
			var b:IBounds = isoBounds;
			var pt:Pt = IsoMath.isoToScreen(new Pt(b.right, b.front, b.bottom));
			
			return pt.y//container.localToGlobal(pt).y;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	Z
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isoZ:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldZ:Number;
		
		/**
		 * @private
		 */
		[Bindable("move")]
		public function get z ():Number
		{
			return isoZ;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set z (value:Number):void
		{
			value = Math.round(value);
			if (isoZ != value)
			{
				oldZ = isoZ;
				
				isoZ = value;
				invalidatePosition();
				
				if (autoUpdate)
					render();
			}
		}
		
			/////////////////////////////////////////////////////////
			//	GEOMETRY
			/////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function setSize (width:Number, length:Number, height:Number):void
		{
			this.width = width;
			this.length = length;
			this.height = height;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	WIDTH
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isoWidth:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldWidth:Number;
		
		/**
		 * @private
		 */
		[Bindable("resize")]
		public function get width ():Number
		{
			return isoWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set width (value:Number):void
		{	
			value = Math.abs(value);
			if (isoWidth != value)
			{
				oldWidth = isoWidth;
				
				isoWidth = value;
				invalidateSize();
				
				if (autoUpdate)
					render();
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	LENGTH
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isoLength:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldLength:Number;
		
		/**
		 * @private
		 */
		[Bindable("resize")]
		public function get length ():Number
		{
			return isoLength;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set length (value:Number):void
		{
			value = Math.abs(value);
			{
				oldLength = isoLength;
				
				isoLength = value;
				invalidateSize();
				
				if (autoUpdate)
					render();
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	HEIGHT
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var isoHeight:Number = 0;
		
		/**
		 * @private
		 */
		protected var oldHeight:Number;
		
		/**
		 * @private
		 */
		[Bindable("resize")]
		public function get height ():Number
		{
			return isoHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set height (value:Number):void
		{
			value = Math.abs(value);	
			if (isoHeight != value)
			{
				oldHeight = isoHeight;
				
				isoHeight = value;
				invalidateSize();
							
				if (autoUpdate)
					render();
			}
		}
		
		/////////////////////////////////////////////////////////
		//	RENDERING
		/////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating whether a property change will automatically trigger a render phase.
		 */
		public var autoUpdate:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function render (recursive:Boolean = true):void
		{
			if (!hasParent)
				return;
			
			if (bPositionInvalidated)
			{
				validatePosition();				
				bPositionInvalidated = false;
			}
			
			if (bSizeInvalidated)
			{
				validateSize();
				bSizeInvalidated = false;
			}
			
			//set the flag back for the next time we invalidate the object
			bInvalidateEventDispatched = false;
			
			super.render(recursive);
		}
		
		protected function validatePosition ():void
		{
			var pt:Pt = new Pt(x, y, z);
			IsoMath.isoToScreen(pt);
			
			mainContainer.x = pt.x;
			mainContainer.y = pt.y;
			
			var evt:IsoEvent = new IsoEvent(IsoEvent.MOVE, true);
			evt.propName = "position";
			evt.oldValue = {x:oldX, y:oldY, z:oldZ};
			evt.newValue = {x:isoX, y:isoY, z:isoZ};
			
			dispatchEvent(evt);
		}
		
		/**
		 * Takes the given 3D isometric sizes and performs the necessary rendering logic.
		 */
		protected function validateSize ():void
		{			
			var evt:IsoEvent = new IsoEvent(IsoEvent.RESIZE, true);
			evt.propName = "size";
			evt.oldValue = {width:oldWidth, length:oldLength, height:oldHeight};
			evt.newValue = {width:isoWidth, length:isoLength, height:isoHeight};
			
			dispatchEvent(evt);
		}
		
		/////////////////////////////////////////////////////////
		//	INVALIDATION
		/////////////////////////////////////////////////////////
		
		/**
		 * @private
		 * 
		 * Flag indicated that an IsoEvent.INVALIDATE has already been dispatched, negating the need to dispatch another.
		 */
		myleft_internal var bInvalidateEventDispatched:Boolean = false;
		
		/**
		 * @private
		 */
		myleft_internal var bPositionInvalidated:Boolean = false;
		
		/**
		 * @private
		 */
		myleft_internal var bSizeInvalidated:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function invalidatePosition ():void
		{
			bPositionInvalidated = true;
			
			_isoBounds = null;
			_screenBounds = null;
			
			if (!bInvalidateEventDispatched)
			{
				dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
				bInvalidateEventDispatched = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateSize ():void
		{
			bSizeInvalidated = true;
			
			_isoBounds = null;
			_screenBounds = null;
			
			if (!bInvalidateEventDispatched)
			{
				dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE));
				bInvalidateEventDispatched = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isInvalidated ():Boolean
		{
			return (bPositionInvalidated || bSizeInvalidated);
		}
		
		/////////////////////////////////////////////////////////
		//	CLONE
		/////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function clone ():IIsoDisplayObject
		{
			var CloneClass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			
			var cloneInstance:IIsoDisplayObject = new CloneClass();
			cloneInstance.setSize(isoWidth, isoLength, isoHeight);
			
			return cloneInstance;
		}	
		
		/////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		/////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoDisplayObject ()
		{
			super();
		}	
	}
}