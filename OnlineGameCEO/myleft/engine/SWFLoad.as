package myleft.engine{

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import myleft.engine.events.LoadEvent;
	
	public class SWFLoad extends EventDispatcher{
		
		private var storeArr:Array;
		
		private var i_total:Number = 0;
		private var i_counter:Number = 0;
		
		public function SWFLoad() {
			storeArr = new Array();
		}
		//PULICS
		public function multiload( storelist:Array ):void
		{
			storeArr = storelist;
			startLoad();
		}
		
		public function singleload( url:String ):void
		{
			storeArr.push(url);
			startLoad();
		}
		
		private function startLoad():void
		{
			i_total = storeArr.length;
			i_counter = 0;
			var _loadevent:LoadEvent = new LoadEvent( LoadEvent.LOAD_START );
			dispatchEvent( _loadevent );
			
			load();
		}
		
		private function load():void {
			if (storeArr !=null && storeArr.length>0)
			{
				i_counter ++;
				
				var url:String = storeArr.shift();
			
				var loader:Loader = new Loader();
				var context:LoaderContext = new LoaderContext();
	
				/* 加载到新域(独立运行的程序或模块) */
				//context.applicationDomain = new ApplicationDomain();
				/* 加载到子域(模块) */
				//context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
	
				/* 加载到同域(共享库) */
				context.applicationDomain = ApplicationDomain.currentDomain;
	
				loader.load(new URLRequest(url), context);
		
				loader.contentLoaderInfo.addEventListener(Event.INIT, this.init);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onProgress );
				//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete); 
			}
			else
			{
				var _loadevent:LoadEvent = new LoadEvent( LoadEvent.LOAD_INIT );
				dispatchEvent( _loadevent );
			}
		}
		
		private function onProgress(e:ProgressEvent):void{
			var _loadevent:LoadEvent = new LoadEvent( LoadEvent.LOAD_PROGRESS );
			_loadevent.message = "正在载入数据文件"+i_counter.toString()+"/"+i_total.toString();
			trace(_loadevent.message);
			//_maploadevent.progress = e.bytesLoaded/e.bytesTotal*100;
			_loadevent.progress = i_counter/i_total*100;
			dispatchEvent( _loadevent );
		}
		
		private function init(e:Event):void {
			
			var loader:Loader = e.target.loader as Loader;
			loader.contentLoaderInfo.removeEventListener(Event.INIT, init);
	
			loader.unload();
			loader = null;
			
			load();
		}
		
		/**
		 * 获取当前ApplicationDomain内的类定义
		 * 
		 * @param class_name	类名称，必须包含完整的命名空间
		 * @param p_info		加载swf的LoadInfo，不指定则从当前域获取
		 * @return				获取的类定义，如果不存在返回null
		 */		
		public static function getClass(class_name:String) : Class
		{
			try
			{
				return ApplicationDomain.currentDomain.getDefinition(class_name) as Class;
			} 
			catch (e:ReferenceError)
			{
				trace("定义 " + class_name + " 不存在");
				return null;
			}
			return null;
		}
	
		//SINGLETON
		private static  var _instance:SWFLoad;
		public static function getInstance():SWFLoad {
			if (!_instance) {
				_instance = new SWFLoad();
			}
			return _instance;
		}

	}
}