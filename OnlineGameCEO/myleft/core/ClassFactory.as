package myleft.core
{

	public class ClassFactory implements IFactory
	{
		/**
		 * Constructor
		 * 
		 * @param generator The Class that the newInstance method uses to generate objects from this factory object.
		 */
		public function ClassFactory (generator:Class = null)
		{
			super();
			
			this.generator = generator;
		}
		
		////////////////////////////////////////////////////////////////
		//	PROPERTIES
		////////////////////////////////////////////////////////////////
		
		/**
		 * The Class that the newInstance method used to generate objects from this factory object.
		 */
		public var generator:Class;
		
		private var generatorProps:Object = null;
		
		/**
		 * @private
		 */
		public function get properties ():Object
		{
			return generatorProps;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set properties (value:Object):void
		{
			generatorProps = value;
		}
		
		/**
		 *  Creates a new instance of the <code>generator</code> class,
		 *  with the properties specified by <code>properties</code>.
		 *
		 *  <p>This method implements the <code>newInstance()</code> method
		 *  of the IFactory interface.</p>
		 *
		 *  @return The new instance that was created.
		 */
		public function newInstance ():*
		{
			var instance:Object = new generator();
			if (properties)
			{
				for (var p:String in properties)
					instance[p] = properties[p]
			}
			
			return instance;
		}
	}
}