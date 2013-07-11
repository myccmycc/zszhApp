package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import flashx.textLayout.formats.Float;
	
	import zszh_WorkSpace2D.WS2D_PopupWindow;
	
	import zszh_Events.WS2D_PopupMenuEvent;
	
	public class Room_Wall2D 
	{
		public var _sprite:Sprite;
		private var _popupWindowMenu:WS2D_PopupWindow;
		public function Room_Wall2D()
		{
			_sprite=new Sprite();
			_popupWindowMenu=new WS2D_PopupWindow();
			_sprite.addEventListener(MouseEvent.CLICK,WallCLICK);
			_sprite.addEventListener(WS2D_PopupMenuEvent.HIDE_PopupMenu,HIDE_PopupMenu);
		}
		
		private function WallCLICK(e:MouseEvent):void
		{
			PopUpManager.addPopUp(_popupWindowMenu,_sprite,false);
			PopUpManager.centerPopUp(_popupWindowMenu);
		}
		private function HIDE_PopupMenu(e:WS2D_PopupMenuEvent):void
		{
			PopUpManager.removePopUp(_popupWindowMenu);
			trace(e._text);
		}
	}
}