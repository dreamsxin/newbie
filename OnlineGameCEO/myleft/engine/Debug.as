package myleft.engine
{
	public class Debug
	{
		public static var save:Boolean=false;
		public static var show:Boolean=false;
		private static var messages:Array=new Array();
		public function Debug()
		{
		}
		
		public static function addLog(message:String):void{
			
			if (save) messages.push(message);
			if (show) trace(message);
		}
		
		public static function getMessage():Array{
			return messages;
		}

	}
}