package zszh_away3d
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	import away3d.containers.View3D;
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
	import away3d.primitives.RegularPolygonGeometry;
	import away3d.utils.Cast;
	
	
	public class MainView extends UIComponent
	{
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		
		//engine variables
		private var _view3d:View3D;
		
		//scene objects
		private var _plane:Mesh;
		
		//scene loader
		private var _loader:Loader3D;
		
		//solider ant texture
		[Embed(source="/../embeds/soldier_ant.jpg")]
		public static var AntTexture:Class;
		
		//solider ant model
		[Embed(source="/../embeds/t1.obj",mimeType="application/octet-stream")]
		public static var AntModel:Class;
		
	
		public function MainView()
		{
			super();   
		}
		public function AddMesh(pathName:String):void
		{
			//setup loader
			Parsers.enableAllBundled();
			AssetLibrary.enableParser(AWD2Parser);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onResourceComplete);
			
			//kickoff asset loading
			_loader= new Loader3D();
			_loader.load(new URLRequest("../embeds/myModel.awd"));
			
		/*	_view.scene.addChild(loader);
			
			//setup the url map for textures in the 3ds file
			var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();
			assetLoaderContext.mapUrlToData("texture.jpg", new AntTexture());
			
			
			_loader=new Loader3D();
			_loader.scale(300);
			_loader.z = -200;
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader.loadData( new AntModel(), assetLoaderContext);
			//_loader.load(new URLRequest("../embeds/t1.obj"));
			//_loader.load(new URLRequest(pathName));*/
			
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
			this._view3d.addEventListener(Event.ADDED_TO_STAGE,update);
			this.addEventListener(Event.ENTER_FRAME,OnFrameEnter);
			
			
			//setup the camera
			_view3d.camera.z = -600;
			_view3d.camera.y = 500;
			_view3d.camera.lookAt(new Vector3D());
			
			//setup the scene
			_plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
			_view3d.scene.addChild(_plane);
			
	
			
		}
		private function onResourceComplete(ev : AssetEvent) : void
		{
			//_loader.removeEventListener(AssetEvent.ASSET_COMPLETE, onResourceComplete);
			//_loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_view3d.scene.addChild(_loader);
		}
		
		
		private function onLoadError(ev : LoaderEvent) : void
		{
			trace('Could not find', ev.url);
			//_loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			//_loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader = null;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			update();
		}
		
		private function update(e:* = null):void
		{
			this._view3d.width = this.unscaledWidth;
			this._view3d.height = this.unscaledHeight ;
		}
		
		private function OnFrameEnter(e:Event):void
		{
			if(this._view3d.stage3DProxy)
			{
				//_loader.rotationY = stage.mouseX - stage.stageWidth/2;
				_plane.rotationY += 1;
				this._view3d.render();
			}
		}
	}
}