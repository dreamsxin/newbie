package net.zylum.tileBasedWorld
{

    class Queue extends Object
    {
        var head:Object;
        var tail:Node;

        function Queue()
        {
            head = null;
            return;
        }// end function

        function isEmpty() : Boolean
        {
            return head == null;
        }// end function

        function pop() : Node
        {
            var _loc_1:Node;
            _loc_1 = head;
            head = head.next;
            return _loc_1;
        }// end function

        function push(param1:Node)
        {
			 var _loc_2:* = param1;
            if (head == null)
            {
                tail = param1;
                head = _loc_2;
            }
            else
            {
                tail.next = param1;
                tail = _loc_2;
            }// end else if
            return;
        }// end function

    }
}
