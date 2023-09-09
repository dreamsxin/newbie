package myleft.display
{
	import myleft.core.IFactory;
	import myleft.core.IIsoDisplayObject;
	import myleft.display.renderers.IViewRenderer;
	import myleft.display.scene.IIsoScene;
	import myleft.geom.IsoMath;
	import myleft.geom.Pt;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * IsoView is a default view port that provides basic panning and zooming functionality on a given IIsoScene.
	 */
	public class IsoView extends Sprite implements IIsoView
	{
		///////////////////////////////////////////////////////////////////////////////
		//	PRECISION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if coordinate values are rounded to the nearest whole number or not.
		 */
		public var usePreciseValues:Boolean = false;
		
		///////////////////////////////////////////////////////////////////////////////
		//	CURRENT PT
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 * 
		 * The targeted point to perform calculations on.
		 */
		protected var targetScreenPt:Pt = new Pt();
		
		/**
		 * @private
		 */
		protected var currentScreenPt:Pt;
		
		/**
		 * @inheritDoc
		 */
		public function get currentPt ():Pt
		{
			return currentScreenPt.clone() as Pt;
		}
		
			//	CURRENT X
			///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function get currentX ():Number
		{
			return currentScreenPt.x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set currentX (value:Number):void
		{			
			if (currentScreenPt.x != value)
			{
				if (!targetScreenPt)
					targetScreenPt = currentScreenPt.clone() as Pt;
				
				targetScreenPt.x = usePreciseValues ? value : Math.round(value);
				
				bPositionInvalidated = true;
				if (autoUpdate)
					render();
			}
		}
		
			//	CURRENT Y
			///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function get currentY ():Number
		{
			return currentScreenPt.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set currentY (value:Number):void
		{
			if (currentScreenPt.y != value);
			{
				if (!targetScreenPt)
					targetScreenPt = currentScreenPt.clone() as Pt;
				
				targetScreenPt.y = usePreciseValues ? value : Math.round(value);
				
				bPositionInvalidated = true;
				if (autoUpdate)
					render();
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	INVALIDATION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var bPositionInvalidated:Boolean = false;
		
		/**
		 * Flag indicating if the view is invalidated.  If true, validation will when explicity called.
		 */
		public function get isInvalidated ():Boolean
		{
			return bPositionInvalidated;
		}
		
		public function invalidatePosition ():void
		{
			bPositionInvalidated = true;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	VALIDATION
		///////////////////////////////////////////////////////////////////////////////
		
		public var renderSceneOnValidation:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function render ():void
		{
			if (bPositionInvalidated)
			{
				validatePosition();
				bPositionInvalidated = false;
			}
		}
		
		/**
		 * Calculates the positional changes and repositions the <code>container</code>.
		 */
		protected function validatePosition ():void
		{
			var dx:Number = currentScreenPt.x - targetScreenPt.x;
			var dy:Number = currentScreenPt.y - targetScreenPt.y;
			
			if (limitRangeOfMotion && romTarget)
			{
				var ndx:Number;
				var ndy:Number;
				
				var rect:Rectangle = romTarget.getBounds(this);
				var isROMBigger:Boolean = !romBoundsRect.containsRect(rect);
				if (isROMBigger)
				{
					if (dx > 0)
						ndx = Math.min(dx, Math.abs(rect.left));
					
					else
						ndx = -1 * Math.min(Math.abs(dx), Math.abs(rect.right - romBoundsRect.right));
						
					if (dy > 0)
						ndy = Math.min(dy, Math.abs(rect.top));
					
					else
						ndy = -1 * Math.min(Math.abs(dy), Math.abs(rect.bottom - romBoundsRect.bottom));
				}
				
				targetScreenPt.x = targetScreenPt.x + dx - ndx;
				targetScreenPt.y = targetScreenPt.y + dy - ndy;
				
				dx = ndx;
				dy = ndy;
			}
			
			_mainContainer.x += dx;
			_mainContainer.y += dy;
			
			currentScreenPt = targetScreenPt.clone() as Pt;
			if (viewRenderers && mainIsoScene)
			{
				var viewRenderer:IViewRenderer;
				var factory:IFactory;
				for each (factory in viewRendererFactories)
				{
					viewRenderer = factory.newInstance();
					viewRenderer.renderView(this);
				}
				
				if (renderSceneOnValidation)
					mainIsoScene.render();
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CENTER
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Flag indicating if property changes immediately trigger validation.
		 */
		public var autoUpdate:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function centerOnPt (pt:Pt, isIsometrc:Boolean = true):void
		{
			var target:Pt = Pt(pt.clone());
			if (isIsometrc)
				IsoMath.isoToScreen(target);
			
			if (!usePreciseValues)
			{
				target.x = Math.round(target.x);
				target.y = Math.round(target.y);
				target.z = Math.round(target.z);
			}
			
			targetScreenPt = target;
			
			bPositionInvalidated = true;
			render();
		}
		
		/**
		 * @inheritDoc
		 */
		public function centerOnIso (iso:IIsoDisplayObject):void
		{
			centerOnPt(iso.isoBounds.centerPt);	
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	PAN
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function pan (px:Number, py:Number):void
		{
			targetScreenPt = currentScreenPt.clone() as Pt;
			
			targetScreenPt.x += px;
			targetScreenPt.y += py;
			
			bPositionInvalidated = true;
			render();
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	ZOOM
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * The current zoom factor applied to the child scene objects.
		 */
		public function get currentZoom ():Number
		{
			return _zoomContainer.scaleX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function zoom (zFactor:Number = 1):void
		{
			if (_zoomContainer.scaleX !=zFactor || _zoomContainer.scaleY != zFactor)
			{
				bPositionInvalidated = true;
				_zoomContainer.scaleX = _zoomContainer.scaleY = zFactor;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	RESET
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function reset ():void
		{
			if (_zoomContainer.scaleX !=1 || _zoomContainer.scaleY != 1)
			{
				bPositionInvalidated = true;
				_zoomContainer.scaleX = _zoomContainer.scaleY = 1;
			}
		
			_mainContainer.x = 0;
			_mainContainer.y = 0;
			
			currentScreenPt = new Pt();
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	VIEW RENDERER
		///////////////////////////////////////////////////////////////////////////////
		
		private var viewRendererFactories:Array = [];
		
		/**
		 * @private
		 */
		public function get viewRenderers ():Array
		{
			return viewRendererFactories;
		}
		
		public function set viewRenderers (value:Array):void
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
				
				viewRendererFactories = temp;
				
				bPositionInvalidated = true;
				if (autoUpdate)
					render();
			}
			
			else
				viewRendererFactories = [];
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	SCENE
		///////////////////////////////////////////////////////////////////////////////
		
		private var mainIsoScene:IIsoScene;
		
		/**
		 * @private
		 */
		public function get scene ():IIsoScene
		{
			return mainIsoScene;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scene (value:IIsoScene):void
		{
			if (mainIsoScene != value)
			{
				if (mainIsoScene)
					mainIsoScene.hostContainer = null;
				
				mainIsoScene = value;
				if (mainIsoScene)
				{
					var oldZoom:Number = currentZoom;
					
					mainIsoScene.hostContainer = _sceneContainer;
					reset();
					zoom(oldZoom);
				}
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	SIZE
		///////////////////////////////////////////////////////////////////////////////
		
		private var _w:Number;
		private var _h:Number;
		
		/**
		 * @inheritDoc
		 */
		override public function get width ():Number
		{
			return _w;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height ():Number
		{
			return _h;
		}
		
		/**
		 * The current size of the IsoView.
		 * Returns a Point whose x corresponds to the width and y corresponds to the height.
		 */
		public function get size ():Point
		{
			return new Point(_w, _h);
		}
		
		/**
		 * Set the size of the IsoView and repositions child scene objects, masks and borders (where applicable).
		 * 
		 * @param w The width to resize to.
		 * @param h The height to resize to.
		 */
		public function setSize (w:Number, h:Number):void
		{
			_w = Math.round(w);
			_h = Math.round(h);
			
			romBoundsRect = new Rectangle(0, 0, _w, _h);
			
			_zoomContainer.x = _w / 2;
			_zoomContainer.y = _h / 2;
			_zoomContainer.mask = _clipContent ? _mask : null;
			
			_mask.graphics.clear();
			if (_clipContent)
			{
				_mask.graphics.beginFill(0);
				_mask.graphics.drawRect(0, 0, _w, _h);
				_mask.graphics.endFill();
			}
			
			_border.graphics.clear();
			_border.graphics.lineStyle(0);
			_border.graphics.drawRect(0, 0, _w, _h);

		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	CLIP CONTENT
		///////////////////////////////////////////////////////////////////////////////
		
		private var _clipContent:Boolean = true;
		
		/**
		 * @private
		 */
		public function get clipContent ():Boolean
		{
			return _clipContent;
		}
		
		/**
		 * Flag indicating where to allow content to visibly extend beyond the boundries of this IsoView.
		 */
		public function set clipContent (value:Boolean):void
		{
			if (_clipContent != value)
			{
				_clipContent = value;
				reset();
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//	RANGE OF MOTION
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var romTarget:DisplayObject;
		
		/**
		 * @private
		 */
		protected var romBoundsRect:Rectangle;
		
		/**
		 * @private
		 */
		public function get rangeOfMotionTarget ():DisplayObject
		{
			return romTarget;
		}
		
		/**
		 * The target used to determine the range of motion when moving the <code>container</code>.
		 * 
		 * @see #limitRangeOfMotion
		 */
		public function set rangeOfMotionTarget (value:DisplayObject):void
		{
			romTarget = value;
			limitRangeOfMotion = romTarget ? true : false;
		}
		
		/**
		 * Flag to limit the range of motion.
		 * 
		 * @see #rangeOfMotionTarget
		 */
		public var limitRangeOfMotion:Boolean = true;
		
		///////////////////////////////////////////////////////////////////////////////
		//	CONTAINER STRUCTURE
		///////////////////////////////////////////////////////////////////////////////
		
		private var _zoomContainer:Sprite;
		
			//	MAIN CONTAINER
			///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected var _mainContainer:Sprite;
		
		/**
		 * The main container whose children include the background container, the iso object container and the foreground container.
		 * 
		 * An IsoView's container structure is as follows:
		 * * IsoView
		 * 		* zoom container
		 * 			* main container
		 * 				* background container
		 * 				* iso scenes container
		 * 				* foreground container
		 */
		public function get mainContainer ():Sprite
		{
			return _mainContainer;
		}
		
			//	BACKGROUND CONTAINER
			///////////////////////////////////////////////////////////////////////////////
		
		private var _bgContainer:Sprite;
		
		/**
		 * The container for background elements.
		 */
		public function get backgroundContainer ():Sprite
		{
			if (!_bgContainer)
			{
				_bgContainer = new Sprite();
				_mainContainer.addChildAt(_bgContainer, 0);
			}
			
			return _bgContainer;
		}
		
			//	FOREGROUND CONTAINER
			///////////////////////////////////////////////////////////////////////////////
			
		private var _fgContainer:Sprite;
		
		/**
		 * The container for foreground elements.
		 */
		public function get foregroundContainer ():Sprite
		{
			if (!_fgContainer)
			{
				_fgContainer = new Sprite();
				_mainContainer.addChild(_fgContainer);
			}
			
			return _fgContainer;
		}
		
			//	BOUNDS & SCENE CONTAINER
			///////////////////////////////////////////////////////////////////////////////
		
		private var _sceneContainer:Sprite;
		
		private var _mask:Shape;
		private var _border:Shape;
		
		///////////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		///////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructor
		 */
		public function IsoView ()
		{
			super();
			
			_sceneContainer = new Sprite();
			
			_mainContainer = new Sprite();
			_mainContainer.addChild(_sceneContainer);
			
			_zoomContainer = new Sprite();
			_zoomContainer.addChild(_mainContainer);
			addChild(_zoomContainer);
			
			_mask = new Shape();
			addChild(_mask);
			
			_border = new Shape();
			addChild(_border);
			
			setSize(400, 250);
			
			//viewRenderer = new ClassFactory(DefaultViewRenderer);
		}
	}
}