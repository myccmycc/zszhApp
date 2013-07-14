package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Image;
	
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;

	
	public class Model extends UIComponent
	{
		private var _modelImage:Image;
		
		private var _topImageLoader:Loader;
		private var _resourcePath:String;
		private var _modelName:String;
		
		private var _selected:Boolean;
		//models
		public var _loaderModel:Loader3D;
		
		public function Model(resourcePath:String,modelName:String)
		{
			super();
			_resourcePath=resourcePath;
			_modelName=modelName;
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		private function OnCreation_Complete(e:FlexEvent):void
		{
			_topImageLoader = new Loader();
			_topImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			var topImageFile:String=_resourcePath+_modelName+"_top.png"
			_topImageLoader.load(new URLRequest(topImageFile));
			
			function onComplete(e:Event):void
			{
				_modelImage=new Image();
				_modelImage.source=Bitmap(_topImageLoader.content);
				_modelImage.width=_topImageLoader.content.width;
				_modelImage.height=_topImageLoader.content.height;
				addChild(_modelImage);
			}
			
			//3D	
			AssetLibrary.enableParser(AWD2Parser);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			//kickoff asset loading
			_loaderModel= new Loader3D();
			var modelFile:String=_resourcePath+_modelName+".awd";
			_loaderModel.load(new URLRequest(modelFile));
			_loaderModel.addEventListener(LoaderEvent.LOAD_ERROR,ModelLoadError);
			
			
			//D&D
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			addEventListener(MouseEvent.MOUSE_UP,MouseUp);
		}
		
		private function ModelLoadError(e:LoaderEvent):void
		{
			var d:int=10;
		}
		private function onAssetComplete(e:AssetEvent):void
		{
			
		}	
		
		private function MouseDown(e:MouseEvent):void
		{
			this.startDrag(false);
			e.stopPropagation();
		}
		
		private function MouseUp(e:MouseEvent):void
		{
			this.stopDrag();
			e.stopPropagation();
		}
		
		
	}
}