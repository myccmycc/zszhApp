package zszh_away3d
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class WorkSpace2D extends UIComponent
	{
		public var _grid:WS2D_Grid;
		public var _room2D:WS2D_Room;
		public function WorkSpace2D()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_grid=new WS2D_Grid();
			_room2D=new WS2D_Room();
			addChild(_grid);
			addChild(_room2D);
			addEventListener(FlexEvent.CREATION_COMPLETE,showGrid);
			addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL_grid);
			 
		}
			
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		private function showGrid(e:FlexEvent):void
		{
			
			if(_grid)
			{
				_grid.width=unscaledWidth;
				_grid.height=unscaledHeight;
				_grid.drawGird(unscaledWidth/2,unscaledWidth/2);
			}
			
			if(_room2D)
			{
				_room2D.x=100;
				_room2D.y=100;
				_room2D.DrawRoomFloor2D();
				_room2D.DrawRoomWall2D();
			}
		}
		
		var gridScale:Number=2;
		private function MOUSE_WHEEL_grid(ev:MouseEvent) : void
		{
			if(ev.delta<0)
			{
				gridScale+=0.1;
				//_grid.drawGird(unscaledWidth/gridScale,unscaledWidth/gridScale);
				_grid.scaleX+=0.1
				_grid.scaleY+=0.1
			}
			else
			{
				gridScale-=0.1;
				//_grid.drawGird(unscaledWidth/gridScale,unscaledWidth/gridScale);
				_grid.scaleX-=0.1
				_grid.scaleY-=0.1
			}				
		}
		

	}
}