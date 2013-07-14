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
			_selected=false;
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
				_indiceVec.push(0,1,2,0,2,3);
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
				wall.name="wall"+i;
				addChild(wall);
				_wallVec.push(wall);
				wall.Draw(_vertexVec2[i],_vertexVec2[i+1],_vertexVec2[(i+2)%len],_vertexVec2[(i+3)%len],_vertexVec3[i],_vertexVec3[i+1],_vertexVec3[(i+2)%len],_vertexVec3[(i+3)%len]);
			}
			
			//wall corners 
			_wallCornerVec=new Vector.<Room_2DCorner>;
			
			for(i=0;i<_vertexVec1.length;i+=2)
			{
				var wallCorner:Room_2DCorner=new Room_2DCorner();
				wallCorner.name="wallCorner"+i;
				wallCorner.addEventListener(MouseEvent.MOUSE_DOWN,CornerMouseDown);
				
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
				
				var n:Number=vec1.x*vec2.x+vec1.y*vec2.y;
				var m:Number=Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y)*Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				
				var ang:Number=Math.acos(n/m);
				
				var p:Point=new Point(0,0);
				//var d:Number=Math.sin(ang);
				
				//sin ang
				var sina:Number=(vec1.x*vec2.y-vec1.y*vec2.x)/m;
				
				p.x=pos2.x-(vec2.x-vec1.x)*10/sina;
				p.y=pos2.y-(vec2.y-vec1.y)*10/sina;
				
				_vertexVec2[i]=p.x;
				_vertexVec2[i+1]=p.y;
				
				p.x=pos2.x+(vec2.x-vec1.x)*10/sina;
				p.y=pos2.y+(vec2.y-vec1.y)*10/sina;
				
				_vertexVec3[i]=p.x;
				_vertexVec3[i+1]=p.y;
				
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
		
		
		//----------------wall mouse event ---------------------------------------
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		
		private var wallName:String;
		private var wallNumber:String;

		private function WallMouseOVER(e:MouseEvent):void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		private function WallMouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}

		private function WallMouseDown(e:MouseEvent):void
		{
			trace("-------------------WallMouseDown--------------------");
			
			bStart=true;
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
	
			wallName=e.target.name;
			wallNumber =wallName.slice(4,5);
			trace("WallMouseDown::wallName:"+wallName);
			trace("WallMouseDown::wallNumber:"+wallNumber);		
			
			trace("-------------------WallMouseDown----end----------------");
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
			e.stopPropagation();
		}
		
		private function WallMouseUp(e:MouseEvent):void
		{
			trace(e.currentTarget.name);
			bStart=false;
			CursorManager.removeAllCursors();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
		}
		private function WallMouseMove(e:MouseEvent):void
		{
			if(!bStart)
				return;
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
			var i:int=Number(wallNumber);
			MoveWall(i);
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
		}
		
		private function MoveWall(i:int):void
		{
			var vecLen:int=_vertexVec1.length;
			
			var P0:Point=new Point(_vertexVec1[(i+0)%vecLen],-_vertexVec1[(i+1)%vecLen]);
			
			var P1:Point=new Point(_vertexVec1[(i+2)%vecLen],-_vertexVec1[(i+3)%vecLen]);
			
			var P2:Point=new Point(_vertexVec1[(i+4)%vecLen],-_vertexVec1[(i+5)%vecLen]);
			
			var P3:Point=new Point(_vertexVec1[(i+6)%vecLen],-_vertexVec1[(i+7)%vecLen]);    
			trace("P0123:"+P0+P1+P2+P3);
			
			
			
			
			//1.求鼠标移动的向量
			
			var VMouseMove:Point=new Point((int)(this.stage.mouseX-startPoint.x),int(-this.stage.mouseY+startPoint.y));
			trace("VMouseMove:"+VMouseMove);
			
			
			//1.求移动的P1P2线段
			
			var VP1P2:Point=new Point(P2.x-P1.x,P2.y-P1.y);
			
			trace("VP1P2:"+VP1P2);
			
			//1.求P1P2线段逆时针方向法线向量
			
			var VP1P2_Normal:Point= new Point(-VP1P2.y,VP1P2.x);
			
			trace("VP1P2_Normal:"+VP1P2_Normal);
			
			
			
			//1求夹角，P1P2_Normal和 MouseMove。
			
			var d:Number=VP1P2_Normal.x*VMouseMove.x+VP1P2_Normal.y*VMouseMove.y;
			
			var d1:Number=Math.sqrt(VP1P2_Normal.x*VP1P2_Normal.x+VP1P2_Normal.y*VP1P2_Normal.y) * Math.sqrt(VMouseMove.x*VMouseMove.x+VMouseMove.y*VMouseMove.y);
			
			var VMouseMove_arg:Number= Math.acos(d/d1);
			
			
			trace("mouse_move to normal arg:"+VMouseMove_arg);
			
			trace("mouse_move to normal ang:"+VMouseMove_arg*180/Math.PI);
			
			
			
			//2 P1P2 直线方程  Ax+By+c=0的表达式
			
			var A:Number=(P2.y-P1.y);
			
			var B:Number=(P1.x-P2.x);
			
			var C:Number = P2.x*P1.y-P1.x*P2.y;
			
			trace("ABC:"+A+B+C);
			
			//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
			
			var aabb:Number=Math.sqrt(A*A+B*B);
			
			var dis:Number=Math.sqrt( VMouseMove .x*  VMouseMove .x+  VMouseMove .y*  VMouseMove .y)*Math.cos(VMouseMove_arg);
			
			
			var s:Number=dis*aabb;
			
			var C2:Number=C+s;
			trace("C2:"+C2);
			
			
			
			//求POP1，P3P2和  AX+BY+C2 两个交点
			
			
			
			var i1:Point=intersection(P0,P1,A,B,C2);
			
			var i2:Point=intersection(P3,P2,A,B,C2);
			
			
			
			trace("i1"+i1);
			
			trace("i2"+i2);
			
			if(i1.x!=Number.POSITIVE_INFINITY && i2.x!=Number.POSITIVE_INFINITY)
			{
				trace("i1g"+i1);
				
				trace("i2g"+i2);
				
				_vertexVec1[(i+2)%vecLen]=(int)(i1.x);
				
				_vertexVec1[(i+3)%vecLen]=(int)(-i1.y);
				
				_vertexVec1[(i+4)%vecLen]=(int)(i2.x);
				
				_vertexVec1[(i+5)%vecLen]=(int)(-i2.y);
				
			}
		}
		private static function intersection( a:Point, b:Point, A2:Number, B2:Number, C2:Number ):Point
		{
			var  A1:Number, B1:Number, C1:Number;
			
			A1 = b.y - a.y;
			B1 = a.x - b.x;
			C1 = b.x * a.y - a.x * b.y;

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
		
		
		//---------------corner mouse event---------------------------------------------
		private var cornerName:String;
		private var cornerNumber:String;
		private function CornerMouseDown(e:MouseEvent):void
		{
			//jl.hu for test
			var df:WS2D_PopupMenuEvent=new WS2D_PopupMenuEvent(WS2D_PopupMenuEvent.HIDE_PopupMenu);
			df._text="wocao";
			_wallVec[0].dispatchEvent(df);
			
			trace("-------------------CornerMouseDown--------------------");
			
			bStart=true;
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
			
			cornerName=e.target.name;
			cornerNumber =cornerName.slice(10,11);
			trace("CornerMouseDown::cornerName:"+cornerName);
			trace("CornerMouseDown::cornerNumber:"+cornerNumber);		
			
			trace("-------------------CornerMouseDown----end----------------");
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			e.stopPropagation();
		}
		
		private function CornerMouseUp(e:MouseEvent):void
		{
			bStart=false;
			CursorManager.removeAllCursors();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
		}
		private function CornerMouseMove(e:MouseEvent):void
		{
			if(!bStart)
				return;
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
			
			var i:int=Number(cornerNumber);
			MoveCorner(i);
			
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
		}
		
		private function MoveCorner(i:int):void
		{
			
			var VMouseMove:Point=new Point((int)(this.stage.mouseX-startPoint.x),int(-this.stage.mouseY+startPoint.y));
			trace("VMouseMove:"+VMouseMove);
			_vertexVec1[i]+=VMouseMove.x;
			_vertexVec1[i+1]-=VMouseMove.y;
			
		}
		
		
	}
}