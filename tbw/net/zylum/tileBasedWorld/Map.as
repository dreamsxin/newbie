package net.zylum.tileBasedWorld
{

    class Map extends Object
    {
        var s:Number;
        var hm:Array;
        const EPSILON:Object = 0.01;
        var sm:Array;
        var d:Number;
        var h:Number;
        var cm:Array;
        var m:Array;
        var vm:Array;
        var w:Number;

        function Map(param1:Number, param2:Number, param3:Number, param4:Number)
        {
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            this.w = param1;
            this.h = param2;
            this.s = param3;
            this.d = param4;
            m = new Array();
            hm = new Array();
            sm = new Array();
            cm = new Array();
            vm = new Array();
            _loc_5 = 0;
            while (_loc_5 < param1)
            {
		m[_loc_5] = new Array();
		hm[_loc_5] = new Array();
		sm[_loc_5] = new Array();
		cm[_loc_5] = new Array();
		vm[_loc_5] = new Array();

                _loc_6 = 0;
                while (_loc_6 < param2)
                {
                    vm[_loc_5][_loc_6] = 0;

                    _loc_7 = Math.random();
                    if (_loc_7 < this.d && (_loc_5 != 1 || _loc_6 != 1))
                    {
                        var _loc_8:int;
                        sm[_loc_5][_loc_6] = 0;
                        hm[_loc_5][_loc_6] = _loc_8;
                        m[_loc_5][_loc_6] = new Tile(this.s, 7, false, 39423);
                    } 
		    else
		    {
			hm[_loc_5][_loc_6] = Math.floor(Math.pow(Math.random(), 5) * 5) * 10 + 10;
			sm[_loc_5][_loc_6] = (hm[_loc_5][_loc_6] - 10) / 5 + 10;
			m[_loc_5][_loc_6] = new Tile(this.s, hm[_loc_5][_loc_6], true, 16750848);
		    }
		    //trace(m[_loc_5][_loc_6]);
		    //trace('_loc_5'+_loc_5+'_loc_6'+_loc_6);
		    _loc_6++;
                }
		_loc_5++;
            }
            cm = hm;
            return;
        }

        function update()
        {
            var _loc_1:*;
            var _loc_2:*;
            _loc_1 = 0;
            while (_loc_1 < w)
            {
                _loc_2 = 0;
                while (_loc_2 < h)
                {
                    
                    if (m[_loc_1][_loc_2].movable)
                    {
                        m[_loc_1][_loc_2].setHeight(m[_loc_1][_loc_2].h + (cm[_loc_1][_loc_2] - m[_loc_1][_loc_2].h) / 10);
                    }
		    _loc_2++;
                }
		_loc_1++;
            }
            return;
        }

        function squish()
        {
            cm = sm;
            return;
        }

        function unsquish()
        {
            cm = hm;
            return;
        }

        function isAnimating() : Boolean
        {
            var _loc_1:Boolean;
            var _loc_2:*;
            var _loc_3:*;
            _loc_1 = false;
            _loc_2 = 0;
            while (_loc_2 < w)
            {
                
                _loc_3 = 0;
                while (_loc_3 < h)
                {
                    
                    if (Math.abs(vm[_loc_2][_loc_3]) > EPSILON || m[_loc_2][_loc_3].movable && Math.abs(cm[_loc_2][_loc_3] - m[_loc_2][_loc_3].h) > EPSILON)
                    {
                        _loc_1 = true;
                        break;
                    }
		    _loc_3++;
                }
		_loc_2++;
            }
            if (true)
            {
                _loc_2 = 0;
                while (_loc_2 < w)
                {
                    
                    _loc_3 = 0;
                    while (_loc_3 < h)
                    {
                        
                        if (m[_loc_2][_loc_3].movable)
                        {
                            m[_loc_2][_loc_3].h = cm[_loc_2][_loc_3];
                        }
			_loc_3++;
                    }
		    _loc_2++;
                }
            }
            return _loc_1;
        }

    }
}
