package net.zylum.tileBasedWorld
{

    class BFS extends Object
    {
        var path:Array;
        var m:Array;
        var t:Array;
        var dy:Object;
        var dx:Object;

        function BFS(param1:Array)
        {
            dx = new Array(1, -1, 0, 0);
            dy = new Array(0, 0, 1, -1);
            this.m = param1;
            return;
        }

        function traverse(param1:Number, param2:Number, param3:Queue) : Boolean
        {
            var _loc_4:Node;
            var _loc_5:*;
            if (param3.isEmpty())
            {
                return false;
            }
            _loc_4 = param3.pop();
            if (_loc_4.x == param1 && _loc_4.y == param2)
            {
                path.push(_loc_4);
                return true;
            }
            _loc_5 = 0;
            while (_loc_5 < 4)
            {
                // label
                if (_loc_4.x + dx[_loc_5] >= 0 && _loc_4.x + dx[_loc_5] < m.length && _loc_4.y + dy[_loc_5] >= 0 && _loc_4.y + dy[_loc_5] < m[0].length && t[_loc_4.x + dx[_loc_5]][_loc_4.y + dy[_loc_5]] && m[_loc_4.x + dx[_loc_5]][_loc_4.y + dy[_loc_5]] != 0 && m[_loc_4.x + dx[_loc_5]][_loc_4.y + dy[_loc_5]] - m[_loc_4.x][_loc_4.y] <= 10)
                {
                    param3.push(new Node(_loc_4.x + dx[_loc_5], _loc_4.y + dy[_loc_5], _loc_4));
                    t[_loc_4.x + dx[_loc_5]][_loc_4.y + dy[_loc_5]] = false;
                }
		_loc_5++;
            }
            if (traverse(param1, param2, param3))
            {
                if (path[path.length-1].last != null)
                {
                    path.push(path[path.length-1].last);
                }
                return true;
            }
            return false;
        }

        function findPath(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
        {
            var _loc_5:Queue;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            if (param1 == param3 && param2 == param4)
            {
                return false;
            }
            path = new Array();
            _loc_5 = new Queue();
            _loc_5.push(new Node(param1, param2, null));
            t = new Array(m.length);
            _loc_6 = 0;
            while (_loc_6 < t.length)
            {
                // label
                t[_loc_6] = new Array(m[_loc_6].length);
                _loc_8 = 0;
                while (_loc_8 < t[_loc_6].length)
                {
                    // label
                    t[_loc_6][_loc_8] = true;
		    _loc_8++;
                }
		_loc_6++;
            }
            t[param1][param2] = false;
            _loc_7 = traverse(param3, param4, _loc_5);
            path.pop();
            return _loc_7;
        }

    }
}
