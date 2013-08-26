package zszh_WorkSpace2D
{
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import zszh_Core.CommandManager;

	public class Object2D_Room extends Object2D_Base
	{
		public  var _vertexVec1:Vector.<Number>;
		public  var _vertexVec2:Vector.<Number>;
		public  var _vertexVec3:Vector.<Number>;
		
		public var _floor:Room_2DFloor;
		private var _wallVec:Vector.<Room_2DWall>;		
		private var _wallCornerVec:Vector.<Room_2DCorner>;
		private var _roomType:String;//0小,1大,2L,3room
		
		public function Object2D_Room(roomType:String,_vertexData:Vector.<Number>=null)
		{
			super();
			_vertexVec1=new Vector.<Number>();
			_vertexVec2=new Vector.<Number>();
			_vertexVec3=new Vector.<Number>();
			
			if(_vertexData!=null&&roomType=="0")
				_vertexVec1=_vertexData;
			else trace("error: Object2D_Room  construct _vertexData!=null  roomType==0");
			
			_roomType=roomType;		
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		
		
		public function DeleteThisRoom():void
		{
			CommandManager.Instance.Delete(this.parent as UIComponent,this);
		}
		
		public function SetAllSelected(b:Boolean):void
		{
			for(var i:int=0;i<_wallVec.length;i++)
				_wallVec[i].SetSelected(b);
			
			for(i=0;i<_wallCornerVec.length;i++)
				_wallCornerVec[i].SetSelected(b);
			
			_floor.SetSelected(b);
		}
	
		override public function Object2DUpdate():void
		{
			UpdateData();
			SetAllSelected(_selected);
			UpdateFloorWallCorner();
		}
		
		private function UpdateFloorWallCorner():void
		{
			//floor
			_floor.Update();
			
			//walls and corners
			var len:int=_vertexVec1.length;
			for(var i:int=0;i<len;i+=2)
			{
				_wallVec[i/2].UpdateVertex(_vertexVec2[i],_vertexVec2[i+1],_vertexVec2[(i+2)%len],_vertexVec2[(i+3)%len],_vertexVec3[i],_vertexVec3[i+1],_vertexVec3[(i+2)%len],_vertexVec3[(i+3)%len]);
				_wallCornerVec[i/2].Draw(_vertexVec1[i],_vertexVec1[i+1]);
			}
		}
		
		
		private function OnCreation_Complete(e:FlexEvent):void
		{
		
			if(_roomType=="4")
			{
				_vertexVec1.push(-100,50,100,100,100,-100,-100,-100);
			}
			else if(_roomType=="1")
			{
				_vertexVec1.push(-200,200,200,200,200,-200,-200,-200);
			}
				
			else if(_roomType=="2")
			{
				_vertexVec1.push(0,0, 200,0, 200,-200, -200,-200,  -200,200, 0,200);
			}
				
			else if(_roomType=="3")
			{
				_vertexVec1.push(0,400, 500,400, 500,-300, 0,-300, 0,-500, -500,-500, -500,500, 0,500);
			}
			
			
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
				wall._postionInRoom=i;
				addChild(wall);
				_wallVec.push(wall);
				wall.UpdateVertex(_vertexVec2[i],_vertexVec2[i+1],_vertexVec2[(i+2)%len],_vertexVec2[(i+3)%len],_vertexVec3[i],_vertexVec3[i+1],_vertexVec3[(i+2)%len],_vertexVec3[(i+3)%len]);
			}
			
			//wall corners 
			_wallCornerVec=new Vector.<Room_2DCorner>;
			for(i=0;i<_vertexVec1.length;i+=2)
			{
				var wallCorner:Room_2DCorner=new Room_2DCorner();
				wallCorner._posInRoom=i;
				wallCorner.Draw(_vertexVec1[i],_vertexVec1[i+1]);
				addChild(wallCorner);
				_wallCornerVec.push(wallCorner);
			}
		}
		
		
		
		private function UpdateData():void
		{	
			for(var i:int=0;i<_vertexVec1.length;i+=2)
			{
				var P1:Point=new Point(_vertexVec1[i],_vertexVec1[i+1]);
				var P2:Point=new Point(_vertexVec1[(i+2)%_vertexVec1.length],_vertexVec1[(i+3)%_vertexVec1.length]);
				var P3:Point=new Point(_vertexVec1[(i+4)%_vertexVec1.length],_vertexVec1[(i+5)%_vertexVec1.length]);	
				
				//2 P1P2 直线方程  Ax+By+c=0的表达式
			
				var A1:Number=(P2.y-P1.y);
			
				var B1:Number=(P1.x-P2.x);
			
				var C1:Number = P2.x*P1.y-P1.x*P2.y;
			
				//trace("ABC:"+A1+B1+C1);
			
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
			
				var aabb:Number=Math.sqrt(A1*A1+B1*B1);
			
				var dis:Number=10;
			
			
				var s:Number=dis*aabb;
			
				var C1_1:Number=C1+s;
				var C1_2:Number=C1-s;
				//trace("C1_1:"+C1_1);
				//trace("C1_2:"+C1_2);
				
				
				//2 P2P3 直线方程  Ax+By+c=0的表达式
			
				var A2:Number=(P3.y-P2.y);
			
				var B2:Number=(P2.x-P3.x);
			
				var C2:Number = P3.x*P2.y-P2.x*P3.y;
			
				//trace("ABC:"+A2+B2+C2);
			
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
			
				var aabb2:Number=Math.sqrt(A2*A2+B2*B2);
			
				var dis2:Number=10;
			
			
				var s2:Number=dis2*aabb2;
			
				var C2_1:Number=C2+s2;
				var C2_2:Number=C2-s2;
				//trace("C2_1:"+C2_1);
				//trace("C2_2:"+C2_2);
			
			
			
				 //求P1P2平移线 和P2P3平移线 交点
				var p:Point=intersection(A1,B1,C1_1,A2,B2,C2_1);
				if(p.x!=Number.POSITIVE_INFINITY&& p.y!=Number.POSITIVE_INFINITY)
				{
					_vertexVec3[i]=p.x;
					_vertexVec3[i+1]=p.y;
				}
				
				p=intersection(A1,B1,C1_2,A2,B2,C2_2);
				if(p.x!=Number.POSITIVE_INFINITY&& p.y!=Number.POSITIVE_INFINITY)
				{
					_vertexVec2[i]=p.x;
					_vertexVec2[i+1]=p.y;
				}
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
		
		private static function Direction(p0:Point,p1:Point,p2:Point):int
		{
			var p0p1:Point=new Point(p1.x-p0.x,p1.y-p0.y);
			var p0p2:Point=new Point(p2.x-p0.x,p2.y-p0.y);
			
			var cross:int=p0p1.x*p0p2.y-p0p1.y*p0p2.x;
			return cross;
		}
		
		private static function OnSegment(p0:Point,p1:Point,p2:Point):Boolean
		{
			var minx:Number=Math.min(p0.x,p1.x);
			var miny:Number=Math.min(p0.y,p1.y);
			
			var maxx:Number=Math.max(p0.x,p1.x);
			var maxy:Number=Math.max(p0.y,p1.y);
			
			if(p2.x>=minx&&p2.x<=maxx&&p2.y>=miny&&p2.y<=maxy)
				return true;
			return false;
		}
		
		private static function IsSegmentIntersection( p0:Point,p1:Point,p2:Point,p3:Point ):Boolean
		{
			var d1:int=Direction(p0,p1,p2);var d2:int=Direction(p0,p1,p3);
			var t1:int=Direction(p2,p3,p0);var t2:int=Direction(p2,p3,p1);
			if(d1*d2<0&&t1*t2<0) return true;
			 
			if(!d1&&OnSegment(p0,p1,p2))
				return true;
			if(!d2&&OnSegment(p0,p1,p3))
				return true;
			if(!t1&&OnSegment(p2,p3,p0))
				return true;
			if(!t2&&OnSegment(p2,p3,p1))
				return true;
			return false;
		}
		
		//多边形自相交检测
		public static function SelfIntersection(vertex:Vector.<Number>,pos:int):Boolean
		{
			
			var len:int=vertex.length;
			var P0:Point=new Point(vertex[(pos)%len],vertex[(pos+1)%len]);
			var P1:Point=new Point(vertex[(pos+2)%len],vertex[(pos+3)%len]);
			
			for(var i:int=4;i<len-2;i+=2)
			{
				var P2:Point=new Point(vertex[(pos+i)%len],vertex[(pos+i+1)%len]);
				var P3:Point=new Point(vertex[(pos+i+2)%len],vertex[(pos+i+3)%len]);
				
				var isInter:Boolean=IsSegmentIntersection(P0,P1,P2,P3);
				if(isInter)
				{
					if(P1.x==P2.x&&P1.y==P2.y&&!OnSegment(P2,P3,P0))
						return false;
					if(P0.x==P3.x&&P0.y==P3.y&&!OnSegment(P2,P3,P1))
						return false;
					return true;
				}
			}
			
			return false;
		}

	}
}