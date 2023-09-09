package Game.Map{
	import flash.display.Sprite;//显示对象容器
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class MapBuilder extends MovieClip {//因为需要为方块增加属性，所以取MovieClip作为基类
		private var container:Sprite = new Sprite;
		private var floorBoard:Sprite = new Sprite;
		private var charBoard:Sprite = new Sprite;

		private var mapWidth:int = 10;
		private var mapHeight:int = 10;
		private var tileW:int=30;
		private var tileH:int=30;

		//铺设地面方块区
		public function MapBuilder(map:XML = null):void {

			if (map == null) {
				return;
			}
			mapWidth = map.baseinfo.@width;
			mapHeight = map.baseinfo.@height;

			tileW = map.baseinfo.@tilewidth;
			tileH = map.baseinfo.@tileheight;

			this.drawContainer(mapWidth, tileW, mapHeight, tileH);

			for (var i=0; i < mapWidth; ++i) {
				for (var j=0; j < mapHeight; ++j) {
					//地板
					var tileInfo:XMLList = map.tiles.tile.(@x == i && @y == j);
					if (tileInfo.length()!=0) {
						this.drawFloorBorad(tileInfo);
					}
					//角色
					var charInfo:XMLList = map.chars.char.(@x == i && @y == j);
					if (tileInfo.length()!=0) {
						this.drawCharBoard(charInfo);
					}

				}
			}
			//trace(floorBoard.numChildren);
			//trace(floorBoard.getChildByName("t_0_0"))
			this.addChild(floorBoard);
			this.addChild(charBoard);

			this.addEventListener(Event.ENTER_FRAME, detectKeys);
			this.addEventListener(KeyboardEvent.KEY_DOWN, detectKeys);
			this.addEventListener(KeyboardEvent.KEY_UP, detectKeys);
		}
		//显示背景
		private function drawContainer(mapWidth:int, tileW:int, mapHeight:int, tileH:int):void {
			addChild(container);

			//container.graphics.beginFill(0xCCCCCC);
			container.graphics.lineStyle(1, 0x000000, 1);
			container.graphics.drawRect(0, 0, mapWidth * tileW, mapHeight * tileH);

			container.graphics.lineStyle(1,0xCCCCCC,1,true);
			for (var i=0; i < mapWidth; ++i) {
				container.graphics.moveTo(i * tileW, 0);
				container.graphics.lineTo(i * tileW, mapHeight * tileH);
			}
			for (var j=0; j < mapHeight; ++j) {
				container.graphics.moveTo(0, j * tileH);
				container.graphics.lineTo(mapWidth * tileW, j * tileH);
			}
		}
		//显示地板
		private function drawFloorBorad(tileInfo:XMLList):void {

			if (tileInfo.attributes().length()!=5) {
				return;
			}
			var tile_name:String = "t_" + tileInfo.@x + "_" + tileInfo.@y;

			var walkable:Boolean = tileInfo.@walkable == "true" ? true : false;
			var frame:int = tileInfo.@frame;
			var tile:*;

			var tileclass:Class = getDefinitionByName(tileInfo.@mc) as Class;

			tile = new tileclass();
			tile.name = tile_name;

			tile.walkable = walkable;
			tile.frame = frame;

			tile.x = tileInfo.@x * this.tileW;
			tile.y = tileInfo.@y * this.tileH;
			tile.gotoAndStop(frame);

			this.floorBoard.addChild(tile);
			tile.addEventListener(MouseEvent.MOUSE_OVER, overTile);
			tile.addEventListener(MouseEvent.MOUSE_OUT, outTile);
			tile.addEventListener(MouseEvent.CLICK, clickTile);
		}
		private function overTile(evt:MouseEvent):void {
			//currentTarget 监听的对象 target 点击的对象
			if (evt.currentTarget.walkable) {
				//this.floorBoard.setChildIndex(evt.currentTarget as MovieClip, this.floorBoard.numChildren - 1);
				evt.currentTarget.gotoAndStop(5);
			}
		}
		private function outTile(evt:MouseEvent):void {
			//currentTarget 监听的对象 target 点击的对象
			if (evt.currentTarget.walkable) {
				//this.floorBoard.setChildIndex(evt.currentTarget as MovieClip, this.floorBoard.numChildren - 1);
				evt.currentTarget.gotoAndStop(evt.currentTarget.frame);
			}
		}
		private function clickTile(evt:MouseEvent):void {
			trace(evt.currentTarget.walkable);
		}
		//显示角色
		private function drawCharBoard(charInfo:XMLList):void {


			if (charInfo.attributes().length()!=5) {
				return;
			}
			var char_name:String = "c_" + charInfo.@x + "_" + charInfo.@y;

			var uid:int = charInfo.@uid;
			var speed:int = charInfo.@speed;
			var nickName:String = charInfo.toString();
			trace(nickName);
			var char:*;

			var charclass:Class = getDefinitionByName(charInfo.@mc) as Class;

			char = new charclass();
			char.name = char_name;
			char.uid = uid;
			char.speed = speed;
			char.nickName = nickName;


			char.x = charInfo.@x * this.tileW + this.tileW/2;
			char.y = charInfo.@y * this.tileH + this.tileH/2;

			this.charBoard.addChild(char);
		}
		private function detectKeys():void {
			
		}
	}
}