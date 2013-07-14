package zszh_WorkSpace2D
{
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	
	public class Grid extends UIComponent
	{
		public var _lineColor:uint = 0x3d4051; //网格线颜色
		public var _gridFillColor:uint = 0x2f3243; //网格背景色 0x2f3243
		
		
		public var _lineThickness:Number = 1; //网格线粗细
		public var _gridSize:Number = 64; //64*64
		public var _gridWidth:int=6400;
		public var _gridHeight:int=6400;
		
		
		public function Grid()
		{
			super();
			this.width=_gridWidth;
			this.height=_gridHeight;
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		private function OnCreation_Complete(e:FlexEvent):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_grid);
			addEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_grid);
			addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_grid);
			addEventListener(MouseEvent.MOUSE_OUT,MOUSE_OUT_grid);
			drawGird();
		}
		
	    public function drawGird():void
		{
			this.graphics.clear();
			//填充背景色
			this.graphics.beginFill(_gridFillColor,1);
			this.graphics.drawRect(0,0,_gridWidth,_gridHeight);
			this.graphics.endFill();
			this.graphics.lineStyle(_lineThickness,_lineColor,1);
			
			this.drawHorizontalLine(_gridSize,_gridWidth,_gridHeight);
			this.drawVerticalLine(_gridSize,_gridWidth,_gridHeight);
			
			this.graphics.lineStyle(2,0x0000ff,1);
			
			this.graphics.moveTo(0,_gridHeight/2);
			this.graphics.lineTo(_gridWidth,_gridHeight/2);
			
			this.graphics.moveTo(_gridWidth/2,0);
			this.graphics.lineTo(_gridWidth/2,_gridHeight);
		}
		
	
		public function drawHorizontalLine(size:Number,w:Number,h:Number):void
			
		{
			var cellh:Number=h/size;
			var bx:Number=0;
			var by:Number=0;
			for(var i:int=0;i<=size;i++)
			{
				this.graphics.moveTo(bx,cellh*i+by);
				this.graphics.lineTo(bx+w,cellh*i+by);
			}
		}
		
		public function drawVerticalLine(size:Number,w:Number,h:Number):void
		{
			var cellw:Number=w/size;
			var bx:Number=0;
			var by:Number=0;
			for(var i:int=0;i<=size;i++)
			{
				this.graphics.moveTo(cellw*i+bx,by);
				this.graphics.lineTo(cellw*i+bx,by+h);
			}
		}

		
		//_grid D&D
		private function MOUSE_DOWN_grid(ev:MouseEvent) : void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
			startDrag(false);
			
			(this.parent as WorkSpace2D).SetAllNoSelected();
		}
		private function MOUSE_UP_grid(ev:MouseEvent) : void
		{
			CursorManager.removeAllCursors();
			stopDrag();
		}
		private function MOUSE_OUT_grid(event:MouseEvent):void
		{
			CursorManager.removeAllCursors();
			stopDrag();
		}
		
		private function MOUSE_MOVE_grid(e:MouseEvent) : void
		{
		}
	
	}
}