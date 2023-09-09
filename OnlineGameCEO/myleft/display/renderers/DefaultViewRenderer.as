package myleft.display.renderers
{
	import myleft.core.IIsoDisplayObject;
	import myleft.display.IIsoView;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The DefaultViewRenderer iterates through the target view's scene's child objects and determines if they reside within the visible area.
	 */
	public class DefaultViewRenderer implements IViewRenderer
	{
		/**
		 * Generally for testing purposes.
		 * This draws bounding rectangle around all objects contained within the target view's scene.
		 */
		public var drawBounds:Boolean = false;
		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderView (view:IIsoView):void
		{
			var v:Sprite = Sprite(view);
			
			if (drawBounds)
			{
				v.graphics.clear();
				v.graphics.lineStyle(1, 0xff0000);
			}
			
			var rect:Rectangle = new Rectangle(0, 0, v.width, v.height);
			var pt:Point;
			
			var bounds:Rectangle;
			var intersection:Boolean;
			
			var child:IIsoDisplayObject;
			var children:Array = view.scene.children.slice();
			for each (child in children)
			{				
				bounds = child.getBounds(v);				
				child.includeInLayout = rect.intersects(bounds);
				
				if (drawBounds)
					v.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			}
		}
	}
}