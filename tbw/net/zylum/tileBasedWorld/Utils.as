package net.zylum.tileBasedWorld
{

    class Utils extends Object
    {
        static var keys:Array = new Array(256);

        function Utils()
        {
            var _loc_1:*;
            _loc_1 = 0;
            while (_loc_1 < keys.length)
            {
                // label
                keys[_loc_1] = false;
		_loc_1++ ;
            }// end while
            return;
        }// end function

        static function yComp(param1:Number) : Number
        {
            return xComp(param1) / 2;
        }// end function

        static function xFormColor(param1:uint, param2:Number) : uint
        {
            var _loc_3:uint;
            var _loc_4:uint;
            var _loc_5:uint;
            var _loc_6:uint;
            _loc_3 = 0;
            _loc_4 = param1 & 255;
            _loc_5 = param1 >> 8 & 255;
            _loc_6 = param1 >> 16 & 255;
            _loc_4 = Math.min(255, Math.max(0, _loc_4 + 245 * param2));
            _loc_5 = Math.min(255, Math.max(0, _loc_5 + 245 * param2));
            _loc_6 = Math.min(255, Math.max(0, _loc_6 + 245 * param2));
            _loc_3 = _loc_3 | uint(_loc_4);
            _loc_3 = _loc_3 | uint((_loc_5 & 255) << 8);
            _loc_3 = _loc_3 | uint((_loc_6 & 255) << 16);
            return _loc_3;
        }// end function

        static function xComp(param1:Number) : Number
        {
            return Math.sqrt(2 * param1 * param1) / 2;
        }// end function

    }
}
