package zszh_WorkSpace2D
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	public class Room_2DCorner extends Sprite
	{
		public function Room_2DCorner()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,OnAddToStage);
		}
		
		private function OnAddToStage(e:Event):void
		{
			addEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
			addEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
		}
		
		public function Draw(px:Number,py:Number):void
		{
			graphics.clear();
			graphics.lineStyle(1,0x000000);
			graphics.beginFill(0xffffff,1);
			graphics.drawCircle(px,py,10);
			graphics.endFill();
		}
		
		//---------------corner mouse event---------------------------------------------
		private function CornerMouseOVER(e:MouseEvent):void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		private function CornerMouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}
	}
}