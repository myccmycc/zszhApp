package zszh_WorkSpace3D
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.data.EntityListItem;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	
	public class Model_3D extends ObjectContainer3D
	{
		public var _resPath:String;
		public var _modelName:String;
		
		public var _loaderModel:Loader3D;
		
		public function Model_3D(path:String,name:String,pos:Vector3D)
		{
			super();
			
			_resPath=path;
			_modelName=name;
			position=pos;
			
			//Loader3D to load the asset
			Loader3D.enableParser(AWD2Parser);
			_loaderModel= new Loader3D();
			var modelFile:String=_resPath+_modelName+".awd";
			_loaderModel.load(new URLRequest(modelFile));
		
			_loaderModel.addEventListener(AssetEvent.MESH_COMPLETE,OnMeshAssetComplete);
			_loaderModel.addEventListener(LoaderEvent.LOAD_ERROR,ModelLoadError);
		}
		
		private function OnMeshAssetComplete(event:AssetEvent):void
		{
			if(event.asset.assetType==AssetType.MESH)
			{
				var mesh:Mesh = event.asset as Mesh;
				mesh.mouseEnabled = true;
				mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, MeshMouseDown);
				mesh.addEventListener(MouseEvent3D.MOUSE_OUT, MeshMouseUp);
				mesh.addEventListener(MouseEvent3D.MOUSE_UP, MeshMouseUp);
				mesh.scaleX=0.1;
				mesh.scaleY=0.1;
				mesh.scaleZ=0.1;
				addChild(mesh);
			}
		}
	
		private function ModelLoadError(event:LoaderEvent):void
		{
			trace("ERROR:ModelLoadError "+event.url);
		}

		
		private var startPoint:Point;
		private var bStart:Boolean=false;
		private function MeshMouseDown(e:MouseEvent3D):void
		{
			e.target.showBounds=true;
			startPoint=new Point;
			bStart=true;
			startPoint.x=e.scenePosition.x;
			startPoint.y=e.scenePosition.z;
			
			e.target.addEventListener(MouseEvent3D.MOUSE_MOVE, MeshMouseMove);
			
			/*trace(e.screenX);
			trace(e.screenY);
			trace(e.scenePosition);
			trace(e.localPosition);*/
			
			
			//update ray
			/*var rayPosition:Vector3D = e.view.unproject(e.screenX, e.screenY, 0);
			var rayDirection:Vector3D = e.view.unproject(e.screenX, e.screenY, 1);
			rayDirection = rayDirection.subtract(rayPosition);
			
			trace(rayPosition);
			trace(rayDirection);
			/*if (entity.isVisible && entity.isIntersectingRay(rayPosition, rayDirection))
			{
				
			}	*/
				
		}
		
		private function MeshMouseMove(e:MouseEvent3D):void
		{
			if(bStart)
			{
				
				var dx:Number=e.scenePosition.x-startPoint.x;
				var dz:Number=e.scenePosition.z-startPoint.y;
				
				
				e.target.parent.x+=dx;
				e.target.parent.z+=dz;
				
				startPoint.x=e.scenePosition.x;
				startPoint.y=e.scenePosition.z;
				
			}
		}
		private function MeshMouseUp(e:MouseEvent3D):void
		{
			bStart=false;
			e.target.removeEventListener(MouseEvent3D.MOUSE_MOVE, MeshMouseMove);
		}
		
	}

}