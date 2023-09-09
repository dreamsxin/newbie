package myleft.core
{
	import myleft.bounds.IBounds;
	import myleft.data.INode;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * The IIsoDisplayObject interface defines methods for any base display class needing rendering within an 3D isometric space.
	 */
	public interface IIsoDisplayObject extends INode, IIsoContainer
	{

		function get isoBounds ():IBounds;
		
		function get screenBounds ():Rectangle;
		
		
		function getBounds (targetCoordinateSpace:DisplayObject):Rectangle
		
		function get distance ():Number;
		
		function set distance (value:Number):void;
		
		function moveTo (x:Number, y:Number, z:Number):void;
		
		
		function moveBy (x:Number, y:Number, z:Number):void;
		
		function get x ():Number;
		
	
		function set x (value:Number):void;
		
	
		function get y ():Number;
	
		function set y (value:Number):void;
		
		/**
		 * @private
		 */
		function get z ():Number;
		
		/**
		 * The z value in 3D isometric space.
		 */ 
		function set z (value:Number):void;
		

		function get screenX ():Number;
		
		function get screenY ():Number;
	
		function setSize (width:Number, length:Number, height:Number):void
		
		/**
		 * @private
		 */
		function get width ():Number;
		
	
		function set width (value:Number):void;
	
		function get length ():Number;
	
		function set length (value:Number):void;

		function get height ():Number;
	
		function set height (value:Number):void;

		function get isInvalidated ():Boolean;

		function invalidatePosition ():void;
		function invalidateSize ():void;
		function clone ():IIsoDisplayObject;
	}
}