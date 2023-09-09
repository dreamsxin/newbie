package myleft.display.primitive
{
	import myleft.core.IIsoDisplayObject;
	
	/**
	 * The IIsoPrimitive interface defines methods for any IIsoDisplayObject class that is utilizing Flash's drawing API.
	 */
	public interface IIsoPrimitive extends IIsoDisplayObject
	{
		//////////////////////////////////////////////////////////////////
		//	STYLES
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		function get faceAlphas ():Array;
		
		/**
		 * An array of alpha values corresponding to the various faces (where applicable).
		 * For a given IsoBox the values would be assigned in order to: top, right, front, left, back, bottom
		 */
		function set faceAlphas (value:Array):void;
		
		/**
		 * @private
		 */
		function get faceColors ():Array;
		

		function set faceColors (value:Array):void;
		
		/**
		 * @private
		 */
		function get lineAlphas ():Array;
		

		function set lineAlphas (value:Array):void;
		
		/**
		 * @private
		 */
		function get lineColors ():Array;
		

		function set lineColors (value:Array):void;
		

		function get lineThicknesses ():Array;

		function set lineThicknesses (value:Array):void;

		function get styleType ():String;
		
		function set styleType (value:String):void;

		function invalidateStyles ():void;	
	}
}