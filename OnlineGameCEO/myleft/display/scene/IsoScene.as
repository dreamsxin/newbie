package myleft.display.scene
{
	
	import myleft.bounds.IBounds;
	import myleft.bounds.SceneBounds;
	import myleft.core.ClassFactory;
	import myleft.core.IFactory;
	import myleft.core.IIsoDisplayObject;
	import myleft.core.IsoContainer;
	import myleft.core.myleft_internal;
	import myleft.data.INode;
	import myleft.display.renderers.DefaultSceneLayoutRenderer;
	import myleft.display.renderers.ISceneRenderer;
	import myleft.events.IsoEvent;
	import myleft.geom.Pt;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;
	
	use namespace myleft_internal;
	
	/**
	 * IsoScene is a base class for grouping and rendering IIsoDisplayObject children according to their isometric position-based depth.
	 */
	public class IsoScene extends IsoContainer implements IIsoScene
	{		
		///////////////////////////////////////////////////////////////////////////////
		//	BOUNDS
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _isoBounds:IBounds;
		
		/**
		 * @inheritDoc
		 */
		public function get isoBounds ():IBounds
		{
			if (!_isoBounds || isInvalidated)
				_isoBounds = new SceneBounds(this);
			
			return _isoBounds;
		}
		
		protected var host:DisplayObjectContainer;
		
		public function get hostContainer ():DisplayObjectContainer
		{
			return host;
		}
		
		public function set hostContainer (value:DisplayObjectContainer):void
		{
			if (value && host != value)
			{
				if (host && host.contains(container))
					host.removeChild(container);
				
				else if (hasParent)
					parent.removeChild(this);
				
				host = value;
				if (host)
				{
					host.addChild(container);
					parentNode = null;
				}
			}
		}
		
		protected var invalidatedChildrenArray:Array = [];

		public function get invalidatedChildren ():Array
		{
			return invalidatedChildrenArray;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	OVERRIDES
		///////////////////////////////////////////////////////////////////////////////

		override public function addChild (child:INode):void
		{
			addChildAt(child, this.container.numChildren);
		}
		
		override public function addChildAt (child:INode, index:uint):void
		{
			if (child is IIsoDisplayObject)
			{
				super.addChildAt(child, index);
				child.addEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
				
				_isInvalidated = true; //since the child most likely had fired an invalidation event prior to being added, manually invalidate the scene
			}
				
			else
				throw new Error ("parameter child is not of type IIsoDisplayObject");
		}

		override public function setChildIndex (child:INode, index:uint):void
		{
			super.setChildIndex(child, index);
			_isInvalidated = true;
		}
		
		override public function removeChildByID (id:String):INode
		{
			var child:INode = super.removeChildByID(id);
			child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			
			_isInvalidated = true;
			
			return child;
		}		

		override public function removeAllChildren ():void
		{			
			var child:INode
			for each (child in children)
				child.removeEventListener(IsoEvent.INVALIDATE, child_invalidateHandler);
			
			super.removeAllChildren();
			_isInvalidated = true;
		}
		
		protected function child_invalidateHandler (evt:IsoEvent):void
		{
			var child:IIsoDisplayObject = IIsoDisplayObject(evt.target);
			
			//determine distance from a likely camera position
			var camera:Pt = new Pt(100000, 100000, 100000);
			child.distance = -1 * Math.sqrt
										(
											Math.pow(camera.x - (child.x + child.width), 2) + 
											Math.pow(camera.y - (child.y + child.length), 2) + 
											Math.pow(camera.z - (child.z + child.height), 2)
										);
						
			if (invalidatedChildrenArray.indexOf(child) == -1)
				invalidatedChildrenArray.push(child);
			
			_isInvalidated = true;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	LAYOUT RENDERER
		///////////////////////////////////////////////////////////////////////////////
		
		public var layoutEnabled:Boolean = true;
		
		private var layoutRendererFactory:IFactory;
		
		public function get layoutRenderer ():IFactory
		{
			return layoutRendererFactory;
		}

		public function set layoutRenderer (value:IFactory):void
		{
			if (value && layoutRendererFactory != value)
			{
				layoutRendererFactory = value;
				_isInvalidated = true;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	STYLE RENDERERS
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flags the scene for possible style rendering.
		 */
		public var stylingEnabled:Boolean = true;
		
		private var styleRendererFactories:Array = [];
		
		/**
		 * @private
		 */
		public function get styleRenderers ():Array
		{
			return styleRendererFactories;
		}
		
		public function set styleRenderers (value:Array):void
		{			
			if (value)
			{
				var temp:Array = [];
				var obj:Object;
				for each (obj in value)
				{
					if (obj is IFactory)
						temp.push(obj);
				}
				
				styleRendererFactories = temp;
				_isInvalidated = true;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	INVALIDATION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _isInvalidated:Boolean = false;
		
		public function get isInvalidated ():Boolean
		{
			return _isInvalidated;
		}

		public function invalidateScene ():void
		{
			_isInvalidated = true;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	RENDER
		///////////////////////////////////////////////////////////////////////////////
		
		private var renderInfoObj:SceneRenderInfoObject = new SceneRenderInfoObject();
		
		public function get renderInfo ():String
		{
			return renderInfoObj.toString();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function render (recursive:Boolean = true):void
		{
			super.render(recursive); //push individual changes thru, then sort based on new visible content of each child
			
			if (_isInvalidated)
			{
				var time:int = getTimer();
				
				//render the layout first
				var sceneRenderer:ISceneRenderer;
				if (layoutEnabled)
				{
					sceneRenderer = layoutRendererFactory.newInstance();
					sceneRenderer.renderScene(this);
				}
				
				renderInfoObj.layoutRenderTime = getTimer() - time;
				time = getTimer();
				
				//apply styling
				mainContainer.graphics.clear(); //should we do this here?
				
				var factory:IFactory
				if (stylingEnabled)
				{
					for each (factory in styleRendererFactories)
					{
						sceneRenderer = factory.newInstance();
						sceneRenderer.renderScene(this);
					}
				}
				
				renderInfoObj.styleRenderTime = getTimer() - time;
				time = getTimer();
				
				_isInvalidated = false;
				
				sceneRendered();
			}
		}

		protected function sceneRendered ():void
		{
			invalidatedChildrenArray = [];
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoScene ()
		{
			super();
			
			layoutRendererFactory = new ClassFactory(DefaultSceneLayoutRenderer);
		}
	}
}

class SceneRenderInfoObject
{
	public var layoutRenderTime:int;
	public var styleRenderTime:int;
	
	public function toString ():String
	{
		return "layoutRenderTime: " + layoutRenderTime + "\t styleRenderTime: " + styleRenderTime;
	}
}