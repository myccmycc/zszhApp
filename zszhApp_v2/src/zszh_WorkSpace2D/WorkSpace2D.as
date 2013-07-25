package zszh_WorkSpace2D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	
	import spark.components.Image;
	
	
	public class WorkSpace2D extends UIComponent
	{
		public var _grid:Grid;
		public var _objects:Array;
		
		//---for create 3d space-------------------
		public var _room2DVec:Vector.<Object2D_Room>;
		public var _wall2DVec:Vector.<Wall_2D>;
		public var _modelsVec:Vector.<Object2D_Model>;
		
		public function WorkSpace2D()
		{
			super();
			_objects=new Array;
			this.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			this.addEventListener(ResizeEvent.RESIZE,OnResize);
		}
		
		private function MouseDown(e:MouseEvent):void
		{
			SetAllNoSelected();
		}
		private function SetAllNoSelected():void
		{
			for(var i:int=0;i<_objects.length;i++)
			{
				if(_objects[i].visible==true)
					_objects[i].SetSelected(false);
				else _objects.splice(i,1);//删除
			}
		}
		
		
		public function ShowCenter():void
		{
			_grid.scaleX=0.5;
			_grid.scaleY=0.5;
			_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
			_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
		}
		
		private function OnResize(e:ResizeEvent):void
		{
			if(_grid)
			{
				_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
				_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
			}
		}
		private function OnCreation_Complete(e:FlexEvent):void
		{
			_room2DVec=new Vector.<Object2D_Room>();
			_wall2DVec=new Vector.<Wall_2D>();
			_modelsVec=new Vector.<Object2D_Model>();
			
			_grid=new Grid();
			_grid.scaleX=0.5;
			_grid.scaleY=0.5;
			
			_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
			_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
			
			addChild(_grid);

			_grid.addEventListener(DragEvent.DRAG_ENTER,DragEnter2D);
			_grid.addEventListener(DragEvent.DRAG_OVER,DragOver2D);
			_grid.addEventListener(DragEvent.DRAG_DROP,DragDrop2D);
		}

		
		
		//D&D
		private var room_number:int=0;
		private var current_object:Object;
		
		private function DragEnter2D(event:DragEvent):void
		{
			var className:String=String(event.dragSource.dataForFormat("className"));
			var classArgument:String=String(event.dragSource.dataForFormat("classArgument"));
			var resourcePath:String=String(event.dragSource.dataForFormat("resourcePath"));
			var objectName:String=String(event.dragSource.dataForFormat("objectName"));
			
			current_object=null;
			
			if(className=="Room_2D")
			{
				var room:Object2D_Room=new Object2D_Room(classArgument);
				room.x=event.localX;
				room.y=event.localY;
				room.name=room.className+room_number;
				room_number++;
				_grid.addChild(room);
				_grid.setChildIndex(room,0);
				_room2DVec.push(room);
				_objects.push(room);
				
				current_object=room as Object;
			}
			else if(className=="Wall_2D")
			{
				var wall:Wall_2D =new Wall_2D(classArgument);
				wall.x=event.localX;
				wall.y=event.localY;
				wall.name=wall.className+room_number;
				room_number++;
				_grid.addChild(wall);
				_wall2DVec.push(wall);
				_objects.push(wall);
				
				current_object=wall as Object;
			}
			
			else if(className=="model")
			{
				var model:Object2D_Model=new Object2D_Model(resourcePath,objectName);
				model.x=event.localX;
				model.y=event.localY;
				model.name=model.className+room_number;
				room_number++;
				_grid.addChild(model);
				_modelsVec.push(model);
				_objects.push(model);
				
				current_object=model as Object;
			}
		
			
			DragManager.acceptDragDrop(event.target as UIComponent);
		}
		private function DragOver2D(event:DragEvent):void
		{
			if(current_object)
			{
				current_object.x=event.localX;
				current_object.y=event.localY;
			}
		}
		private function DragDrop2D(event:DragEvent):void
		{
		}
	}
}