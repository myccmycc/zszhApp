package zszh_WorkSpace2D
{

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	import zszh_WorkSpace2D.PopupMenu_Room2D_Wall;
	
	public class Room_2DWindows extends Sprite
	{
		private var _popupWindowMenu:PopupMenu_Room2D_Wall;
		
		private var _selected:Boolean;
		
		public function Room_2DWindows()
		{
			super();
		
			
			addEventListener(MouseEvent.RIGHT_CLICK,WallCLICK);
			addEventListener(MouseEvent.MOUSE_OVER,WallMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,WallMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,WallMouseDown);
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
		

		
		private function Update():void
		{
			/*graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			if(_selected)
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			graphics.moveTo(_wallPos[0],-_wallPos[1]);
			graphics.lineTo(_wallPos[2],-_wallPos[3]);
			graphics.lineTo(_wallPos[6],-_wallPos[7]);
			graphics.lineTo(_wallPos[4],-_wallPos[5]);
			graphics.endFill();
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
			
			var p1:Point=new Point(_wallPos[2]-_wallPos[0],_wallPos[3]-_wallPos[1]);
			var p2:Point=new Point(1,0);
			var d:Number=p1.x*p2.x+p1.y*p2.y;
			var d1:Number=Math.sqrt(p1.x*p1.x+p1.y*p1.y) * Math.sqrt(p2.x*p2.x+p2.y*p2.y);
			_rotation= Math.acos(d/d1)/Math.PI *180;
			
			var sind:Number=p1.x*p2.y-p1.y*p2.x;
			if(sind<0)
				_rotation=360-_rotation;*/
		}
		
		
		//----------------wall mouse move event ---------------------------------------
		
		private function WallMouseOver(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			e.stopPropagation();
		}
		private function WallMouseOut(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			e.stopPropagation();
		}
		
		private function WallCLICK(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
			_popupWindowMenu=new PopupMenu_Room2D_Wall();
			PopUpManager.addPopUp(_popupWindowMenu,this,false);
		
			var pt:Point = new Point(e.localX, e.localY);
			pt = e.target.localToGlobal(pt);
			_popupWindowMenu.move(pt.x,pt.y);
			e.stopPropagation();
			
		}
		
	
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		

		private function WallMouseDown(e:MouseEvent):void
		{
			if(!_selected)
				return;
		  
			bStart=true;
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
	
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
			e.stopPropagation();
		}
		
		private function WallMouseUp(e:MouseEvent):void
		{
		  	SetSelected(true);
			bStart=false;

			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
		}
		private function WallMouseMove(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			if(!bStart)
				return;
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
		}
		
		
	}
}