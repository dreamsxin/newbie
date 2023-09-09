package myleft.engine.ui
{
	import myleft.engine.core.BaseMovieClip;
	import myleft.engine.variable.MoveObject;
	
	import myleft.geom.*;

	public class CharMovieClip extends BaseMovieClip
	{
		
		public var oldspeed:Number = 10;
		public var speed:Number = 10;
		public var endPoint:Pt;
		public var findpath:Boolean = false;		
		public var oldpath:Array = new Array;
		public var m_path:Array = new Array;
		public var autoMove:Boolean = false;
		public var moveLen:Number = 0;
		
		public var moveObject:MoveObject = new MoveObject;

		public var moveTarget:TilePt = new TilePt();
		
		public var hud:CharHud;
		
		public function CharMovieClip()
		{
			super();
			
			hud = new CharHud("无敌星军");
			mainContainer.addChild(hud);
		}
		
		public function go():void
		{
			if (moveObject.dir == 1 && this.speed>0)
			{
				var xlen:Number = Math.ceil(moveObject.dirx * this.speed);
				var ylen:Number = Math.ceil(moveObject.diry * this.speed);
	
				var goPt:Pt = new Pt(this.x + xlen, this.y + ylen, this.z);
				if (this.moveLen>0)
				{
					if (Math.sqrt(Math.pow(xlen, 2) + Math.pow(ylen, 2))>= this.moveLen)
					{
						this.moveLen = 0;
						this.moveObject = new MoveObject;
						
						goPt = new Pt(this.moveTarget.x*global.mapModel.m_cellSize, this.moveTarget.y*global.mapModel.m_cellSize, this.z);
						
					}
					else
					{
						this.moveLen -= Math.sqrt(Math.pow(xlen, 2) + Math.pow(ylen, 2));
					}
				}
				
				this.moveTo(goPt.x, goPt.y, goPt.z);
				
				var viewPoint:Pt = IsoMath.isoToScreen(new Pt(this.x, this.y), true);
				global.view.currentX = viewPoint.x;
				global.view.currentY = viewPoint.y;
			}
		}
		
		override public function render (recursive:Boolean = true):void
		{
			if (bMcInvalidated == 2)
			{
				hud.x = - hud.width/2;
				hud.y = - childContainer.height;
				
				bMcInvalidated = 3;
			}
			super.render(recursive);
		}
	}
}