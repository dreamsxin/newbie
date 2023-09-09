package myleft.display.renderers
{
	import myleft.display.scene.IIsoScene;
	
	/**
	 * The ISceneRenderer interface defines the methods that all scene renderer-type classes should implement.
	 * ISceneRenderer classes are intended to assist IIsoContainers implementors during the rendering phase.
	 */
	public interface ISceneRenderer
	{
		/**
		 * Iterates and renders each child of the target.
		 * 
		 * @param scene The IIsoScene to be renderered.
		 */
		function renderScene (scene:IIsoScene):void;
	}
}