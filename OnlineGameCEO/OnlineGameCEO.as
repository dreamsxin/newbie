package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import myleft.bounds.IBounds;
	import myleft.core.ClassFactory;
	import myleft.display.IsoView;
	import myleft.display.primitive.IsoBox;
	import myleft.display.renderers.DefaultViewRenderer;
	import myleft.display.scene.*;
	import myleft.engine.*;
	import myleft.engine.events.*;
	import myleft.engine.ui.*;
	import myleft.engine.utils.Global;
	import myleft.engine.variable.MoveObject;
	import myleft.events.ProxyEvent;
	import myleft.geom.*;
	
	import org.aswing.*;
	import org.aswing.event.*;

	public class OnlineGameCEO extends Sprite {
		
		private var global:Global = Global.getInstance();
		
		private var _MainJFrame:JFrame;
		private var myButton:JButton;
		
		private var controlStatus:uint = 0;

		private var mapXML:XML;
		private var mapxmlloader:URLLoader;

		private var floorsXML:XMLList;
		private var spritesXML:XMLList;

		//地图资源载入
		protected var swfload:SWFLoad;

		//进度条
		protected var progress:LoadProgress;

		private var view:IsoView;
		private var scene:IsoScene;//游戏场景
		private var grid:IsoGrid;

		private var hero:CharMovieClip;

		public function OnlineGameCEO() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 24;
			
			AsWingManager.initAsStandard(this);

			myButton = new JButton("行走");
			myButton.addActionListener(__buttonClicked);

			_MainJFrame = new JFrame(this, "OnlineGameCEO");
			_MainJFrame.setClosable(false);
			_MainJFrame.setResizable(false);
			_MainJFrame.setDragable(false);
			_MainJFrame.getContentPane().setLayout(new BorderLayout());
			_MainJFrame.getContentPane().append(myButton, BorderLayout.NORTH);
			
			var window:JWindow = new JWindow(this,true);
			window.setSizeWH(300,200);
			_MainJFrame.getContentPane().append(window, BorderLayout.SOUTH);
			
			Debug.show = true;
			
			global.isInvalidated = false;
			global.mouseStatus = new MouseStatus;
			
			var mapModel:MapModel = new MapModel();
			global.mapModel = mapModel;

			scene = new IsoScene();
			global.scene = scene;

			scene.hostContainer = this;
			//scene.layoutEnabled = false;

			//视图
			view = new IsoView();
			global.view = view;
			
			view.clipContent = false;//true false 是否隐藏外部物件 
			view.viewRenderers = [new ClassFactory(DefaultViewRenderer)];	//关闭超出范围的对象
			view.scene = scene;
			
			this.addChild(view);

			mapxmlloader = new URLLoader();
			mapxmlloader.addEventListener( Event.COMPLETE, mapLoaded );

			this.swfload = new SWFLoad;
			this.progress = new LoadProgress;
			this.addChild(this.progress);
			
			this.createEventListener();

			loadMap("map");
		}
		
		private function __buttonClicked(e:AWEvent):void {
			if (global.mouseStatus.status == 1)
			{
				myButton.setText("行走");
				global.mouseStatus.status = 0;
			}
			else
			{
				myButton.setText("创建物体");
				global.mouseStatus.status = 1;
			}
		}
		
		private function createEventListener():void {
			Key.initialize( stage );
			stage.addEventListener(Event.ENTER_FRAME, runGame);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}
		
		public function loadMap(mapname:String):void {
			var request:URLRequest = new URLRequest( "xmls/maps/" + mapname + ".xml" );
			try {
				mapxmlloader.load( request );
			} catch (error:Error) {
				Debug.addLog("加载地图数据失败");
			}
		}
		
		private function onMouseWheelHandler(_evt:MouseEvent ):void
		{
			if (_evt.delta>0 && view.currentZoom<2)	//向上
			{
				view.zoom(view.currentZoom + 0.5);
				this.scene.invalidateScene();
			}
			else if (_evt.delta<0 && view.currentZoom >= 1.5)
			{
				view.zoom(view.currentZoom - 0.5);
				this.scene.invalidateScene();
			}
		}
		
		//载入地图完成
		private function mapLoaded( _evt:Event ):void {

			this.mapXML = XML(mapxmlloader.data);

			Debug.addLog("加载地图数据完成");

			this.floorsXML = mapXML.floors.floor;
			//
			this.drawHit(mapXML.hits.hit);

			this.drawGrid(mapXML.grid);

			this.view.setSize(mapXML.view.@w, mapXML.view.@h);
			
			_MainJFrame.setLocationXY(0, mapXML.view.@h);
			_MainJFrame.setSizeWH(mapXML.view.@w, 100);
			_MainJFrame.show();

			this.loadlibrary(mapXML.sprites.sprite);

		}
		//绘制Hit触摸板
		private function drawHit(xml:XMLList):void {
			for (var hity:int = 0; hity<xml.length(); hity++) {
				global.mapModel.m_map[hity] = xml[hity].split(",");
			}
		}
		private function drawGrid(xml:XMLList):void {
			global.mapModel.m_cellSize = xml.@s;
			global.mapModel.m_width = mapXML.grid.@w;
			global.mapModel.m_height = mapXML.grid.@l;

			grid = new IsoGrid();
			grid.showOrigin = false;

			grid.cellSize = xml.@s;
			grid.setGridSize(xml.@w, xml.@l);//width=50*60
			grid.moveTo(0,0,-10);

			scene.addChild(grid);
		}
		//加载资源
		private function loadlibrary(xml:XMLList):void {
			this.spritesXML = xml;

			var storelist:Array = new Array;
			for each (var sprite:XML in spritesXML) {
				storelist.push(sprite.@src);
			}
			this.swfload.multiload(storelist);
			this.swfload.addEventListener(LoadEvent.LOAD_INIT, this.createMap);
			this.swfload.addEventListener(LoadEvent.LOAD_PROGRESS, this.onProgress);
		}
		//绘制进度条
		private function onProgress(_evt:LoadEvent):void {
			this.progress.x = view.x;
			this.progress.y = view.y;
			this.progress.show(_evt.message, _evt.progress, 120, true);
		}
		public function createMap(evt:LoadEvent):void {
			progress.show("创建地图中...");

			this.drawFloor();

			hero = new CharMovieClip();
			hero.setSize(25, 25, 10);
			hero.moveTo(0, 0, 0);
			hero.setMc([SWFLoad.getClass("hero_0")], 1);
			scene.addChild(hero);
			
			var floor:FloorMovieClip = new FloorMovieClip();
			floor.setSize(25, 25, 29);
			floor.moveTo(25, 25, 0);
			floor.setMc([SWFLoad.getClass("floor_0")], 1);
			scene.addChild(floor);
			
			var floor2:FloorMovieClip = new FloorMovieClip();
			floor2.setSize(25, 25, 29);
			floor2.moveTo(50, 50, 0);
			floor2.setMc([SWFLoad.getClass("floor_0")], 1);
			scene.addChild(floor2);

			var box0:IsoBox = new IsoBox();
			box0.faceColors = [0xff0000, 0x00ff00, 0x0000ff, 0xff0000, 0x00ff00, 0x0000ff];
			box0.setSize(25, 25, 25);
			box0.moveTo(100, 100, 0);
			scene.addChild(box0);

			progress.hide();
			global.isInvalidated = true;
		}
		private function drawFloor():void 
		{
			var total:uint = this.floorsXML.length();
			var i:uint = 0;
			for each (var floorXML:XML in this.floorsXML) {
				i++;
				var size:Array = floorXML.@size.split(",");
				var pos:Array = floorXML.@pos.split(",");
				var sprite:Array = floorXML.@sprite.split(",");

				var color:uint = 0xFFCC00;
				if ((pos[0]/25 + pos[1]/25) % 2 == 0) {
					color = 0x669900;
				}
				var floor:IsoBox = new IsoBox();
				floor.autoUpdate = true;
				floor.lineThicknesses = [0, 0, 0, 1, 1, 1];
				floor.lineColors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
				floor.faceColors = [color, color, color, color, color, color];
				floor.faceAlphas = [.5, .5, .5, .5, .5, .5];
				floor.setSize(size[0], size[1], size[2]);
				floor.moveTo(pos[0], pos[1], pos[2]);
				floor.addEventListener(MouseEvent.ROLL_OVER, this.floorMouseHandle);
				floor.addEventListener(MouseEvent.ROLL_OUT, this.floorMouseHandle);
				floor.addEventListener(MouseEvent.CLICK, this.floorMouseHandle);

				scene.addChild(floor);
			}
		}

		private function floorMouseHandle(evt:ProxyEvent):void {
			
			var evtObject:Object = Object(evt.target);
			
			var evtObjectIB:IBounds = evtObject.isoBounds;
			
					
			if (evt.type == MouseEvent.ROLL_OVER) {
				evtObject.faceAlphas = [0.2, 0.2, 0.2, 0.2, 0.2, 0.2];
			} else if (evt.type == MouseEvent.ROLL_OUT) {
				evtObject.faceAlphas = [.5, .5, .5, .5, .5, .5];
			} 
			else if (evt.type == MouseEvent.CLICK) 
			{
				global.mouseStatus.point = new Pt(evtObjectIB.left, evtObjectIB.back, evtObjectIB.top);
				
				if (global.mouseStatus.status == 0)
				{
					hero.findpath = true;
					hero.endPoint = new Pt(evtObjectIB.left, evtObjectIB.back, evtObjectIB.top);
					//trace(evt.proxyTarget);
					
				}
				else if (global.mouseStatus.status == 1)
				{
					addFloor(global.mouseStatus.point);
				}

			}
		}
		
		private function addFloor(point:Pt):void
		{

			var floor2:FloorMovieClip = new FloorMovieClip();
			floor2.autoUpdate = true;
			floor2.setSize(25, 25, 29);
			floor2.moveTo(point.x, point.y, 0);
			floor2.setMc([SWFLoad.getClass("floor_0")], 1);
			scene.addChild(floor2);
			
			var floor4:FloorMovieClip = new FloorMovieClip();
			floor4.autoUpdate = true;
			floor4.setSize(25, 25, 29);
			floor4.moveTo(point.x+25, point.y, 0);
			floor4.setMc([SWFLoad.getClass("floor_0")], 1);
			scene.addChild(floor4);
		}

		private function autoMoveToPath():void {
			if (hero.m_path.length>0) 
			{
				if (hero.moveLen <= 0) 
				{
					hero.moveTarget = new TilePt(hero.m_path[0][0], hero.m_path[0][1]);
					hero.moveLen = Math.sqrt(Math.pow(hero.x - hero.moveTarget.x*global.mapModel.m_cellSize, 2) + Math.pow(hero.y - hero.moveTarget.y*global.mapModel.m_cellSize, 2));
					hero.m_path.shift();

					var moveOb:MoveObject = new MoveObject;

					moveOb.dir = 1;
					//right
					if (hero.moveTarget.x*global.mapModel.m_cellSize > hero.x) {
						moveOb.dirx = 1;
						//left
					} else if (hero.moveTarget.x*global.mapModel.m_cellSize < hero.x) {
						moveOb.dirx = -1;
					}
					if (hero.moveTarget.y*global.mapModel.m_cellSize > hero.y ) {
						moveOb.diry = 1;
					} else if (hero.moveTarget.y*global.mapModel.m_cellSize < hero.y) {
						moveOb.diry = -1;
					}
					
					hero.moveObject = moveOb;
				}
			}
		}

		private function runGame(evt:Event):void {
			if (global.isInvalidated)
			{
			
				if (hero!=null)
				{
					if (hero.findpath) 
					{
						hero.findpath = false;
						var startPoint:Point = new Point(hero.x, hero.y);
						hero.m_path = global.mapModel.findPath(startPoint, hero.endPoint);
						hero.oldpath = hero.m_path;
						if (hero.m_path && hero.m_path.length > 0) {
							hero.autoMove = true;
							hero.moveLen = 0;
							hero.moveObject = new MoveObject;
						}
					}
					var moveOb:MoveObject = new MoveObject;
					switch (Key.codeArray.join("")) {
						case "1000" ://左
							moveOb = new MoveObject(1, -1, 0, 0);
							break;
						case "0100" ://上
							moveOb = new MoveObject(1, 0, -1, 0);
							break;
						case "0010" ://右
							moveOb = new MoveObject(1, 1, 0, 0);
							break;
						case "0001" ://下
							moveOb = new MoveObject(1, 0, 1, 0);
							break;
					}
					//自动走路
					if (moveOb.dir==1) {
						hero.autoMove = false;
						hero.moveObject = new MoveObject;
					}
					if (hero.autoMove) {
						autoMoveToPath();
					} else {
						if (moveOb.dir == 1) 
						{
							hero.speed = hero.oldspeed;
							
							var pass:Boolean = false;
							for (hero.speed;hero.speed>0;hero.speed-- )
							{
								if (global.mapModel.getMyCorners(hero, moveOb))
								{
									pass = true;
									break;
								}
							}
							if (!pass)
							{
								hero.speed = hero.oldspeed;
								this.aroundWall(moveOb);
								moveOb.dirx = 0;
								moveOb.diry = 0;
							}
									
						}
						hero.moveObject = moveOb;
					}
					hero.go();
				}
				
				scene.render();
				view.render();
				stage.focus = this;
			}
		}
		private function aroundWall(moveOb:MoveObject):void {

			if(moveOb.dirx != 0)
			{

				if(global.mapModel.isWalkable(hero.tilept.x + moveOb.dirx, hero.tilept.y))
				{
					//align vertically
					var centerY:int = hero.tilept.y * global.mapModel.m_cellSize + global.mapModel.m_cellSize / 2;
					if(hero.point.y > centerY){
						//move up
						hero.y -= Math.abs(hero.point.y - centerY) > hero.speed ? hero.speed : Math.abs(hero.point.y - centerY);
					}else if(hero.point.y < centerY){
						//move down
						hero.y += Math.abs(hero.point.y - centerY) > hero.speed ? hero.speed : Math.abs(hero.point.y - centerY);
					}
				}
			}
			else
			{
				if(global.mapModel.isWalkable(hero.tilept.x, hero.tilept.y + moveOb.diry))
				{
					//align horisontal
					var centerX:int = hero.tilept.x * global.mapModel.m_cellSize + global.mapModel.m_cellSize / 2;
					if(hero.point.x > centerX){
						//move left
						hero.x -=Math.abs(hero.point.x - centerX) > hero.speed ? hero.speed : Math.abs(hero.point.x - centerX);
					}else if(hero.point.x < centerX){
						hero.x +=Math.abs(hero.point.x - centerX) > hero.speed ? hero.speed : Math.abs(hero.point.x - centerX);
					}
				}
			}
					
		}
	}
}