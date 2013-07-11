package zszh_Events
{
	import flash.events.Event;
	
	public class WS2D_PopupMenuEvent extends Event
	{
		public static const HIDE_PopupMenu:String="Hide_PopupMenu";
		public var _text:String;
		
		public function WS2D_PopupMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			var event:WS2D_PopupMenuEvent= new WS2D_PopupMenuEvent(type, bubbles,cancelable);
			
			event._text=_text;
			
			return event;
		}
	}
}