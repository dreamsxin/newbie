package myleft.core
{
	import myleft.data.INode;
	
	import flash.display.Sprite;
	
	/**
	 * The IContainer interface defines the methods necessary for display visual content associated with a particular data node.
	 */
	public interface IIsoContainer extends INode
	{
		//////////////////////////////////////////////////////////////////
		//	INCLUDE IN LAYOUT
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get includeInLayout ():Boolean;
		
		/**
		 * Flag indicating whether the <code>container</code> is included in the display list.
		 * The allows child objects to persist in memory while being removed from the display list.
		 */
		function set includeInLayout (value:Boolean):void;
		
		/**
		 * An array of all children whose <code>container</code> is present within the display list.
		 * 
		 * @see #includeInLayout
		 */
		function get displayListChildren ():Array;
		
		//////////////////////////////////////////////////////////////////
		//	CONTAINER
		//////////////////////////////////////////////////////////////////
		
		/**
		 * The depth of the <code>container</code> relative to its parent container.
		 * If the <code>container</code> is orphaned, then -1 is returned.
		 */
		function get depth ():int;
		
		/**
		 * The sprite that contains the visual assets.
		 */
		function get container ():Sprite;
		
		//////////////////////////////////////////////////////////////////
		//	RENDER
		//////////////////////////////////////////////////////////////////
		
		/**
		 * Initiates the various validation processes in order to display the IPrimitive.
		 * 
		 * @param recursive If true will tell child nodes to render through the display list.
		 */
		function render (recursive:Boolean = true):void;
	}
}