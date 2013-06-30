package zszh_WorkSpace3D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	public class WS2D_RoomWall extends UIComponent
	{
		public var _vertexVec:Vector.<Number>=new Vector.<Number>();//inside
		public var _vertexVec2:Vector.<Number>=new Vector.<Number>();//outside
		public var _vertexVec3:Vector.<Number>=new Vector.<Number>();//outside
		
		public var _indiceVec:Vector.<int>=new Vector.<int>;
		public var _uvVec:Vector.<Number>=new Vector.<Number>;
		
		public var _floorTex:String="../embeds/TextureFloor.jpg";
		
		public function WS2D_RoomWall()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP,MouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT,MouseUp);
			
		}
		
		public function DrawRoom2DWall():void
		{
			var loader:Loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			
			loader.load(new URLRequest(_floorTex));
			
			function onComplete(e:Event):void
			{
				
				graphics.clear();
				
				graphics.lineStyle(0, 0, 0);
				
				graphics.beginFill(0xFF0000);
				
				var bm:Bitmap = Bitmap(loader.content);
				
				graphics.beginBitmapFill(bm.bitmapData);
				
				graphics.drawTriangles(_vertexVec,_indiceVec,_uvVec);
				
				graphics.endFill();
				
			}
			
		}
		
		private function MouseDown(e:MouseEvent):void
		{
			this.startDrag();
		}
		
		private function MouseMove(e:MouseEvent):void
		{
		}
		
		private function MouseUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		
	}
}