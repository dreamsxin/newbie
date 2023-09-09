package net.zylum.tileBasedWorld
{

    class Node extends Object
    {
        var next:Object;
        var last:Node;
        var x:Object;
        var y:Number;

        function Node(param1:Number, param2:Number, param3:Node)
        {
            this.x = param1;
            this.y = param2;
            this.next = null;
            this.last = param3;
            return;
        }// end function

    }
}
