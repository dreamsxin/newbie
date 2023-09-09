package myleft.display
{
	import myleft.core.IsoDisplayObject;
	import myleft.core.myleft_internal;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	use namespace myleft_internal;
	
	/**
	 * IsoSprite is the base class in which visual assets may be attached to be presented in 3D isometric space.
	 * Since visual assets may not clearly define a volume in 3D isometric space, the developer is responsible for establishing the width, length and height properties.
	 */
	public class IsoSprite extends IsoDisplayObject
	{
		////////////////////////////////////////////////////////////
		//	SKINS
		////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var spritesArray:Array = [];	
		
		/**
		 * @private
		 */
		public function get sprites ():Array
		{
			return spritesArray;
		}
		
		/**
		 * An array of visual assets to be attached.
		 * Elements in the array are expected be of type DisplayObject or Class (cast to a DisplayObject upon instantiation).
		 */
		public function set sprites (value:Array):void
		{
			if (spritesArray != value)
			{
				spritesArray = value;
				bSkinsInvalidated = true;
			}
		}
		
		////////////////////////////////////////////////////////////
		//	INVALIDATION
		////////////////////////////////////////////////////////////
		
		myleft_internal var bSkinsInvalidated:Boolean = false;
		
		/**
		 * Invalidates the skins of the IIsoDisplayObject.
		 */
		public function invalidateSkins ():void
		{
			bSkinsInvalidated = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get isInvalidated ():Boolean
		{
			return (bPositionInvalidated || bSkinsInvalidated);
		}
		
		////////////////////////////////////////////////////////////
		//	RENDER
		////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function render (recursive:Boolean = true):void
		{
			if (bSkinsInvalidated)
			{
				//remove all previous skins				
				while (mainContainer.numChildren > 0)
					mainContainer.removeChildAt(mainContainer.numChildren - 1);
				
				var sprite:Object;
				for each (sprite in spritesArray)
				{
					if (sprite is DisplayObject)
						mainContainer.addChild(sprite as DisplayObject);
					
					else if (sprite is Class)
					{
						var spriteInstance:DisplayObject = DisplayObject(new sprite());
						mainContainer.addChild(spriteInstance);
					}
					
					else
						throw new Error("skin asset is not of the following types: DisplayObject or Class cast as DisplayOject.");
				}
				
				bSkinsInvalidated = false;
			}
			
			super.render(recursive);
		}
		
		override protected function createChildren ():void
		{
			super.createChildren();
			
			mainContainer = new MovieClip();
		}
		
		////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoSprite ()
		{
			super();
		}
	}
}