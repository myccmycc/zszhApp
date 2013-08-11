package zszh_WorkSpace2D
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;

	public class Room_2DCorner extends UIComponent
	{
		[Embed(source="../embeds/rooms/cursor_corner.png")]
		public var _cursorCorner:Class;
		
		
		private var _cursorSprite:Sprite;
		private var _selected:Boolean;
		public  var _posInRoom:int;
		private var _postion:Point;
		
		
		public function Room_2DCorner()
		{
			super();
			_cursorSprite=new Sprite();
			_cursorSprite.addChild(new _cursorCorner());
			addChild(_cursorSprite);
			_cursorSprite.visible=false;
			
			_postion=new Point;
			InitListener();
		}
		
		public function Draw(px:Number,py:Number):void
		{
			_postion.x=px;
			_postion.y=-py;
			
			if(_selected)
			{
				graphics.clear();
				graphics.lineStyle(1,0x000000);
				graphics.beginFill(0xffffff,1);
				graphics.drawCircle(_postion.x,_postion.y,10);
				graphics.endFill();
			}
			else graphics.clear();
		}
		
		
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		
	    private function InitListener():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
			addEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,CornerMouseDown);
		}
		
		private function ShowCursorCorner():void
		{
			CursorManager.hideCursor();
			
			_cursorSprite.visible=true;
			_cursorSprite.x=_postion.x-_cursorSprite.width/2;
			_cursorSprite.y=_postion.y-_cursorSprite.height/2;
		}
		
		private function HideCursorCorner():void
		{
			CursorManager.showCursor();
			_cursorSprite.visible=false;
		}
		
		
		//---------------corner mouse event---------------------------------------------
		private function CornerMouseOVER(e:MouseEvent):void
		{
			if(!_selected)
				return;
			ShowCursorCorner();
		}
		private function CornerMouseOut(e:MouseEvent):void
		{
			if(!_selected)
				return;
			HideCursorCorner();
		}
		
		
		
		//---------------corner mouse event---------------------------------------------
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		
		private function CornerMouseDown(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			bStart=true;
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
			
			this.removeEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			
			e.stopPropagation();
		}
		
		private function CornerMouseUp(e:MouseEvent):void
		{
			bStart=false;
			HideCursorCorner();
			
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
			this.addEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
		}
		private function CornerMouseMove(e:MouseEvent):void
		{
			if(!bStart)
				return;
			
			MoveCorner(_posInRoom);
			ShowCursorCorner();
			
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
			
		}
		
		private function MoveCorner(i:int):void
		{
			var thisRoom:Object2D_Room=(this.parent as Object2D_Room);
			var VMouseMove:Point=new Point((int)(this.stage.mouseX-startPoint.x),int(-this.stage.mouseY+startPoint.y));
			
			thisRoom._vertexVec1[i]+=VMouseMove.x;
			thisRoom._vertexVec1[i+1]+=VMouseMove.y;
			thisRoom.Object2DUpdate();
		}
	}
}