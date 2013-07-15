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
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	import flashx.textLayout.formats.Float;
	
	import zszh_Events.WS2D_PopupMenuEvent;
	
	import zszh_WorkSpace2D.WS2D_PopupWall;
	
	public class Room_2DWall extends Sprite
	{
		private var _popupWindowMenu:WS2D_PopupWall;
		private var _lineColor:uint;
		private var _wallColor:uint;
		private var _wallColorSelected:uint;
		
		private var _wallPos:Vector.<Number>;
		
		private var _selected:Boolean;
		
		public function Room_2DWall()
		{
			super();
			_popupWindowMenu=new WS2D_PopupWall();
			_lineColor=0xffffff;
			_wallColor=0x7c7e89;
			_wallColorSelected=0xff6666;
			_wallPos=new Vector.<Number>;
			_selected=false;
			
			addEventListener(MouseEvent.CLICK,WallCLICK);
			addEventListener(MouseEvent.MOUSE_OVER,WallMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,WallMouseOut);
			
			addEventListener(WS2D_PopupMenuEvent.HIDE_PopupMenu,HIDE_PopupMenu);
		}
		
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
			UpdateDraw(_selected);
			PopUpManager.removePopUp(_popupWindowMenu);
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		public function Draw(p1x:Number,p1y:Number,p2x:Number,p2y:Number,p3x:Number,p3y:Number,p4x:Number,p4y:Number):void
		{
			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			var room_2d:Room_2D=(this.parent as Room_2D);
			if(room_2d.GetSelected())
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			_wallPos[0]=p1x;_wallPos[1]=p1y;
			_wallPos[2]=p2x;_wallPos[3]=p2y;
			_wallPos[4]=p3x;_wallPos[5]=p3y;
			_wallPos[6]=p4x;_wallPos[7]=p4y;
			
			graphics.moveTo(_wallPos[0],_wallPos[1]);
			graphics.lineTo(_wallPos[2],_wallPos[3]);
			graphics.lineTo(_wallPos[6],_wallPos[7]);
			graphics.lineTo(_wallPos[4],_wallPos[5]);
			graphics.endFill();
		}
		
		private function UpdateDraw(selected:Boolean):void
		{
			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			if(selected)
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			graphics.moveTo(_wallPos[0],_wallPos[1]);
			graphics.lineTo(_wallPos[2],_wallPos[3]);
			graphics.lineTo(_wallPos[6],_wallPos[7]);
			graphics.lineTo(_wallPos[4],_wallPos[5]);
			graphics.endFill();
		}
		
		private function WallMouseOver(e:MouseEvent):void
		{
			var room_2d:Room_2D=(this.parent as Room_2D);
			if(!room_2d.GetSelected()&&!_selected)
				UpdateDraw(true);
			
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor_Wall,2,-41,-14);
			e.stopPropagation();
		}
		private function WallMouseOut(e:MouseEvent):void
		{
			var room_2d:Room_2D=(this.parent as Room_2D);
			if(!room_2d.GetSelected()&&!_selected)
				UpdateDraw(false);
			CursorManager.removeAllCursors();
			e.stopPropagation();
		}
		
		private function WallCLICK(e:MouseEvent):void
		{
			var room_2d:Room_2D=(this.parent as Room_2D);
			room_2d.SetSelected(true);
			room_2d.SetAllNoSelected();

			SetSelected(true);
			PopUpManager.addPopUp(_popupWindowMenu,this,false);
		
			var pt:Point = new Point(e.localX, e.localY);
			pt = e.target.localToGlobal(pt);
			_popupWindowMenu.move(pt.x,pt.y);
			//PopUpManager.centerPopUp(_popupWindowMenu);
			e.stopPropagation();
			
		}
		private function HIDE_PopupMenu(e:WS2D_PopupMenuEvent):void
		{
			PopUpManager.removePopUp(_popupWindowMenu);
			trace(e._text);
		}
		
	}
}