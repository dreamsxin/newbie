package myleft.display.renderers
{
	import myleft.bounds.IBounds;
	import myleft.core.IIsoDisplayObject;
	import myleft.core.myleft_internal;
	import myleft.display.scene.IIsoScene;
	
	import flash.events.EventDispatcher;
	
	use namespace myleft_internal;
	
	/**
	 * The DefaultSceneLayoutRenderer is the default renderer responsible for performing the isometric position-based depth sorting on the child objects of the target IIsoScene. 
	 */
	public class DefaultSceneLayoutRenderer implements ISceneRenderer
	{		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function renderScene (scene:IIsoScene):void
		{
			var sortedChildren:Array = scene.displayListChildren.slice(); //make a copy of the children
			sortedChildren.sortOn(["distance", "screenX", "screenY"], Array.NUMERIC);
			sortedChildren.sort(isoDepthSort); //perform a secondary sort for any hittests
			
			var child:IIsoDisplayObject;
			var i:uint;
			var m:uint = sortedChildren.length;
			while (i < m)
			{
				child = IIsoDisplayObject(sortedChildren[i]);
				if (child.depth != i)
					scene.setChildIndex(child, i); //is there a way to make this more efficient?
				
				i++;
			}
		}
		
		////////////////////////////////////////////////////
		//	SORT
		////////////////////////////////////////////////////
		
		private function isoDepthSort (childA:Object, childB:Object):int
		{
			var boundsA:IBounds;
			var boundsB:IBounds;
			
			//trace(childA.id, childB.id);
			
			if (true)//childA.container.hitTestObject(childB.container)
			{
				boundsA = childA.isoBounds;
				boundsB = childB.isoBounds;
					
				if (boundsA.bottom >= boundsB.top)
					return 1;	
									
				else if (boundsA.top <= boundsB.bottom)
					return -1;
				
				else if (boundsA.front <= boundsB.back)
					return -1;
									
				else if (boundsA.back >= boundsB.front)
					return 1;
					
				else if (boundsA.right <= boundsB.left)
					return -1;
					
				else if (boundsA.left >= boundsB.right)
					return 1;
				
				else
					return 0;
			}
		}
	}
}