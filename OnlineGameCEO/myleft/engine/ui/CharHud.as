package myleft.engine.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CharHud extends MovieClip
	{
		public var nicknameText:TextField;
		// ==============================================================================
		// PRIVATE MEMBERS                                               PRIVATE MEMBERS
		// ======== =====================================================================
		private var nameSprite:Sprite = new Sprite();
		private var hpSprite:Sprite = new Sprite();
		
		
		public function CharHud(_name:String = '')
		{
			super();
			this.drawName(_name);
			this.addChild(nameSprite);
			
			this.drawHP();
			hpSprite.y = nameSprite.y + nameSprite.height;
			this.addChild(hpSprite);
		}
		
		public function set nickname(value:String):void
		{
			this.nicknameText.text = value;
		}
		
		public function get nickname():String
		{
			return this.nicknameText.text;
		}
		
		private function drawName(_name:String):void
		{
			var myformat:TextFormat = new TextFormat( "_sans", 12, 0xff9900, false );
			var myglow:GlowFilter = new GlowFilter(0x333333, 1, 2, 2, 3, 2, false, false);	//发光效果
			
			myformat.bold = true;
			
			nicknameText = new TextField();
			nicknameText.autoSize = TextFieldAutoSize.LEFT;
			nicknameText.defaultTextFormat = myformat;
			nicknameText.selectable = false;
			nicknameText.text = _name;
			nicknameText.filters = [ myglow ];
			this.nameSprite.addChild( nicknameText );
		}
		
		private function drawHP():void{
			
			var barback:Sprite = new Sprite();
			
			barback.graphics.beginFill( 0x333333, .5 );
			barback.graphics.drawRect( 0, 0, 60, 3 );
			barback.graphics.endFill();
			this.hpSprite.addChild( barback );

			var bars:Sprite = new Sprite();
			
			bars.graphics.beginFill( 0xff0000, 1 );
			bars.graphics.drawRect( 0, 0, 30, 3 );
			bars.y = barback.y;
			bars.graphics.endFill();
			
			this.hpSprite.addChild( bars );
		}
		
	}
}