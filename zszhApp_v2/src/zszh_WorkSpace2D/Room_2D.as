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
				wall.UpdateVertex(_vertexVec2[i],_vertexVec2[i+1],_vertexVec2[(i+2)%len],_vertexVec2[(i+3)%len],_vertexVec3[i],_vertexVec3[i+1],_vertexVec3[(i+2)%len],_vertexVec3[(i+3)%len]);
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