package zszh_WorkSpace3D
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.IAsset;
	import away3d.library.utils.AssetLibraryIterator;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	
	public class Model_3D extends ObjectContainer3D
	{
		public var _resPath:String;
		public var _modelName:String;
		public var _modelPos:Vector3D;
		
		public var _loaderModel:Loader3D;
		public var _mesh:Mesh;
		
		public function Model_3D(path:String,name:String,pos:Vector3D)
		{
			super();
			_resPath=path;
			_modelName=name;
			_modelPos=pos;
			
			//3D	
			AssetLibrary.enableParser(AWD2Parser);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			
			//asset loading
			_loaderModel= new Loader3D();
			var modelFile:String=_resPath+_modelName+".awd";
			_loaderModel.load(new URLRequest(modelFile));
			_loaderModel.addEventListener(LoaderEvent.LOAD_ERROR,ModelLoadError);
			_loaderModel.addEventListener(LoaderEvent.RESOURCE_COMPLETE,ResourceCompleteHandler);
		}
		
		private function ResourceCompleteHandler(e:LoaderEvent):void
		{
			_loaderModel.removeEventListener(away3d.events.LoaderEvent.RESOURCE_COMPLETE, ResourceCompleteHandler);
			trace("loader has currently "+_loaderModel.numChildren+"children name:"+_loaderModel.name);
			
			var asset:IAsset; 
			var type:AssetType
			var it :	AssetLibraryIterator = AssetLibrary.createIterator(); 
			
			var mesh:Mesh;
			while (asset = it.next()) 
			{ 
				if(asset.assetType == AssetType.MESH)
				{
					mesh = (asset as Mesh);
					mesh.mouseEnabled=true;
					mesh.addEventListener(MouseEvent3D.MOUSE_DOWN,MeshMouseDown);
					mesh.addEventListener(MouseEvent3D.MOUSE_MOVE,MeshMouseMove);
					mesh.addEventListener(MouseEvent3D.MOUSE_UP,MeshMouseUp);
					mesh.position=_modelPos;
					if(mesh!=null)
					{
						_mesh=mesh
						addChild(_mesh);
					}
				}
			}
		}
		
		
		private function ModelLoadError(e:LoaderEvent):void
		{
			trace("ERROR:ModelLoadError");
		}
		private function onAssetComplete(e:AssetEvent):void
		{
			trace("ModelLoad successed!");
		}
		
		private var startPoint:Point;
		private var bStart:Boolean=false;
		private function MeshMouseDown(e:MouseEvent3D):void
		{
			e.target.showBounds=true;
			startPoint=new Point;
			bStart=true;
			startPoint.x=e.screenX;
			startPoint.y=e.screenY;
		}
		
		private function MeshMouseMove(e:MouseEvent3D):void
		{
			if(bStart)
			{
				_mesh.x+=e.screenX-startPoint.x;
				_mesh.z+=e.screenY-startPoint.y;
				
				startPoint.x=e.screenX;
				startPoint.y=e.screenY;
			}
		}
		private function MeshMouseUp(e:MouseEvent3D):void
		{
			bStart=false;
		}
		
	}

}