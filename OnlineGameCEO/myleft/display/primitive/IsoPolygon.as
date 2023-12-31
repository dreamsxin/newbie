package myleft.display.primitive
{
	import myleft.core.myleft_internal;
	import myleft.enum.RenderStyleType;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	use namespace myleft_internal;
	
	/**
	 * 3D polygon primitive in isometric space.
	 */
	public class IsoPolygon extends IsoPrimitive
	{
		/**
		 * @inheritDoc
		 */
		override protected function validateGeometry ():Boolean
		{
			return pts.length > 2;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawGeometry ():void
		{
			var g:Graphics = mainContainer.graphics;
			g.clear();
			g.moveTo(pts[0].x, pts[0].y);
			
			if (styleType == RenderStyleType.SHADED)
				g.beginFill(faceColors[0], faceAlphas[0]);
			
			else if (styleType == RenderStyleType.SOLID)
				g.beginFill(0xffffff, faceAlphas[0]);
				
			else if (styleType == RenderStyleType.WIREFRAME)
				g.beginFill(0xff0000, 0.0);
			
			else
				return;
			
			g.lineStyle(lineThicknesses[0], lineColors[0], lineAlphas[0], true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.ROUND);
			
			var i:uint = 1;
			var l:uint = pts.length;
			while (i < l)
			{
				g.lineTo(pts[i].x, pts[i].y);
				i++;
			}
				
			g.lineTo(pts[0].x, pts[0].y);
			g.endFill();
		}
		
		////////////////////////////////////////////////////////////////////////
		//	PTS
		////////////////////////////////////////////////////////////////////////
		
		[ArrayElementType("myleft.geom.Pt")]
		private var geometryPts:Array = [];
		
		/**
		 * @private
		 */
		public function get pts ():Array
		{
			return geometryPts;
		}
		
		/**
		 * The set of points in isometric space needed to render the polygon.  At least 3 points are needed to render.
		 */
		public function set pts (value:Array):void
		{
			if (geometryPts != value)
			{
				geometryPts = value;
				invalidateSize();
				
				if (autoUpdate)
					render();
			}
		}
		
		/**
		 * Constructor
		 */
		public function IsoPolygon ()
		{
			super();
		}
	}
}