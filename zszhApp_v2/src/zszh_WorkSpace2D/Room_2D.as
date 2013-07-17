package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	import zszh_Events.WS2D_PopupMenuEvent;

	
	
	public class Room_2D extends UIComponent
	{
		public  var _vertexVec1:Vector.<Number>;
		public var _indiceVec:Vector.<int>;
		
		private  var _vertexVec2:Vector.<Number>;
		private  var _vertexVec3:Vector.<Number>;
	
		
		private var _selected:Boolean;
		private var _floor:Room_2DFloor;
		private var _wallVec:Vector.<Room_2DWall>;		
		private var _wallCornerVec:Vector.<Room_2DCorner>;
		private var _roomType:int;//0小,1大,2L
		
		public function Room_2D()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			_roomType=0;
			_selected=ture;
		}
		
		public function SetAllNoSelected():void
		{
			for(var i:int=0;i<_wallVec.length;i++)
				_wallVec[i].SetSelected(false);
			
			//for(i=0;i<_wallCornerVec.length;i++)
				//_wallCornerVec[i].SetSelected(false);
		}
		
		public function SetSelected(b:Boolean):void
		{
			SetAllNoSelected();
			_selected=b;
			UpdateFloorWallCorner();
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		private function OnCreation_Complete(e:FlexEvent):void
		{
			
			_vertexVec1=new Vector.<Number>();
			_vertexVec2=new Vector.<Number>();
			_vertexVec3=new Vector.<Number>();
			_indiceVec =new Vector.<int>();
			
			if(_roomType==0)
			{
				_vertexVec1.push(-100,100,100,100,100,-100,-100,-100);
			}
			
			_indiceVec.push(0,1,2,0,2,3);
			
			UpdateData();
			
			//floor
			_floor=new Room_2DFloor();
			addChild(_floor);
			
			//walls
			_wallVec=new Vector.<Room_2DWall>;	
			var len:int=_vertexVec1.length;
			for(var i:int=0;i<len;i+=2)
			{
				var wall:Room_2DWall=new Room_2DWall();
				wall.name="wall"+i;
				addChild(wall);
				_wallVec.push(wall);
				wall.UpdateVertex(_vertexVec2[i],_vertexVec2[i+1],_vertexVec2[(i+2)%len],_vertexVec2[(i+3)%len],_vertexVec3[i],_vertexVec3[i+1],_vertexVec3[(i+2)%len],_vertexVec3[(i+3)%len]);
			}
			
			//wall corners 
			_wallCornerVec=new Vector.<Room_2DCorner>;
			
			for(i=0;i<_vertexVec1.length;i+=2)
			{
				var wallCorner:Room_2DCorner=new Room_2DCorner();
				wallCorner.name="wallCorner"+i;
			
				addChild(wallCorner);
				_wallCornerVec.push(wallCorner);
			}
		}
		
		private function UpdateData():void
		{
			for(var i:int=0;i<_vertexVec1.length;i+=2)
			{
				var pos1:Point=new Point(_vertexVec1[i],_vertexVec1[i+1]);
				var pos2:Point=new Point(_vertexVec1[(i+2)%_vertexVec1.length],_vertexVec1[(i+3)%_vertexVec1.length]);
				var pos3:Point=new Point(_vertexVec1[(i+4)%_vertexVec1.length],_vertexVec1[(i+5)%_vertexVec1.length]);
				
				var vec1:Point=new Point(pos2.x-pos1.x,pos2.y-pos1.y);
				vec1.x=vec1.x/Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y);
				vec1.y=vec1.y/Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y);
				
				var vec2:Point=new Point(pos3.x-pos2.x,pos3.y-pos2.y);
				vec2.x=vec2.x/Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				vec2.y=vec2.y/Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				
				var n:Number=vec1.x*vec2.y-vec1.y*vec2.x;
				var m:Number=Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y)*Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				var sina:Number=n/m;
				
				p.x=pos2.x-(vec2.x-vec1.x)*10/sina;
				p.y=pos2.y-(vec2.y-vec1.y)*10/sina;
				
				_vertexVec2[i]=p.x;
				_vertexVec2[i+1]=p.y;
				
				p.x=pos2.x+(vec2.x-vec1.x)*10/sina;
				p.y=pos2.y+(vec2.y-vec1.y)*10/sina;
				
				_vertexVec3[i]=p.x;
				_vertexVec3[i+1]=p.y;
				
				
				//2 P1P2 直线方程  Ax+By+c=0的表达式
			
				var A:Number=(P2.y-P1.y);
			
				var B:Number=(P1.x-P2.x);
			
				var C:Number = P2.x*P1.y-P1.x*P2.y;
			
				trace("ABC:"+A+B+C);
			
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
			
				var aabb:Number=Math.sqrt(A*A+B*B);
			
				var dis:Number=10;
			
			
				var s:Number=dis*aabb;
			
				var C2:Number=C+s;
				trace("C2:"+C2);
				
				
				//2 P2P3 直线方程  Ax+By+c=0的表达式
			
				var A:Number=(P2.y-P1.y);
			
				var B:Number=(P1.x-P2.x);
			
				var C:Number = P2.x*P1.y-P1.x*P2.y;
			
				trace("ABC:"+A+B+C);
			
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
			
				var aabb:Number=Math.sqrt(A*A+B*B);
			
				var dis:Number=10;
			
			
				var s:Number=dis*aabb;
			
				var C2:Number=C+s;
				trace("C2:"+C2);
			
			
			
				 //求P1P2和P2P3交点
			
			
			
					var i1:Point=intersection(A,B,C,A,B,C2);
			
				
			}
		}
		
		private static function intersection( A1:Number, B1:Number, C1:Number , A2:Number, B2:Number, C2:Number ):Point
		{
			if (A1 * B2 == B1 * A2)    {
				if ((A1 + B1) * C2==(A2 + B2) * C1 ) {
					return new Point(Number.POSITIVE_INFINITY,0);
				} else {
					return new Point(Number.POSITIVE_INFINITY,Number.POSITIVE_INFINITY);
				}
			} 
				
			else {
				var result:Point=new Point;
				result.x = (B2 * C1 - B1 * C2) / (A2 * B1 - A1 * B2);
				result.y = (A1 * C2 - A2 * C1) / (A2 * B1 - A1 * B2);
				return result;
			}
		}
		
		private function UpdateFloorWallCorner():void
		{
			//floor
			_floor.Draw();
			
			//walls and corners
			var len:int=_vertexVec1.length;
			for(var i:int=0;i<len;i+=2)
			{
				_wallVec[i/2].Draw(_vertexVec2[i],_vertexVec2[i+1],_vertexVec2[(i+2)%len],_vertexVec2[(i+3)%len],_vertexVec3[i],_vertexVec3[i+1],_vertexVec3[(i+2)%len],_vertexVec3[(i+3)%len]);
				_wallCornerVec[i/2].Draw(_vertexVec1[i],_vertexVec1[i+1]);
			}
		}
		
	}
}