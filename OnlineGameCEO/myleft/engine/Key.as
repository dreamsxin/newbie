package myleft.engine{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Key {

		public static  var keys:Object=new Object;
		public static  var codeArray:Array = [0,0,0,0];

		private static  var initialized:Boolean=false;

		//键盘按键
		private static  var VK_SPACE:uint=Keyboard.SPACE;

		private static  var VK_A:uint=65;// A
		private static  var VK_W:uint=87;// W
		private static  var VK_D:uint=68;// D
		private static  var VK_S:uint=83;// S

		//方向键
		private static  var VK_LEFT:uint=Keyboard.LEFT;
		private static  var VK_UP:uint=Keyboard.UP;
		private static  var VK_RIGHT:uint=Keyboard.RIGHT;
		private static  var VK_DOWN:uint=Keyboard.DOWN;

		public static function initialize(stage:Stage):void
		{
			if (! initialized)
			{

				// assign listeners for key presses and deactivation of the player
				stage.addEventListener(KeyboardEvent.KEY_DOWN,downKeys);
				stage.addEventListener(KeyboardEvent.KEY_UP,upKeys);
				stage.addEventListener(Event.DEACTIVATE,clearKeys);

				// mark initialization as true so redundant
				// calls do not reassign the event handlers
				initialized=true;
			}
		}
		public static function isDown(key:int):Boolean
		{
			return !!keys[key];
		}

		//this function will detect keys that are being pressed
		private static function downKeys(evt:KeyboardEvent):void {
			keys[evt.keyCode]=true;
			switch (evt.keyCode) {
				case VK_A ://左
					codeArray[0]=1;
					break;
				case VK_W ://上
					codeArray[1]=1;
					break;
				case VK_D ://右
					codeArray[2]=1;
					break;
				case VK_S ://下
					codeArray[3]=1;
					break;
				case VK_LEFT ://左
					codeArray[0]=1;
					break;
				case VK_UP ://上
					codeArray[1]=1;
					break;
				case VK_RIGHT ://右
					codeArray[2]=1;
					break;
				case VK_DOWN ://下
					codeArray[3]=1;
					break;
			}
		}
		//this function will detect keys that are being released
		private static function upKeys(evt:KeyboardEvent):void {

			//check if the is arrow key
			if (keys[evt.keyCode] != null) {
				//set the key to false
				keys[evt.keyCode]=false;
			}
			switch (evt.keyCode) {
				case VK_A ://左
					codeArray[0]=0;
					break;
				case VK_W ://上
					codeArray[1]=0;
					break;
				case VK_D ://右
					codeArray[2]=0;
					break;
				case VK_S ://下
					codeArray[3]=0;
					break;
				case VK_LEFT ://左
					codeArray[0]=0;
					break;
				case VK_UP ://上
					codeArray[1]=0;
					break;
				case VK_RIGHT ://右
					codeArray[2]=0;
					break;
				case VK_DOWN ://下
					codeArray[3]=0;
					break;
			}
		}
		private static function clearKeys(evt:Event):void {
			codeArray = [0,0,0,0];
			for each (var k:Object in keys) {
				k=false;
			}
		}
	}
}