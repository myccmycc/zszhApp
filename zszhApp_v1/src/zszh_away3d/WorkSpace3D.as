package zszh_away3d
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.MathConsts;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
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
		//debug 
		private var _debug:AwayStats;
		
		//plane textures
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		[Embed(source="/../embeds/floor_specular.jpg")]
		public static var FloorSpecular:Class;
		[Embed(source="/../embeds/floor_normal.jpg")]
		public static var FloorNormals:Class;
		
		//material objects
		private var planeMaterial:TextureMultiPassMaterial;
		
		//light objects
		private var directionalLight:DirectionalLight;
		private var _pointLight:PointLight;
		private var lightPicker:StaticLightPicker;
		

		//plane
		var _plane:Mesh;
		var _houseObject:ObjectContainer3D;
		
		public function WorkSpace3D()
		{
			super();   
		}
		override protected function createChildren():void
		{
			super.createChildren();
			if(!_view3d)
			{
				_view3d=new View3D();
				_view3d.backgroundColor=0x303344;
				_view3d.antiAlias=4;
			}
			addChild(_view3d);
			_view3d.addEventListener(Event.ADDED_TO_STAGE,update);
			addEventListener(Event.ENTER_FRAME,OnFrameEnter);

			//setup light 
			directionalLight = new DirectionalLight(0, -1, 0);
			directionalLight.castsShadows = false;
			directionalLight.color = 0xeedddd;
			directionalLight.diffuse = .5;
			directionalLight.ambient = .5;
			directionalLight.specular = 0;
			directionalLight.ambientColor = 0x808090;
			_view3d.scene.addChild(directionalLight);
			
			_pointLight=new PointLight();
			_pointLight.castsShadows=false;
			_pointLight.color=0xff0000;
			_pointLight.position=new Vector3D(0,500,0);
			_view3d.scene.addChild(_pointLight);
			
			lightPicker = new StaticLightPicker([_pointLight]);
			
			//setup material
			planeMaterial = new TextureMultiPassMaterial(Cast.bitmapTexture(FloorDiffuse));
			planeMaterial.specularMap = Cast.bitmapTexture(FloorSpecular);
			planeMaterial.normalMap = Cast.bitmapTexture(FloorNormals);
			planeMaterial.lightPicker = lightPicker;
			planeMaterial.repeat = true;
			planeMaterial.mipmap = false;
			planeMaterial.specular = 10;
			
			//setup debuh info
			_debug=new AwayStats(_view3d);
			addChild(_debug);
			
			//setup the camera
			_view3d.camera.z = -800;
			_view3d.camera.y = 800;
			_view3d.camera.lookAt(new Vector3D());
			
			//setup camera controller
			addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_view3d);
			addEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_view3d);
			addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			
			addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,MOUSE_MDOWN_view3d);
			addEventListener(MouseEvent.MIDDLE_MOUSE_UP,MOUSE_MUP_view3d);

			
			addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL_view3d);
			
			//setup the scene
			var wire:WireframeCube=new WireframeCube(400,400,400);
			wire.position=new Vector3D(0,0,0);
			
			_view3d.scene.addChild(wire);
			
			
			
			
			
			_houseObject = new ObjectContainer3D();
			
			
			var p0:Point=new Point(-400,400);
			var p1:Point=new Point(400,400);
			var p2:Point=new Point(400,-400);
			var p31:Point=new Point(0,-400);
			var p3:Point=new Point(0,-300);
			var p4:Point=new Point(-400,-300);
			var p:Array=new Array();
			p.push(p0);
			p.push(p1);
			p.push(p2);
			p.push(p31);
			p.push(p3);
			p.push(p4);
			
			var d:WS3D_Room=new WS3D_Room(p);
			d.BuiltRoom();
			_houseObject.addChild(d);
			


			
			
			_view3d.scene.addChild(_houseObject);

			

			
			_view3d.scene.addChild(new Trident(50));
			
			

			//
		/*	Parsers.enableAllBundled();
			AssetLibrary.enableParser(AWD2Parser);
			
			//kickoff asset loading
			var _loader:Loader3D= new Loader3D();

			_loader.load(new URLRequest("../embeds/myModel5.awd"));
			for (var i:int = 0; _loader.numChildren; i++)
			{
				var mesh:Mesh = Mesh(_loader.getChildAt(i));
				mesh.scale(20);
				mesh.material.lightPicker=lightPicker;
			}
			_view3d.scene.addChild(_loader);*/

		}

		private function onObjectMouseDown( event:MouseEvent3D ):void {
			event.target.showBounds=true;
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
				
				
				
				//var ang:Number=Math.atan(y/x);
				
				//trace(ang);
				//_plane.rotationY=ang;
			}
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