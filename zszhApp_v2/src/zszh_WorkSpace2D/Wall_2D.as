package zszh_WorkSpace2D
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;


	public class Wall_2D extends UIComponent
	{
		public  var _vertexVec1:Vector.<Number>;
				
		private  var _vertexVec2:Vector.<Number>;
		private  var _vertexVec3:Vector.<Number>;


		private var _selected:Boolean;
		private var _wallType:String;//0横,1竖着
		
		private var _lineColor:uint;
		private var _wallColor:uint;
		private var _wallColorSelected:uint;
		
		private var _wallCornerVec:Vector.<Wall_2DCorner>;
		

		public function Wall_2D(type:String)
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			if(type=="1" || type =="2")
				_wallType=type;
			else trace("ERROR:Wall_2D have wrong wall type "+ type );
			_selected=true;
			
			_lineColor=0xffffff;
			_wallColor=0x7c7e89;
			_wallColorSelected=0xff6666;
		}
		
		public function SetAllNoSelected():void
		{
			for(var i:int=0;i<_wallCornerVec.length;i++)
				_wallCornerVec[i].SetSelected(false);
		}
		
		public function SetSelected(b:Boolean):void
		{
			SetAllNoSelected();
			_selected=b;
			Update();
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		

		public function Update():void
		{
			UpdateData();
			UpdateWallCorner();
		}
				
		private function OnCreation_Complete(e:FlexEvent):void
		{
			
			_vertexVec1=new Vector.<Number>();
			_vertexVec2=new Vector.<Number>();
			_vertexVec3=new Vector.<Number>();
			
			if(_wallType=="1")
			{
				_vertexVec1.push(0,0,100,0);
			}
			else if(_wallType=="2")
			{
				_vertexVec1.push(0,0,0,100);
			}
			
			
			UpdateData();
			
			
			//wall corners 
			_wallCornerVec=new Vector.<Wall_2DCorner>;
			
			for(var i:int=0;i<_vertexVec1.length;i+=2)
			{
				var wallCorner:Wall_2DCorner=new Wall_2DCorner();
				wallCorner.name="wallCorner"+i;
			
				addChild(wallCorner);
				_wallCornerVec.push(wallCorner);
			}
			
			UpdateWallCorner();
		}
		
		// not fixed
		private function UpdateData():void
		{

				var P1:Point=new Point(_vertexVec1[0],_vertexVec1[1]);
				var P2:Point=new Point(_vertexVec1[2],_vertexVec1[3]);
				
				var disP1P2:Number=Math.sqrt((P2.x-P1.x)*(P2.x-P1.x)+(P2.y-P1.y)*(P2.y-P1.y));

				var sinx:Number=Math.abs(P2.y-P1.y)/disP1P2;
				var cosx:Number=Math.abs(P2.x-P1.x)/disP1P2;
				
				_vertexVec2[0]=_vertexVec1[0]+10*sinx;
				_vertexVec2[1]=_vertexVec1[1]+10*cosx;
				
				_vertexVec2[2]=_vertexVec1[2]+10*sinx;
				_vertexVec2[3]=_vertexVec1[3]+10*cosx;
				
				_vertexVec3[0]=_vertexVec1[0]-10*sinx;
				_vertexVec3[1]=_vertexVec1[1]-10*cosx;
				
				_vertexVec3[2]=_vertexVec1[2]-10*sinx;
				_vertexVec3[3]=_vertexVec1[3]-10*cosx;
			 
		}
		
		private function UpdateWallCorner():void
		{
			//wall
			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			if(_selected)
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			graphics.moveTo(_vertexVec2[0],_vertexVec2[1]);
			graphics.lineTo(_vertexVec2[2],_vertexVec2[3]);
			graphics.lineTo(_vertexVec3[2],_vertexVec3[3]);
			graphics.lineTo(_vertexVec3[0],_vertexVec3[1]);
			graphics.endFill();
			
			//corners
			var len:int=_vertexVec1.length;
			for(var i:int=0;i<len;i+=2)
			{
				_wallCornerVec[i/2].Draw(_vertexVec1[i],_vertexVec1[i+1]);
			}
		}
		
	}
}