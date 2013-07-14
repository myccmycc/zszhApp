package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	public class Room_2DFloor extends Sprite
	{
		private var _floorTex:String="zszh_res/basic/wall/TextureFloor.jpg";
		private var _floorTexLoader:Loader;
		private var _floorBitmap:Bitmap;
		private var _uvVec:Vector.<Number>;
		
		public function Room_2DFloor()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,OnAddToStage);
		}
		
	
		private function OnAddToStage(e:Event):void
		{
			addEventListener(MouseEvent.MOUSE_OVER,FloorMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,FloorMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,FloorMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,FloorMouseUp);
			addEventListener(MouseEvent.CLICK,FloorMouseClick);
		
			_floorTexLoader = new Loader();
			_floorTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_floorTexLoader.load(new URLRequest(_floorTex));
			_uvVec  =	new Vector.<Number>();
		
			function onComplete(e:Event):void
			{
				_floorBitmap = Bitmap(_floorTexLoader.content);
				Draw();
			}
		}
		
		public function Draw():void
		{
			graphics.clear();
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(0xFF0000);
			
			if(_floorBitmap)
				graphics.beginBitmapFill(_floorBitmap.bitmapData);
			
			//update uv
			_uvVec=new Vector.<Number>();
			var room_2d:Room_2D=this.parent as Room_2D;
			for(var i:int=0;i<room_2d._vertexVec1.length;i+=2)
			{
				_uvVec.push(room_2d._vertexVec1[i]/200,room_2d._vertexVec1[i+1]/200);
			}
	
			graphics.drawTriangles(room_2d._vertexVec1,room_2d._indiceVec,_uvVec);
			graphics.endFill();	
		}
		
		//--------------floor mouse event----------------------------------------
		private function FloorMouseOver(e:MouseEvent):void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		private function FloorMouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}
		
		private function FloorMouseDown(e:MouseEvent):void
		{
			var room_2d:Room_2D=(this.parent as Room_2D);
			if(room_2d.GetSelected())
			{
				room_2d.startDrag();
				e.stopPropagation();
			}
		}
		
		private function FloorMouseUp(e:MouseEvent):void
		{
			var room_2d:Room_2D=(this.parent as Room_2D);
			if(room_2d.GetSelected())
			{
				room_2d.stopDrag();
				e.stopPropagation();
			}
		}
		private function FloorMouseClick(e:MouseEvent):void
		{
			var room_2d:Room_2D=(this.parent as Room_2D);
			room_2d.SetSelected(true);
		}
	}
}