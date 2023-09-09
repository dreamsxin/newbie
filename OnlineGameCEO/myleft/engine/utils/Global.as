package myleft.engine.utils
{
	import flash.utils.*;
	import flash.events.*;
	
	import myleft.engine.events.GlobalEvent;
	
	public dynamic class Global extends Proxy implements IEventDispatcher
	{
		private static var instance:Global = null;
		private static var allowInstantiation:Boolean = false;
		private var globalRepository:HashMap;
		private var dispatcher:EventDispatcher;

		public static function getInstance() : Global {
			if ( Global.instance == null ) {
				Global.allowInstantiation = true;
				Global.instance = new Global();
				Global.allowInstantiation = false;
			}
			return Global.instance;
		}

		public function Global() {
			if (getQualifiedClassName(super) == "myleft.engine.utils::Global" ) {
				if (!allowInstantiation) {
					throw new Error("Error: Instantiation failed: Use Global.getInstance() instead of new Global().");
				} else {
					globalRepository = new HashMap();
					dispatcher = new EventDispatcher(this);
				}
			}
		}
 	 	
 	 	override flash_proxy function callProperty(methodName:*, ... args):* {
	        var result:*;
	       	switch (methodName.toString()) {
	            default:
	                result = globalRepository.getValue(methodName).apply(globalRepository, args);
	            break;
	        }
	        return result;
	    }
	    
 	 	override flash_proxy function getProperty(name:*):* {
		    return globalRepository.getValue(name);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			var oldValue = globalRepository.getValue(name);
			globalRepository.put(name , value);
			
			if(oldValue !== value) {
				dispatchEvent(new GlobalEvent(GlobalEvent.PROPERTY_CHANGED,name));
			}
		}
		
		public function get length():int {
	    	var retval:int = globalRepository.size();
	    	return retval;
	    }
	    
	    public function containsValue(value:*):Boolean{
	    	var retval:Boolean = globalRepository.containsValue(value);
	   		return retval;
	    }
	    
	   	public function containsKey(name:String):Boolean{
	    	var retval:Boolean = globalRepository.containsKey(name);
	   		return retval;
	    }
	    
	   	public function put(name:String, value:*):void {
	    	globalRepository.put(name,value);
	    }
	    
	    public function take(name:*):* {
	    	return globalRepository.getValue(name);
	    }
	    
	    public function remove(name:String):void {
	    	globalRepository.remove(name);
	    }
	    
	    public function toString():String {
	    	var temp:Array = new Array();
	    	for (var key:* in globalRepository) {
	    		temp.push ("{" + key + ":" + globalRepository[key] + "}");
	    	}
	    	return temp.join(",");
	    }
	    
	    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
        	dispatcher.addEventListener(type, listener, useCapture, priority);
	    }
	           
	    public function dispatchEvent(evt:Event):Boolean{
	        return dispatcher.dispatchEvent(evt);
	    }
	    
	    public function hasEventListener(type:String):Boolean{
	        return dispatcher.hasEventListener(type);
	    }
	    
	    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
	        dispatcher.removeEventListener(type, listener, useCapture);
	    }
	                   
	    public function willTrigger(type:String):Boolean {
	        return dispatcher.willTrigger(type);
	    }
	}
}