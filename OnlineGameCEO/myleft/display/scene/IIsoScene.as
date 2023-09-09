package myleft.display.scene
{
	import myleft.bounds.IBounds;
	import myleft.core.IIsoContainer;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * The IIsoScene interface defines methods for scene-based classes that expect to group and control child objects in a similar fashion.
	 */
	public interface IIsoScene extends IIsoContainer
	{
		/**
		 * The IBounds for this object in 3D isometric space.
		 */
		function get isoBounds ():IBounds;
		
		/**
		 * An array of all invalidated children.
		 */
		function get invalidatedChildren ():Array;
		
		/**
		 * @private
		 */
		function get hostContainer ():DisplayObjectContainer;
		
		/**
		 * The host container which will contain the display list of the isometric display list.
		 * 
		 * @param value The host container.
		 */
		function set hostContainer (value:DisplayObjectContainer):void;
	}
}