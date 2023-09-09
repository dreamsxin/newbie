package myleft.engine.utils
{
   
    public interface IMap
    {
      
        function put(key:String, value:*):void
        
      
        function remove(key:String):void

      
        function containsKey(key:String):Boolean

      
        function containsValue(value:*):Boolean

        function getKey(value:*):String

        function getValue(key:String):*
     
        function size():int

        function isEmpty():Boolean

        function clear():void
    }
}



