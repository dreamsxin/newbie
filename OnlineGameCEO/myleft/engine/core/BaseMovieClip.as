package myleft.engine.core
{
	import flash.display.MovieClip;
	
	import myleft.core.IsoDisplayObject;
	import myleft.core.myleft_internal;
	import myleft.display.IsoView;
	import myleft.bounds.IBounds;
	import myleft.geom.*;
	import myleft.engine.utils.Global;
	
	use namespace myleft_internal;

	public class BaseMovieClip extends IsoDisplayObject
	{
		public var global:Global = Global.getInstance();
		public var childContainer:MovieClip;
		public var frame:Number = 1;
		
		protected var bMcInvalidated:uint = 0;
		protected var mcArray:Array = [];
		
		public function BaseMovieClip ()
		{
			super();
		}
		
		
		public function get mc ():Array
		{
			return mcArray;
		}

		public function set mc (value:Array):void
		{
			if (mcArray != value)
			{
				mcArray = value;
				bMcInvalidated = 1;
			}
		}

		override public function render (recursive:Boolean = true):void
		{
			if (bMcInvalidated == 1)
			{
				//remove all previous skins				
				while (childContainer.numChildren > 0)
					childContainer.removeChildAt(mainContainer.numChildren - 1);
				
				var mc:Object;
				for each (mc in mcArray)
				{
					var mcInstance:MovieClip;
					
					if (mc is MovieClip)
					{
						mcInstance = mc as MovieClip;
					}
					else if (mc is Class)
					{
						mcInstance = MovieClip(new mc());
					}
					else
					{
						throw new Error("is not of the following types: MovieClip or Class cast as MovieClip.");
					}
					mcInstance.gotoAndPlay(this.frame);
					childContainer.addChild(mcInstance);
				}
				
				bMcInvalidated = 2;
			}
			
			super.render(recursive);
		}
		
		override protected function createChildren ():void
		{
			super.createChildren();
			
			mainContainer = new MovieClip();
			childContainer = new MovieClip();
			mainContainer.addChild(childContainer);
		}

		public function setPosition(x:Number, y:Number, z:Number = 0):void{
			this.moveTo(x, y, z);
		}
		
		public function setMc(_sprites:Array, _frame:Number = 1):void{
			this.mc = _sprites;
			this.frame = _frame;
		}
		
		public function get tilept():TilePt
		{
			return new TilePt(Math.floor((this.x+this.width/2)/global.mapModel.m_cellSize), Math.floor((this.y+this.length/2)/global.mapModel.m_cellSize), Math.floor(this.z/global.mapModel.m_cellSize));
		}
		
		public function get point():Pt
		{
			return new Pt(Math.floor(this.x+this.width/2), Math.floor(this.y+this.length/2), Math.floor(this.z+this.height/2));
		}
		
		public function get bounds():IBounds
		{
			return this.isoBounds;
		}
	}
}