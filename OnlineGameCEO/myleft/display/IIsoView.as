package myleft.display
{
	import myleft.core.IIsoDisplayObject;
	import myleft.display.scene.IIsoScene;
	import myleft.geom.Pt;
	
	import flash.display.Sprite;
	
	/**
	 * The IIsoView interface defines methods necessary to properly perform panning, zooming and other display task for a given IIsoScene.
	 * The implementor normally wraps an IIsoScene with layout constraints.
	 */
	public interface IIsoView
	{
		/**
		 * @private
		 */
		function get scene ():IIsoScene;
		
		/**
		 * The child scene object that this IsoView wraps.
		 */
		function set scene (value:IIsoScene):void;
		
		/**
		 * This point is the coordinate position visually located at the center of the IIsoView relative to the scenes' host containers.
		 */
		function get currentPt ():Pt;
		
		/**
		 * @private
		 */
		function get currentX ():Number;
		
		/**
		 * The current x value of the coordintate position visually located at the center of the IIsoView relative to the scenes' host containers.
		 * This property is useful for targeting by tween engines.
		 * 
		 * @see #currentPt
		 */
		function set currentX (value:Number):void;
		
		/**
		 * @private
		 */
		function get currentY ():Number;
		
		/**
		 * The current y value of the coordintate position visually located at the center of the IIsoView relative to the scenes' host containers.
		 * This property is useful for targeting by tween engines.
		 * 
		 * @see #currentPt
		 */
		function set currentY (value:Number):void;
		
		/**
		 * Centers the IIsoView on a given pt within the current child scene objects.
		 * 
		 * @param pt The pt to pan and center on.
		 * @param isIsometric A flag indicating wether the pt parameter represents a pt in 3D isometric space or screen coordinates.
		 */
		function centerOnPt (pt:Pt, isIsometric:Boolean = true):void;
		
		/**
		 * Centers the IIsoView on a given IIsoDisplayObject within the current child scene objects.
		 * 
		 * @param iso The IIsoDisplayObject to pan and center on.
		 */
		function centerOnIso (iso:IIsoDisplayObject):void;
		
		/**
		 * Pans the child scene objects by a given amount in screen coordinate space.
		 * 
		 * @param px The x value to pan by.
		 * @param py the y value to pan by.
		 * 
		 * @see #currentPt
		 */
		function pan (px:Number, py:Number):void;
		
		/**
		 * Zooms the child scene objects by a given amount.
		 * 
		 * @param zFactor The positive non-zero value to scale the child scene objects by.  This corresponds to the child scene objects' containers' scaleX and scaleY properties.
		 */
		function zoom (zFactor:Number = 1):void;
		
		/**
		 * Resets the child scene objects to be centered within the IIsoView and returns the zoom factor back to a normal value.
		 */
		function reset ():void;
		
		/**
		 * Executes positional changes for background, scene and foreground objects.
		 */
		function render ():void;
		
		/**
		 * @private
		 */
		function get mainContainer ():Sprite;
	}
}