package myleft.engine
{
	/* 内置库 */
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import myleft.core.ClassFactory;
	import myleft.core.IFactory;
	import myleft.display.IsoView;
	import myleft.display.primitive.IsoBox;
	import myleft.display.primitive.IsoRectangle;
	import myleft.display.renderers.DefaultShadowRenderer;
	import myleft.display.scene.IsoGrid;
	import myleft.display.scene.IsoScene;

	public class Game extends MovieClip {
		protected var hostContainer:DisplayObjectContainer;
		protected var mapXML:XML;
		protected var mapxmlloader:URLLoader;
		
		private var mapWidth:int;
		private var mapHeight:int;
		
		private var view:IsoView;
		private var scene:IsoScene;		//游戏场景
		private var grid:IsoGrid;
		
		public function Game(container:DisplayObjectContainer)
		{
			hostContainer = this;
			
			super();
			
			Debug.show = true;
			
			scene = new IsoScene();
			scene.hostContainer = hostContainer;
			scene.container.x = 50;
			
			grid = new IsoGrid();
			grid.showOrigin = false;
			
			view = new IsoView();
			view.clipContent = false;	//false 可以看到视窗外部
			view.scene = scene;
			
			//阴影
			var factory:IFactory = new ClassFactory(DefaultShadowRenderer);
			factory.properties = {shadowColor:0x000000, shadowAlpha:0.15, drawAll:false};
			scene.styleRenderers = [factory];
			
			mapxmlloader = new URLLoader();
			mapxmlloader.addEventListener( Event.COMPLETE, mapLoaded );
			
			loadMap("map");
		}
		
		public function loadMap(mapname:String):void {
			var request:URLRequest = new URLRequest( "xmls/maps/" + mapname + ".xml" );
			try {
				mapxmlloader.load( request );
			} catch (error:Error) {
				trace("Map Unable to load.");
			}
		}
		
		//载入地图完成
		private function mapLoaded( e:Event ):void {

			mapXML = XML(mapxmlloader.data);
			
			Debug.addLog(this.mapXML);

			grid.cellSize = mapXML.grid.@s;
			grid.setGridSize(mapXML.grid.@w, mapXML.grid.@l);	//width=50*60
			
			scene.addChild(grid);
			
			scene.render();
			
			view.setSize(mapXML.view.@w, mapXML.view.@h);
			
			hostContainer.addChild(view);
			
			createMap();
		}
		
		public function createMap():void{
			
			
		}
		
		public function addBox():void{
			var box:IsoBox = new IsoBox();
			box.setSize(25, 25, 25);
			box.moveTo(100, 20, 10);
			scene.addChild(box);
			
			var box0:IsoBox = new IsoBox();
			box0.setSize(25, 25, 25);
			box0.moveTo(100, 20, 35);
			box0.faceColors = [0xff0000, 0x00ff00, 0x0000ff, 0xff0000, 0x00ff00, 0x0000ff];
			box0.faceAlphas = [.5, .5, .5, .5, .5, .5];
			scene.addChild(box0);
			
			var box1:IsoBox = new IsoBox();
			box1.setSize(25, 25, 25);
			box1.moveTo(25, 0, 0);
			box1.faceColors = [0xff0000, 0x00ff00, 0x0000ff, 0xff0000, 0x00ff00, 0x0000ff];
			box1.faceAlphas = [.5, .5, .5, .5, .5, .5];
			scene.addChild(box1);
			
			var box2:IsoBox = new IsoBox();
			box2.lineThicknesses = [0, 0, 0, 1, 1, 1];
			box2.lineColors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
			box2.faceColors = [0x666666, 0x666666, 0x666666, 0x666666, 0x666666, 0x666666];
			box2.faceAlphas = [.5, .5, .5, .5, .5, .5];
			box2.setSize(25, 25, 25);
			box2.moveTo(-30, -30, 10);
			scene.addChild(box2);
			
			var box3:IsoBox = new IsoBox();
			box3.setSize(25, 25, 25);
			box3.moveTo(-30, -30, 35);
			scene.addChild(box3);
			
			scene.render();
		}
		
		public function addWall():void{
			var upwall:IsoRectangle = new IsoRectangle;
			upwall.faceColors = [0x00ff00];
			upwall.faceAlphas = [.5];
			upwall.moveTo(0, -10, 10);
			upwall.setSize(200, 0, 200);
			scene.addChild(upwall);
			
			var leftwall:IsoRectangle = new IsoRectangle;
			leftwall.faceColors = [0x0000ff];
			leftwall.faceAlphas = [.5];
			leftwall.moveTo(-10, 0, 10);
			leftwall.setSize(0, 200, 200);
			scene.addChild(leftwall);
			
			scene.render();
		}
		
		public function render():void{
			scene.render();
		}
	}
}