package zszh_away3d
{
	import mx.core.UIComponent;
	
	public class WS2D_Grid extends UIComponent
	{
		public var lineColor:uint = 0x3d4051; //网格线颜色
		public var gridFillColor:uint = 0x303344; //网格背景色
		
		
		public var lineThickness:Number = 1; //网格线粗细
		public var gridSize:Number = 50; //网格10*10
		
		public var gridWidth:int=100;
		public var gridHeight:int=100;
		
		
		public function WS2D_Grid()
		{
			super();
		}
		
	    public function drawGird(w:int,h:int):void
		{
			this.graphics.clear();
			//填充背景色
			this.graphics.beginFill(gridFillColor,1);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
			this.graphics.lineStyle(lineThickness,lineColor,1);
			
			gridWidth=w;
			gridHeight=h;

			this.drawHorizontalLine(gridSize,gridWidth,gridHeight);
			this.drawVerticalLine(gridSize,gridWidth,gridHeight);
		}
		
	
		public function drawHorizontalLine(size:Number,w:Number,h:Number):void
			
		{
			var cellh:Number=h/size;
			var bx:Number=(this.width-w)/2;
			if(bx<0)
				bx=0;
			var by:Number=(this.height-h)/2;
			if(by<0)
				by=0;
			for(var i:int=0;i<=size;i++)
			{
				this.graphics.moveTo(bx,cellh*i+by);
				this.graphics.lineTo(bx+w,cellh*i+by);
			}
		}
		
		public function drawVerticalLine(size:Number,w:Number,h:Number):void
		{
			var cellw:Number=w/size;
			var bx:Number=(this.width-w)/2;
			if(bx<0)
				bx=0;
			var by:Number=(this.height-h)/2;
			if(by<0)
				by=0;
			for(var i:int=0;i<=size;i++)
			{
				this.graphics.moveTo(cellw*i+bx,by);
				this.graphics.lineTo(cellw*i+bx,by+h);
			}
		}
	}
}