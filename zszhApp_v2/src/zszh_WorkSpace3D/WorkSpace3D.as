package zszh_WorkSpace3D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.SubMesh;
	import away3d.core.math.MathConsts;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.IAsset;
	import away3d.library.utils.AssetLibraryIterator;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframeCube;
	import away3d.textures.Texture2DBase;
	import away3d.utils.Cast;
	
	public class WorkSpace3D extends UIComponent
	{
		//engine variables
		private var _view3d:View3D;
		private var _directionLight:DirectionalLight;
		public var _lightPicker:StaticLightPicker;
		

		//debug 
		private var _debug:AwayStats;
		//rooms
		private var _roomContainer3D:ObjectContainer3D;
		//wallInside
		private var _wallInsideContainer3D:ObjectContainer3D;
		//models
		private var _modelsContainer3D:ObjectContainer3D;
		
		private var _meshArray:Array;
		
		public function WorkSpace3D()
		{
			super();   
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		
		//--------punblic functions------------------------------------------
		public function ClearRoom():void
		{
			for(var i:int=_roomContainer3D.numChildren-1;i>=0;i--)
				_roomContainer3D.removeChildAt(i);
			
		}
		public function AddRoom(pos1:Vector.<Number>,roomName:String):void
		{
			var room:Room_3D=new Room_3D(pos1,_lightPicker);
			room.name=roomName;
			_roomContainer3D.addChild(room);
		}
		
		public function ClearWallInside():void
		{
			for(var i:int=_wallInsideContainer3D.numChildren-1;i>=0;i--)
				_wallInsideContainer3D.removeChildAt(i);
			
		}
		public function AddWallInside(pos1:Vector.<Number>,wallName:String):void
		{
			 
		}
		
		
		public function ClearModels():void
		{
			for(var i:int=_modelsContainer3D.numChildren-1;i>=0;i--)
				_modelsContainer3D.removeChildAt(i);
		}
		
		public function AddModels(resPath:String,modelName:String,pos:Vector3D):void
		{			
			var model:Model_3D=new Model_3D(resPath,modelName,pos);
			_modelsContainer3D.addChild(model);
		}
		
	
		
		//--------------init the workspace3d-------------------------
		private function OnCreation_Complete(e:FlexEvent):void
		{
			if(!_view3d)
			{
				_view3d=new View3D();
				_view3d.backgroundColor=0x303344;
				_view3d.antiAlias=4;
			}
			addChild(_view3d);
			_view3d.addEventListener(Event.ADDED_TO_STAGE,update);
			addEventListener(Event.ENTER_FRAME,OnFrameEnter);
			
			
			//setup debuh info
			_debug=new AwayStats(_view3d);
			addChild(_debug);
			
			//setup the camera
			_view3d.camera.z = -800;
			_view3d.camera.y = 800;
			_view3d.camera.lookAt(new Vector3D());
			
			//setup light
			_directionLight = new DirectionalLight();
			_directionLight.direction = _view3d.camera.forwardVector;
			_directionLight.color = 0x00FFFF;
			_directionLight.ambient = 0.1;
			_directionLight.diffuse = 0.7;
			
			_view3d.scene.addChild(_directionLight);
			
			_lightPicker = new StaticLightPicker([_directionLight]);
			
							
			//setup camera controller
			addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_view3d);
			addEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_view3d);
			addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,MOUSE_MDOWN_view3d);
			addEventListener(MouseEvent.MIDDLE_MOUSE_UP,MOUSE_MUP_view3d);
			
			
			addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL_view3d);
			
			//setup the scene
			_roomContainer3D = new ObjectContainer3D();
			_wallInsideContainer3D=new ObjectContainer3D();
			_modelsContainer3D= new ObjectContainer3D();
			
			_view3d.scene.addChild(_roomContainer3D);
			_view3d.scene.addChild(_wallInsideContainer3D);
			_view3d.scene.addChild(_modelsContainer3D);
			_view3d.scene.addChild(new Trident(50));
			
		}
		
		
		
		
		
		//-----------------_view3d render-----------------------------------
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			update();
		}
		
		private function update(e:* = null):void
		{
			if(_view3d)
			{
				_view3d.width = unscaledWidth;
				_view3d.height = unscaledHeight ;
			}
		}
		
		private function OnFrameEnter(e:Event):void
		{
			if(_view3d.stage3DProxy)
			{
				_view3d.render();
				_directionLight.direction = _view3d.camera.forwardVector;
			}
		}
		
		
		//-----------------mouse event---------------------------------------------
		private function onObjectMouseDown( event:MouseEvent3D ):void {
			event.target.showBounds=true;
		}
		/**
		 * _view3d listener for mouse interaction
		 */
		//左键
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
			_bMMDown_view3d=false;
		}
		
		
		//右键
		private var _bMMDown_view3d:Boolean=false;
		private var _MMDownPos:Point=new Point(0,0);
		private var _MMDownCameraPos:Point=new Point(0,0);
		
		private function MOUSE_MDOWN_view3d(ev:MouseEvent):void
		{
			_bMMDown_view3d=true;
			
			_MMDownPos.x=ev.localX;
			_MMDownPos.y=ev.localY;
			
			_MMDownCameraPos.x=_view3d.camera.x;
			_MMDownCameraPos.y=_view3d.camera.z;
		}
		
		private function MOUSE_MUP_view3d(ev:MouseEvent):void
		{
			_bMMDown_view3d=false;
		}
		
		
		
		
		private function MOUSE_MOVE_view3d(ev:MouseEvent) : void
		{
			if(_bMMDown_view3d)
			{
				var dx:int = ev.localX -_MMDownPos.x;
				var dz:int = ev.localY -_MMDownPos.y;
			
				_view3d.camera.x=_MMDownCameraPos.x-dx*5;
				_view3d.camera.z=_MMDownCameraPos.y+dz*5;
				
			}
			
			//左键 旋转 
			else if(_bMDown_view3d)
			{
				
				var dy:Number = ev.localX -_MDownPos.x;//y轴转动
				
				var angy:Number=dy/31.4;
				
				dx = ev.localY -_MDownPos.y;//x轴转动
				
				var angx:int=dx/31.4;

				for(var i:int=0;i<_view3d.scene.numChildren;i++)
				{
					_view3d.scene.getChildAt(i).rotate(new Vector3D(0,1,0),-angy);
					//_view3d.scene.getChildAt(i).rotate(new Vector3D(1,0,0),-angx);
				}
				
			}
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