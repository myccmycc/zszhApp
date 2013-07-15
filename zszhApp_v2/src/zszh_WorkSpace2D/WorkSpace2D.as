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
		public var _room2DVec:Vector.<Room_2D>;
		public var _modelsVec:Vector.<Model>;
		
		public function WorkSpace2D()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			this.addEventListener(ResizeEvent.RESIZE,OnResize);
		}
		
		public function SetAllNoSelected():void
		{
			for(var i:int=0;i<_room2DVec.length;i++)
				_room2DVec[i].SetSelected(false);
			
			for(i=0;i<_modelsVec.length;i++)
				_modelsVec[i].SetSelected(false);
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
			_grid=new Grid();	
			
			_room2DVec=new Vector.<Room_2D>();
			_modelsVec=new Vector.<Model>();
			
			_grid.scaleX=0.5;
			_grid.scaleY=0.5;
			
			_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
			_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
			
			addChild(_grid);

			_grid.addEventListener(DragEvent.DRAG_ENTER,DragEnter2D);
			_grid.addEventListener(DragEvent.DRAG_OVER,DragOver2D);
			_grid.addEventListener(DragEvent.DRAG_DROP,DragDrop2D);
		}

		private var room_number:int=0;
		private var current_object:Object;
		
		//D&D
		private function DragEnter2D(event:DragEvent):void
		{
			trace("DragEnter2D event.target.name:"+event.target.name);
			trace("DragEnter2D event.dragInitiator.name:"+event.dragInitiator.name);
			
			var className:String=String(event.dragSource.dataForFormat("className"));
			var resourcePath:String=String(event.dragSource.dataForFormat("resourcePath"));
			var objectName:String=String(event.dragSource.dataForFormat("objectName"));
			
			trace("WorkSpace2D::DragEnter2D：className="+className); 
			trace("WorkSpace2D::DragEnter2D：resourcePath="+resourcePath); 
			trace("WorkSpace2D::DragEnter2D：objectName="+objectName); 
			
			current_object=null;
			
			if(className=="Room_2D")
			{
				var room:Room_2D=new Room_2D();
				room.x=event.localX;
				room.y=event.localY;
				room.name=room.className+room_number;
				room_number++;
				_grid.addChild(room);
				_room2DVec.push(room);
				current_object=room as Object;
			}
			else if(className=="model_bed")
			{
				var model:Model=new Model(resourcePath,objectName);
				model.x=event.localX;
				model.y=event.localY;
				model.name=model.className+room_number;
				room_number++;
				_grid.addChild(model);
				_modelsVec.push(model);
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