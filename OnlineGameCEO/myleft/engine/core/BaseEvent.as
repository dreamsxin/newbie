package myleft.engine.core
{
	import flash.events.Event;

	public class BaseEvent extends Event
	{
		public function BaseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}