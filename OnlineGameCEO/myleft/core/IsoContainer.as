package myleft.core
{
	import myleft.data.INode;
	import myleft.data.Node;
	import myleft.events.IsoEvent;
	
	import myleft.events.ProxyEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class IsoContainer extends Node implements IIsoContainer
	{
		
		//////////////////////////////////////////////////////////////////
		//	INCLUDE IN LAYOUT
		//////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var bIncludeInLayout:Boolean = true;
		
		/**
		 * @private
		 */
		protected var includeInLayoutChanged:Boolean = false;
		
		/**
		 * @private
		 */
		public function get includeInLayout ():Boolean
		{
			return bIncludeInLayout;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set includeInLayout (value:Boolean):void
		{
			if (bIncludeInLayout != value)
			{
				bIncludeInLayout = value;
				includeInLayoutChanged = true;
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	DISPLAY LIST CHILDREN
		////////////////////////////////////////////////////////////////////////
		
		protected var displayListChildrenArray:Array = [];
			
		/**
		 * @inheritDoc
		 */
		public function get displayListChildren ():Array
		{
			return displayListChildrenArray;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CHILD METHODS
		////////////////////////////////////////////////////////////////////////
			
			//	ADD
			////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt (child:INode, index:uint):void
		{
			if (child is IIsoContainer)
			{
				super.addChildAt(child, index);
				
				if (includeInLayout)
				{
					displayListChildrenArray.push(child);
					mainContainer.addChildAt(IIsoContainer(child).container, index);
				}
			}
			
			else
				throw new Error("parameter child does not implement IContainer.");
		}
		
			//	SWAP
			////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function setChildIndex (child:INode, index:uint):void
		{
			if (!child is IIsoContainer)
				throw new Error("parameter child does not implement IContainer.");
			
			else if (!child.hasParent || child.parent != this)
				throw new Error("parameter child is not found within node structure.");
			
			else
			{
				super.setChildIndex(child, index);
				mainContainer.setChildIndex(IIsoContainer(child).container, index);
			}
		}
			
			//	REMOVE
			////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildByID (id:String):INode
		{
			var child:IIsoContainer = IIsoContainer(super.removeChildByID(id));
			if (child && child.includeInLayout)
			{
				var i:int = displayListChildrenArray.indexOf(child);
				if (i > -1)
					displayListChildrenArray.splice(i, 1);
				
				mainContainer.removeChild(IIsoContainer(child).container);
			}
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllChildren ():void
		{
			var child:IIsoContainer;
			for each (child in children)
			{
				if (child.includeInLayout)
					mainContainer.removeChild(child.container);
			}
			
			displayListChildrenArray = [];
				
			super.removeAllChildren();
		}		
			
			//	CREATE
			////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initialization method to create the child IContainer objects.
		 */
		protected function createChildren ():void
		{
			//overriden by subclasses
			mainContainer = new Sprite();
			//mainContainer.cacheAsBitmap = true;		
		}
		
		////////////////////////////////////////////////////////////////////////
		//	RENDER
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function render (recursive:Boolean = true):void
		{
			if (includeInLayoutChanged && parentNode)
			{
				var p:IIsoContainer = IIsoContainer(parentNode);
				var i:int = p.displayListChildren.indexOf(this);
				if (bIncludeInLayout)
				{
					if (i == -1)
						p.displayListChildren.push(this);
			
					if (!mainContainer.parent)
						IIsoContainer(parentNode).container.addChild(mainContainer);
				}
				else if (!bIncludeInLayout)
				{
					if (i >= 0)
						p.displayListChildren.splice(i, 1);
					
					if (mainContainer.parent)
						IIsoContainer(parentNode).container.removeChild(mainContainer);
				}
				
				includeInLayoutChanged = false;
			}
			
			if (recursive)
			{
				var child:IIsoContainer;
				for each (child in children)
					child.render(recursive);
			}
			
			dispatchEvent(new IsoEvent(IsoEvent.RENDER));
		}
		
		////////////////////////////////////////////////////////////////////////
		//	EVENT DISPATCHER PROXY
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		override public function dispatchEvent (event:Event):Boolean
		{
			//so we can make use of the bubbling events via the display list
			if (event.bubbles)
				return proxyTarget.dispatchEvent(new ProxyEvent(this, event));
				
			else
				return super.dispatchEvent(event);
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CONTAINER STRUCTURE
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var mainContainer:Sprite;
		
		/**
		 * @inheritDoc
		 */
		public function get depth ():int
		{
			if (mainContainer.parent)
				return mainContainer.parent.getChildIndex(mainContainer);
			
			else
				return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get container ():Sprite
		{
			return mainContainer;
		}
		
		////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoContainer()
		{
			super();
			createChildren();
			
			proxyTarget = mainContainer;
		}
	}
}