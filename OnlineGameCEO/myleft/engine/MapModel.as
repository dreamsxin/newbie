package myleft.engine
{
	/**
	 * 地图模型类
	 * 
	 * @author myleft
	 * @version	1.0
	 * @date	2008-11-20
	 */	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import myleft.bounds.IBounds;
	import myleft.engine.ui.CharMovieClip;
	import myleft.engine.variable.MoveObject;
	
	public class MapModel
	{
		public var m_cellSize:uint;
		public var m_width:uint;
		public var m_height:uint;
		public var m_map:Array;
		
		private var m_AStar:AStar;
		
		public function MapModel()
		{
			m_map = new Array();
			m_AStar = new AStar(this);
		}
	
		public function isBlock(p_startX : int, p_startY : int, p_endX : int, p_endY : int) : int
		{
			if (p_endX < 0 || p_endX > m_width || p_endY < 0 || p_endY > m_height)
			{
				return 0;
			}
			try{
				return this.m_map[p_endY][p_endX];
			}
			catch (e:Error)
			{
				return 0;
			}
			return 0;
		}
		
		public function getMyCorners(ob:CharMovieClip, moveOb:MoveObject):Boolean {
			
			var obIB:IBounds = ob.isoBounds;
			//find corner points
			var upY:int = Math.floor((obIB.back + moveOb.diry * ob.speed) / this.m_cellSize);
			var downY:int = Math.floor((obIB.front + moveOb.diry * ob.speed-1) / this.m_cellSize);
			
			var leftX:int = Math.floor((obIB.left + moveOb.dirx * ob.speed) / this.m_cellSize);			
			var rightX:int = Math.floor((obIB.right + moveOb.dirx * ob.speed-1) / this.m_cellSize);

			//check if they are walls 
			var ul:Boolean = this.isWalkable (leftX, upY);
			var dl:Boolean = this.isWalkable (leftX, downY);
			var ur:Boolean = this.isWalkable (rightX, upY);
			var dr:Boolean = this.isWalkable (rightX, downY);
			return ul && dl && ur && dr;
		}

		//this function will finds if tile is walkable
		public function isWalkable(pointX:int, pointY:int):Boolean {

			if (pointX < 0 || pointX > m_width || pointY < 0 || pointY > m_height)
			{
				return false;
			}
			try{
				if (this.m_map[pointY][pointX]==1)
				{
					return true;
				}
			}
			catch (e:Error)
			{
				return false;
			}
			return false;
		}
		
		public function findPath(startPoint:Point, endPoint:Point):Array 
		{
			var m_path:Array = new Array();
			var startTime:int = getTimer();
			
			startPoint = new Point(Math.floor(startPoint.x / this.m_cellSize), Math.floor(startPoint.y / this.m_cellSize));
			endPoint = new Point(Math.floor(endPoint.x / this.m_cellSize), Math.floor(endPoint.y / this.m_cellSize));

			if (this.isWalkable(endPoint.x, endPoint.y) != 1)
			{
				return m_path;
			}
			
			m_path = this.m_AStar.find(startPoint.x, startPoint.y, endPoint.x, endPoint.y);

			return m_path;
		}
	}
}