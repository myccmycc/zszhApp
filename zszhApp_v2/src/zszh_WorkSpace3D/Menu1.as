package zszh_WorkSpace3D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	

	
	public class Menu1 extends UIComponent
	{

		public function Menu1()
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