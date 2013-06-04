package zszh_away3d
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	
	public class UIRenderEngine extends UIComponent
	{
		//engine variables
		private var _view3d:View3D;
		//debug 
		private var _debug:AwayStats;
		

		public function UIRenderEngine()
		{
			super();   
		}
		override protected function createChildren():void
		{
			super.createChildren();
			if(!_view3d)
			{
				_view3d=new View3D();
				_view3d.backgroundColor=0x00ffff;
				_view3d.antiAlias=4;
			}
			addChild(_view3d);
			_view3d.addEventListener(Event.ADDED_TO_STAGE,update);
			addEventListener(Event.ENTER_FRAME,OnFrameEnter);

			//setup debuh info
			_debug=new AwayStats(_view3d);
			addChild(_debug);
			
			//setup the camera
			_view3d.camera.z = -600;
			_view3d.camera.y = 500;
			_view3d.camera.lookAt(new Vector3D());
			
			//setup camera controller
			addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_view3d);
			addEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_view3d);
			addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			
			addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL_view3d);
			
			//setup the scene
			var _plane:Mesh = new Mesh(new PlaneGeometry(700, 700));
			_view3d.scene.addChild(_plane);
			
			//
			Parsers.enableAllBundled();
			AssetLibrary.enableParser(AWD2Parser);
			
			//kickoff asset loading
			var _loader:Loader3D= new Loader3D();
			_loader.load(new URLRequest("../embeds/myModel.awd"));
			_view3d.scene.addChild(_loader);

		}

		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			update();
		}
		
		private function update(e:* = null):void
		{
			_view3d.width = unscaledWidth;
			_view3d.height = unscaledHeight ;
		}
		
		private function OnFrameEnter(e:Event):void
		{
			if(_view3d.stage3DProxy)
			{
				_view3d.render();
			}
		}
		
		/**
		 * _view3d listener for mouse interaction
		 */
		private var _bMDown_view3d:Boolean=false;
		private var _MDownPos:Point=new Point(0,0);
		private var _MDownCameraPos:Point=new Point(0,0);
		private function MOUSE_DOWN_view3d(ev:MouseEvent) : void
		{
			_bMDown_view3d=true;
			_MDownPos.x=ev.localX;
			_MDownPos.y=ev.localY;
			
			_MDownCameraPos.x=_view3d.camera.x;
			_MDownCameraPos.y=_view3d.camera.z;
		}
		private function MOUSE_UP_view3d(ev:MouseEvent) : void
		{
			_bMDown_view3d=false;
		}
		private function MOUSE_MOVE_view3d(ev:MouseEvent) : void
		{
			if(!_bMDown_view3d)
				return;
			var dx:int = ev.localX -_MDownPos.x;
			var dz:int = ev.localY -_MDownPos.y;
			
			_view3d.camera.x=_MDownCameraPos.x-dx*5;
			_view3d.camera.z=_MDownCameraPos.y+dz*5;
		}
		
		private function MOUSE_WHEEL_view3d(ev:MouseEvent) : void
		{
			if(ev.delta<0)
			{
				_view3d.camera.moveForward(40);
			}
			else
			{
				_view3d.camera.moveBackward(40);
			}				
		}
		
		
	}
}