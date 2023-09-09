package myleft.events
{
	import flash.events.Event;

	/**
	 * The IsoEvent class represents the event object passed to the listener for various isometric display events.
	 */
	public class IsoEvent extends Event
	{
		/////////////////////////////////////////////////////////////
		//	CONST
		/////////////////////////////////////////////////////////////
		
		/**
		 * The IsoEvent.INVALIDATE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const INVALIDATE:String = "myleft_invalidate";
		
		/**
		 * The IsoEvent.RENDER constant defines the value of the type property of the event object for an iso event.
		 */
		static public const RENDER:String = "myleft_render";
		
		/**
		 * The IsoEvent.MOVE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const MOVE:String = "myleft_move";
		
		/**
		 * The IsoEvent.RESIZE constant defines the value of the type property of the event object for an iso event.
		 */
		static public const RESIZE:String = "myleft_resize";
		
		/**
		 * The IsoEvent.CHILD_ADDED constant defines the value of the type property of the event object for an iso event.
		 */
		static public const CHILD_ADDED:String = "myleft_childAdded";
		
		/**
		 * The IsoEvent.CHILD_REMOVED constant defines the value of the type property of the event object for an iso event.
		 */
		static public const CHILD_REMOVED:String = "myleft_childRemoved";
		
		/////////////////////////////////////////////////////////////
		//	DATA
		/////////////////////////////////////////////////////////////
		
		/**
		 * Specifies the property name of the property values assigned in oldValue and newValue.
		 */
		public var propName:String;
		
		/**
		 * Specifies the previous value assigned to the property specified in propName.
		 */
		public var oldValue:Object;
		
		/**
		 * Specifies the new value assigned to the property specified in propName.
		 */
		public var newValue:Object;
		
		/**
		 * Constructor
		 */
		public function IsoEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone ():Event
		{
			var evt:IsoEvent = new IsoEvent(type, bubbles, cancelable);
			evt.propName = propName;
			evt.oldValue = oldValue;
			evt.newValue = newValue;
			
			return evt;
		}
	}
}