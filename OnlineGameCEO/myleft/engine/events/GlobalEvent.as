package myleft.engine.events
{
	import flash.events.Event;
	import myleft.engine.core.BaseEvent;

	public class GlobalEvent extends BaseEvent
	{
		public var property:*;
		public static const PROPERTY_CHANGED:String = "globalPropertyChanged";
	
		public function GlobalEvent(type:String, property:*, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.property = property;
			super(type, bubbles, cancelable);
		}
	
		override public function clone():Event {
			return new GlobalEvent(type, property, bubbles, cancelable);
		}
	}
}