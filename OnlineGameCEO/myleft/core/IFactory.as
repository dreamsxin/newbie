package myleft.core
{

	public interface IFactory
	{

		function newInstance ():*;
		
		/**
		 * @private
		 */
		function get properties ():Object;
		

		function set properties (value:Object):void;
	}
}