package net.zylum.tileBasedWorld
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;

    public class TBWGame extends Sprite
    {
        var px:Object;
        var py:Object;
        var path:BFS;
        var pos:TextField;
        var moving:Boolean;
        var d:Number;
        var h:Number;
        var p:Object;
        var m:Map;
        var w:Object;
        var t:Tile;
        var ts:Number;
        var nextNode:Node;
        var moved:Number;
        var ph:Number;

        public function TBWGame()
        {
            var tts:Array;

            var i:uint;
            var j:uint;
            stage.frameRate = 32;
            pos = new TextField();
            pos.text = "-1, -1";
            pos.backgroundColor = 14540253;
            pos.background = true;
            pos.border = true;
            pos.autoSize = TextFieldAutoSize.LEFT;
            pos.x = stage.stageWidth / 2 - pos.width / 2;
            pos.y = stage.stageHeight - 30;
            addChild(pos);
            moving = false;
            moved = 0;
            ts = 40;
            w = 10;
            h = 10;
            d = 0.05;
            t = null;
            m = new Map(w, h, ts, d);
            p = new Tile(ts * 0.5, ts * 0.5, false, 10066329);
            p.mouseEnabled = false;
            tts = new Array();
            i = w;

            while (i > 0)
            {
		i--;
                // label
                j = 0;
                while (j < h)
                {

                    m.m[i][j].x = i * Utils.xComp(ts) + j * Utils.xComp(ts) + (stage.stageWidth - 2 * Utils.xComp(ts * w)) / 2;
                    m.m[i][j].y = j * Utils.yComp(ts) - i * Utils.yComp(ts) + stage.stageHeight / 2;
                    trace('x'+m.m[i][j].x+'y'+m.m[i][j].y);
		    tts.push(m.m[i][j]);
                    m.m[i][j].addEventListener(MouseEvent.MOUSE_OVER, highLight);
                    m.m[i][j].addEventListener(MouseEvent.MOUSE_OUT, unHighLight);
                    m.m[i][j].addEventListener(MouseEvent.MOUSE_DOWN, select);
                   j++;
                }
            }

            path = new BFS(m.hm);

            tts.sort(tileSort);
			
            var _loc_2:Tile;
            for each (_loc_2 in tts)
            {
                addChild(_loc_2);
            }
            px = 1;
            py = 1;
            m.m[px][py].addChild(p);
            p.x = p.x + Utils.xComp(ts) / 2;
            p.y = p.y - p.parent.h;
            ph = p.parent.h;
            graphics.lineStyle(2, 0);
            graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
            addEventListener(Event.ENTER_FRAME, animate);
            return;
        }

	function tileSort (param1:Tile, param2:Tile)
	{
	    
	    if (param1.x < param2.x)
	    {
		return true;
	    }
	    else if (param1.y > param2.y)
	    {
		return true;
	    }
	    else if (param1.h <= param2.h)
	    {
		return true;
	    }
	    else
	    {
		return false;
	    }
	}

        function select(param1:MouseEvent)
        {
            var _loc_2:*;
            if (t == null && Tile(param1.target).movable)
            {
                if (path.findPath(orthox(p.parent), orthoy(p.parent), orthox(Tile(param1.target)), orthoy(Tile(param1.target))))
                {
                    t = Tile(param1.target);
                    t.select();
                    moving = true;
                    nextNode = path.path.pop();
                }
                for each (_loc_2 in path.path)
                {
                    // label
                    m.m[_loc_2.x][_loc_2.y].highLight();
                }// end of for each ... in
            }
            return;
        }

        function unHighLight(param1:MouseEvent)
        {
            if (t == null)
            {
                Tile(param1.target).unHighLight();
            }
            return;
        }

        function keyUpListener(param1:KeyboardEvent)
        {
            Utils.keys[param1.keyCode] = false;
            if (!Utils.keys[Keyboard.SPACE])
            {
                m.unsquish();
            }
            return;
        }

        function keyDownListener(param1:KeyboardEvent)
        {
            Utils.keys[param1.keyCode] = true;
            if (Utils.keys[Keyboard.SPACE])
            {
                m.squish();
            }
            return;
        }

        function highLight(param1:MouseEvent)
        {
            if (t == null)
            {
                Tile(param1.target).highLight();
                pos.text = orthox(Tile(param1.target)) + ", " + orthoy(Tile(param1.target));
            }
            return;
        }

        function orthoy(param1:Tile) : Number
        {
            var _loc_2:Number;
            var _loc_3:Number;
            _loc_2 = param1.x - (stage.stageWidth - 2 * Utils.xComp(ts * w)) / 2;
            _loc_3 = param1.y - stage.stageHeight / 2;
            return Math.round((_loc_2 / Utils.xComp(ts) + _loc_3 / Utils.yComp(ts)) / 2);
        }

        function orthox(param1:Tile) : Number
        {
            var _loc_2:Number;
            var _loc_3:Number;
            _loc_2 = param1.x - (stage.stageWidth - 2 * Utils.xComp(ts * w)) / 2;
            _loc_3 = param1.y - stage.stageHeight / 2;
            return Math.round(_loc_2 / Utils.xComp(ts) - orthoy(param1));
        }

        function animate(param1:Event)
        {
            var _loc_2:Number;
            var _loc_3:Number;
            if (m.isAnimating())
            {
                m.update();
            }
            if (moving)
            {
                m.m[nextNode.x][nextNode.y].unHighLight();
                m.m[nextNode.x][nextNode.y].unSelect();
                if (moved == 0 && m.m[nextNode.x][nextNode.y].h > ph)
                {
                    p.y = p.y + (ph - m.m[nextNode.x][nextNode.y].h);
                    ph = m.m[nextNode.x][nextNode.y].h;
                }
                _loc_2 = nextNode.x - px;
                _loc_3 = nextNode.y - py;
                if (moved == 0 && (_loc_2 < 0 || _loc_3 > 0))
                {
			trace('ttt2')
                    p.x = p.x - Utils.xComp(ts) * (_loc_2 + _loc_3 > 0 ? (1) : (-1));
                    p.y = p.y - Utils.yComp(ts) * (_loc_2 - _loc_3 > 0 ? (-1) : (1));
                    p.parent.removeChild(p);
                    m.m[nextNode.x][nextNode.y].addChild(p);
                }
                p.x = p.x + Utils.xComp(5) * (_loc_2 + _loc_3 > 0 ? (1) : (-1));
                p.y = p.y + Utils.yComp(5) * (_loc_2 - _loc_3 > 0 ? (-1) : (1));
                moved++;
                if (moved == ts / 5)
                {
			trace('ttt1')
                    if (m.m[nextNode.x][nextNode.y].h < ph)
                    {
                        p.y = p.y + (ph - m.m[nextNode.x][nextNode.y].h);
                    }
                    px = nextNode.x;
                    py = nextNode.y;
                    if (_loc_2 > 0 || _loc_3 < 0)
                    {
			trace('ttt0')
                        p.x = p.x - Utils.xComp(ts) * (_loc_2 + _loc_3 > 0 ? (1) : (-1));
                        p.y = p.y - Utils.yComp(ts) * (_loc_2 - _loc_3 > 0 ? (-1) : (1));
                        p.parent.removeChild(p);
                        m.m[nextNode.x][nextNode.y].addChild(p);
                    }
                    p.x = Utils.xComp(ts) / 2;
                    p.y = -p.parent.h;
                    ph = p.parent.h;
                    moved = 0;
                    if (path.path.length > 0)
                    {
                        nextNode = path.path.pop();
                    }
                    else
                    {
                        moving = false;
                        t = null;
                    }
                }
            }
            return;
        }

    }
}