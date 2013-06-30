package zszh_WorkSpace2D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import spark.components.Image;
	
	public class WorkSpace2D extends UIComponent
	{
		public var _grid:WorkSpace2D_Grid;
		public var _room2DArr:Array;
		public var _modelsArr:Array;
		
		
		public function WorkSpace2D()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			this.addEventListener(DragEvent.DRAG_ENTER,DragEnter2D);
			this.addEventListener(DragEvent.DRAG_OVER,DragOver2D);
			this.addEventListener(DragEvent.DRAG_DROP,DragDrop2D);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		private function OnCreation_Complete(e:FlexEvent):void
		{
			_grid=new WorkSpace2D_Grid();
			addChild(_grid);
			_grid.addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL_grid);
			_grid.addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_grid);
			_grid.addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_grid);
			_grid.addEventListener(FlexEvent.CREATION_COMPLETE,showGrid);
		}

			
		private function showGrid(e:FlexEvent):void
		{
			
			if(_grid)
			{
				_grid.width=unscaledWidth*2;
				_grid.height=unscaledHeight*2;
				_grid.drawGird(unscaledWidth*2/2,unscaledWidth*2/2);
			}
		}
		
		private function MOUSE_WHEEL_grid(ev:MouseEvent) : void
		{
			if(ev.delta<0)
			{
				this.scaleX+=0.1
				this.scaleY+=0.1
				trace("画布宽度："+_grid.width);
				trace("宽度："+this.unscaledWidth);
			}
			else
			{
				//if(this.scaleX>1)
				{
					this.scaleX-=0.1
					this.scaleY-=0.1
					trace("画布宽度："+_grid.width);
					trace("宽度："+this.unscaledWidth);
				}
			}				
		}
		private function MOUSE_DOWN_grid(ev:MouseEvent) : void
		{
			this.buttonMode=true;
			this.startDrag(false);
		}
		private function MOUSE_UP_grid(ev:MouseEvent) : void
		{
			this.buttonMode=false;
			this.stopDrag();
		}
		
		var room_small:Room_Small2D;
		private function DragEnter2D(event:DragEvent):void
		{
			trace("DragEnter2D event.target.name:"+event.target.name);
			trace("DragEnter2D event.dragInitiator.name:"+event.dragInitiator.name);
			
			
			var messages:String=String(event.dragSource.dataForFormat("className"));
			trace("WorkSpace2D::DragEnter2D：className="+messages); 
			
			if(messages=="Room_Small2D")
			{
				room_small=new Room_Small2D();
				trace("className:"+room_small.className);
				room_small.x=event.localX;
				room_small.y=event.localY;
				addChild(room_small);
				room_small.startDrag(false);
			}
			
			DragManager.acceptDragDrop(event.target as UIComponent);
		}
		private function DragOver2D(event:DragEvent):void
		{
			//DragManager.acceptDragDrop(event.target as UIComponent);
		}
		private function DragDrop2D(event:DragEvent):void
		{
			/*var dragObject:UIComponent=UIComponent(event.dragInitiator);
			dragObject.x = (event.currentTarget).mouseX;
			dragObject.y = (event.currentTarget).mouseY;
			if(dragObject.parent!=event.currentTarget){
			AWAY3D.addElement(dragObject);
			}*/
			
			room_small.stopDrag();
		}
	
		private function MouseOut(event:MouseEvent):void
		{
			
		}
	}
}