package myleft.display.renderers
{
	import myleft.bounds.IBounds;
	import myleft.core.IIsoDisplayObject;
	import myleft.display.scene.IIsoScene;
	import myleft.geom.IsoMath;
	import myleft.geom.Pt;
	
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	
	/**
	 * The DefaultShadowRenderer class is the default renderer for applying basic shadowing on child objects of an IIsoScene.
	 * This is intended to be an iterative renderer meaning the <code>target</code> is expected to be a child object rather than the parent scene.
	 */
	public class DefaultShadowRenderer implements ISceneRenderer
	{
		////////////////////////////////////////////////////
		//	STYLES
		////////////////////////////////////////////////////
		
		/**
		 * If a child's z <= 0 and drawAll = true the shadow will still be renderered.
		 */
		public var drawAll:Boolean = true;
		
		/**
		 * The color of the shadow.
		 */
		public var shadowColor:uint = 0x000000;
		
		/**
		 * The alpha level of the drawn shadow.
		 */
		public var shadowAlpha:Number = 0.15;
		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderScene (scene:IIsoScene):void
		{			
			g = scene.container.graphics;
			//g.clear(); - do not clear, may be overwriting other IIsoRenderer's efforts.  Do so in the scene.
			
			var shadowChildren:Array = scene.displayListChildren;
			var child:IIsoDisplayObject;
			for each (child in shadowChildren)
			{
				
				if (drawAll)
				{
					g.beginFill(shadowColor, shadowAlpha);
					drawChildShadow(child);
				}
				
				else
				{
					if (child.z > 0)
					{
						g.beginFill(shadowColor, shadowAlpha);
						drawChildShadow(child);
					}
				}
				
				g.endFill();
			}
		}
		
		private var g:Graphics;
		
		private function drawChildShadow (child:IIsoDisplayObject):void
		{
			var b:IBounds = child.isoBounds;
			var pt:Pt;
			
			pt = IsoMath.isoToScreen(new Pt(b.left, b.back, 0));
			g.moveTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(b.right, b.back, 0));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(b.right, b.front, 0));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(b.left, b.front, 0));
			g.lineTo(pt.x, pt.y);
			
			pt = IsoMath.isoToScreen(new Pt(b.left, b.back, 0));
			g.lineTo(pt.x, pt.y);
		}
	}
}