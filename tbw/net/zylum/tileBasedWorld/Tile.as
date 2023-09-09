package net.zylum.tileBasedWorld
{
    import flash.display.*;

    class Tile extends Sprite
    {
        var hl:Object;
        var c:uint;
        var sel:Boolean;
        var movable:Object;
        var h:Number;
        var t:Shape;
        const MAX_HEIGHT:Object = 120;
        var s:Number;

        function Tile(param1:Number, param2:Number, param3:Boolean, param4:uint)
        {
            this.s = param1;
            this.movable = param3;
            this.c = param4;
            this.hl = false;
            t = new Shape();
            setHeight(param2);
            addChild(t);
            return;
        }// end function

        function unSelect()
        {
            sel = false;
            drawTile();
            return;
        }// end function

        function drawTile()
        {
            t.graphics.clear();
            t.graphics.beginFill(Utils.xFormColor(this.c, (this.h + (sel ? (20) : (hl ? (10) : (0)))) / MAX_HEIGHT), 1);
            t.graphics.moveTo(0, -this.h);
            t.graphics.lineTo(Utils.xComp(this.s), -Utils.yComp(this.s) - this.h);
            t.graphics.lineTo(2 * Utils.xComp(this.s), -this.h);
            t.graphics.lineTo(Utils.xComp(this.s), Utils.yComp(this.s) - this.h);
            t.graphics.endFill();
            t.graphics.lineStyle();
            t.graphics.beginFill(Utils.xFormColor(this.c, (this.h - 15 + (sel ? (20) : (hl ? (10) : (0)))) / MAX_HEIGHT), 1);
            t.graphics.moveTo(0, -this.h);
            t.graphics.lineTo(0, 0);
            t.graphics.lineTo(Utils.xComp(this.s), Utils.yComp(this.s));
            t.graphics.lineTo(Utils.xComp(this.s), Utils.yComp(this.s) - this.h);
            t.graphics.endFill();
            t.graphics.beginFill(Utils.xFormColor(this.c, (this.h - 24 + (sel ? (20) : (hl ? (10) : (0)))) / MAX_HEIGHT), 1);
            t.graphics.moveTo(Utils.xComp(this.s), Utils.yComp(this.s) - this.h);
            t.graphics.lineTo(Utils.xComp(this.s), Utils.yComp(this.s));
            t.graphics.lineTo(2 * Utils.xComp(this.s), 0);
            t.graphics.lineTo(2 * Utils.xComp(this.s), -this.h);
            t.graphics.endFill();
            return;
        }// end function

        function unHighLight()
        {
            hl = false;
            drawTile();
            return;
        }// end function

        function select()
        {
            sel = true;
            drawTile();
            return;
        }// end function

        function setHeight(param1:Number)
        {
            this.h = param1;
            drawTile();
            return;
        }// end function

        function getHeight() : Number
        {
            return h;
        }// end function

        function getSize() : Number
        {
            return s;
        }// end function

        function setSize(param1:Number)
        {
            this.s = Math.min(MAX_HEIGHT, Math.max(0, h));
            drawTile();
            return;
        }// end function

        function highLight()
        {
            hl = true;
            drawTile();
            return;
        }// end function

    }
}
