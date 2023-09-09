package myleft.engine.events
{
	import flash.events.Event;

	public class LoadEvent extends Event
	{
		//Events:
		public static const LOAD_START:String = "load_has_started";
		public static const LOAD_PROGRESS:String = "load_in_progress";
		public static const LOAD_COMPLETE:String = "load_is_complete";
		public static const LOAD_INIT:String = "load_is_init";
		
		//load url
        private var _url:String = null;
        private var _message:String = null;
        private var _progress:Number = 0;
		
		public function LoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//获取 url
        public function get url():String
        {
            return this._url;
        }

        //设置 url
        public function set url(value:String):void
        {
            this._url = value;
        }
        
        //获取 MSG
        public function get message():String
        {
            return this._message;
        }

        //设置 MSG
        public function set message(value:String):void
        {
            this._message = value;
        }
        
        //获取 progress
        public function get progress():Number
        {
            return this._progress;
        }

        //设置 progress
        public function set progress(value:Number):void
        {
            this._progress = value;
        }
	}
}