package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.FlexGlobals;
	import mx.core.INavigatorContent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	public class Room_2DFloor extends Sprite
	{
		private var _floorTex:String="zszh_res/basic/wall/TextureFloor.jpg";
		private var _floorTexLoader:Loader;
		private var _floorBitmap:Bitmap;
		private var _uvVec:Vector.<Number>;
		private var _uvScale:int;
		
		private var _popupWindowMenu:PopupMenu_Room2D_Floor;
		private var _selected:Boolean;
		
		public function Room_2DFloor()
		{
			super();
			_uvScale=100;
			addEventListener(Event.ADDED_TO_STAGE,OnAddToStage);
		}
		
	
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
			Update();
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		private function OnDeleteThisRoom(e:Event):void
		{
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			room_2d.DeleteThisRoom();
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
				Update();
			}
		}
		
		public function Update():void
		{
			graphics.clear();
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(0xFF0000);
			
			if(_floorBitmap)
				graphics.beginBitmapFill(_floorBitmap.bitmapData);
			
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			var vectex:Vector.<Number>=new Vector.<Number>;
			var len:int=room_2d._vertexVec1.length;
			
			for(var i:int=0;i<len;i++)
			{
				vectex.push(room_2d._vertexVec1[i]);
			}
			
			var mArea:int=room_2d._roomArea;
			trace("面积：",mArea);
			//while( vectex.length>4)
			{
				var iPos:int=0;
				for(;iPos<vectex.length;iPos+=2)
				{
					 var p1:Point=new Point(vectex[iPos],vectex[iPos+1]);
					 var p2:Point=new Point(vectex[(iPos+2)%vectex.length],vectex[(iPos+3)%vectex.length]);
					 var p3:Point=new Point(vectex[(iPos+4)%vectex.length],vectex[(iPos+5)%vectex.length]);
					 
					 var p1p2:Point=new Point(p2.x-p1.x,p2.y-p1.y);
					 var p2p3:Point=new Point(p3.x-p2.x,p3.y-p2.y);
					 var p3p1:Point=new Point(p1.x-p3.x,p1.y-p3.y);
					 
					 var points:Vector.<Point>=new Vector.<Point>;
					 points.push(p1p2);
					 points.push(p2p3);
					 points.push(p3p1);
					 
					 var test:Number = Object2D_Room.GetPolygonArea(points);
					 
					 if(test>=0)
					 {
						 if(test<=mArea)//凸点
						 {
							 mArea-=test;
							 vectex.splice((iPos+2)%vectex.length,2);
							 trace(vectex.length);
							 iPos=0;
							 graphics.lineStyle(1,0xff0000);
							 
							 graphics.moveTo(p1.x,-p1.y);
							 graphics.lineTo(p3.x,-p3.y);
		 
							 graphics.endFill();
							 
							 //vertex
							 /*var vertexVec:Vector.<Number>=new Vector.<Number>();
							 vertexVec.push(p1.x,-p1.y,p2.x,-p2.y,p3.x,-p3.y);
							 //indice
							 var indiceVec:Vector.<int>=new Vector.<int>();
							 indiceVec.push(0,1,2);
							 //uv
							 var uvVec:Vector.<Number>=new Vector.<Number>();
							 uvVec.push(p1.x/_uvScale,-p1.y/_uvScale,p2.x/_uvScale,-p2.y/_uvScale,p3.x/_uvScale,-p3.y/_uvScale);

							 graphics.drawTriangles(vertexVec,indiceVec,uvVec);*/
						 }
						// else
						 {
							 
						 }
					 }
				}
			}
			
			
			graphics.endFill();	
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
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
			SetSelected(false);
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(room_2d.GetSelected())
			{
				room_2d.startDrag();
				e.stopPropagation();
			}
		}
		
		private function FloorMouseUp(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(room_2d.GetSelected())
			{
				room_2d.stopDrag();
				e.stopPropagation();
			}
		}
		private function FloorMouseClick(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(room_2d.GetSelected())
			{
				_popupWindowMenu=new PopupMenu_Room2D_Floor;
				_popupWindowMenu.addEventListener(PopupMenu_Room2D_Floor.DELETE_THIS_ROOM,OnDeleteThisRoom,false,0,true);
				PopUpManager.addPopUp(_popupWindowMenu,this,false);
				var pt:Point = new Point(0, 0);
				pt = e.target.localToGlobal(pt);
				_popupWindowMenu.move(pt.x,pt.y);
			}
			else room_2d.SetSelected(true);
		}
	}
}