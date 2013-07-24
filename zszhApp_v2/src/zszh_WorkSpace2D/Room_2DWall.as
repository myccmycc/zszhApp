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
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	import flashx.textLayout.formats.Float;
	
	import zszh_Events.WS2D_PopupMenuEvent;
	
	import zszh_WorkSpace2D.PopupMenu_Wall2D;
	
	public class Room_2DWall extends Sprite
	{
		private var _popupWindowMenu:PopupMenu_Wall2D;
		private var _lineColor:uint;
		private var _wallColor:uint;
		private var _wallColorSelected:uint;
		
		private var _wallPos:Vector.<Number>;
		
		private var _selected:Boolean;
		
		public function Room_2DWall()
		{
			super();
			_popupWindowMenu=new PopupMenu_Wall2D();
			_lineColor=0xffffff;
			_wallColor=0x7c7e89;
			_wallColorSelected=0xff6666;
			_wallPos=new Vector.<Number>;
			_selected=true;
			
			addEventListener(MouseEvent.CLICK,WallCLICK);
			addEventListener(MouseEvent.MOUSE_OVER,WallMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,WallMouseOut);
			
			addEventListener(MouseEvent.MOUSE_DOWN,WallMouseDown);
			
			addEventListener(WS2D_PopupMenuEvent.HIDE_PopupMenu,HIDE_PopupMenu);
		}
		
		public function UpdateVertex(p1x:Number,p1y:Number,p2x:Number,p2y:Number,p3x:Number,p3y:Number,p4x:Number,p4y:Number):void
		{

			_wallPos[0]=p1x;_wallPos[1]=p1y;
			_wallPos[2]=p2x;_wallPos[3]=p2y;
			_wallPos[4]=p3x;_wallPos[5]=p3y;
			_wallPos[6]=p4x;_wallPos[7]=p4y;
			
			UpdateDraw();
		}
		
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
			UpdateDraw();
			PopUpManager.removePopUp(_popupWindowMenu);
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
	
		
		private function UpdateDraw():void
		{
			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			
			if(_selected&&room_2d.GetSelected())
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			graphics.moveTo(_wallPos[0],_wallPos[1]);
			graphics.lineTo(_wallPos[2],_wallPos[3]);
			graphics.lineTo(_wallPos[6],_wallPos[7]);
			graphics.lineTo(_wallPos[4],_wallPos[5]);
			graphics.endFill();
		}
		
		private function WallMouseOver(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(!room_2d.GetSelected()&&!_selected)
				UpdateDraw();
			
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor_Wall,2,-41,-14);
			e.stopPropagation();
		}
		private function WallMouseOut(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(!room_2d.GetSelected()&&!_selected)
				UpdateDraw();
			CursorManager.removeAllCursors();
			e.stopPropagation();
		}
		
		private function WallCLICK(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			room_2d.SetSelected(true);

			SetSelected(true);
			PopUpManager.addPopUp(_popupWindowMenu,this,false);
		
			var pt:Point = new Point(e.localX, e.localY);
			pt = e.target.localToGlobal(pt);
			_popupWindowMenu.move(pt.x,pt.y);
			//PopUpManager.centerPopUp(_popupWindowMenu);
			e.stopPropagation();
			
		}
		
		
			//----------------wall mouse move event ---------------------------------------
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		
		private var wallName:String;
		private var wallNumber:String;

		private function WallMouseDown(e:MouseEvent):void
		{
		  var room_2d:Object2D_Room=(this.parent as Object2D_Room);
		  room_2d.SetAllSelected(false);
		  
		  
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
		  this.SetSelected(ture);
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
			var thisRoom:Object2D_Room=(this.parent as Object2D_Room);
			
			var vecLen:int=thisRoom._vertexVec1.length;
			
			var P0:Point=new Point(thisRoom._vertexVec1[(i+0)%vecLen],-thisRoom._vertexVec1[(i+1)%vecLen]);
			
			var P1:Point=new Point(thisRoom._vertexVec1[(i+2)%vecLen],-thisRoom._vertexVec1[(i+3)%vecLen]);
			
			var P2:Point=new Point(thisRoom._vertexVec1[(i+4)%vecLen],-thisRoom._vertexVec1[(i+5)%vecLen]);
			
			var P3:Point=new Point(thisRoom._vertexVec1[(i+6)%vecLen],-thisRoom._vertexVec1[(i+7)%vecLen]);    
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
				
				thisRoom._vertexVec1[(i+2)%vecLen]=(int)(i1.x);
				
				thisRoom._vertexVec1[(i+3)%vecLen]=(int)(-i1.y);
				
				thisRoom._vertexVec1[(i+4)%vecLen]=(int)(i2.x);
				
				thisRoom._vertexVec1[(i+5)%vecLen]=(int)(-i2.y);
				
			}
			
			thisRoom.Object2DUpdate();
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
		
		
		private function HIDE_PopupMenu(e:WS2D_PopupMenuEvent):void
		{
			PopUpManager.removePopUp(_popupWindowMenu);
			trace(e._text);
		}
		
	}
}