package myleft.engine.utils
{
    import flash.utils.Dictionary;

 
    dynamic public class HashMap extends Dictionary implements IMap
    {
        public function HashMap(useWeakReferences:Boolean = true)
        {
            super(useWeakReferences);
        }
        
        public function put(key:String, value:*):void
        {
            this[key] = value;    
        }

        public function remove(key:String):void
        {
            this[key] = null;
        }
        
        public function containsKey(key:String):Boolean
        {
            return this[key] != null
        }

        public function containsValue(value:*):Boolean
        {
            for (var prop:String in this) {
                
                if (this[prop] == value)
                {
                    return true
                }
            }
            return false;
        }

        public function getKey(value:*):String
        {
            for (var prop:String in this) {
                
                if (this[prop] == value)
                {
                    return prop
                }
            }
            return null;
        }

        public function getValue(key:String):*
        {
            if (this[key] != null)
            {
                return this[key];
            }
        }

        public function size():int
        {
            var size:int = 0;
            
            for (var prop:String in this) {
                
                if (this[prop] != null)
                {
                    size++;
                }        
            }
            return size;
        }
        

        public function isEmpty():Boolean
        {
            var size:int = 0;
            
            for (var prop:String in this) {
                
                if (this[prop] != null)
                {
                    size++;
                }    
            }    
            return size <= 0;
        }
   
        public function clear():void
        {
            for (var prop:String in this) {    
                        
                this[prop] = null;
            }
        }
    }
}



