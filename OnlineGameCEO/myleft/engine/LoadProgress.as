package myleft.engine
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class LoadProgress extends MovieClip
	{
		private var messageText:TextField = new TextField();
		private var barSprite:Sprite = new Sprite();
		public function LoadProgress()
		{
			var myformat:TextFormat = new TextFormat( "_sans", 12, 0xff9900, true );
			var myglow:GlowFilter = new GlowFilter(0x333333, 1, 2, 2, 3, 2, false, false);	//发光效果
			
			messageText.autoSize = TextFieldAutoSize.LEFT;
			messageText.defaultTextFormat = myformat;
			messageText.selectable = false;			
			messageText.filters = [ myglow ];
			messageText.text = "正在载入中";
			addChild( messageText );
			
			barSprite.y = messageText.height;
			addChild(barSprite);
			
		}
		
		public function show(message:String, progress:Number = 0, progresslength:Number = 0, type:Boolean = false):void
		{
			this.visible = true;
			//message			
			messageText.text = message;
			barSprite.graphics.clear();
			if (type)
			{
				barSprite.graphics.beginFill( 0x333333, .5 );
				barSprite.graphics.drawRect( 0, 0, progresslength, 5 );
				barSprite.graphics.endFill();
				
				barSprite.graphics.beginFill( 0xff0000, 1 );
				barSprite.graphics.drawRect( 0, 0, progress * (progresslength/100), 5 );
				barSprite.graphics.endFill();
			}
		}
		
		public function hide():void
		{	
			this.visible = false;
		}

	}
}