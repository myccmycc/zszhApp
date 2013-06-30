package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	public class Room_Small2D extends UIComponent
	{
		public var _vertexVec1:Vector.<Number>;
		public var _vertexVec2:Vector.<Number>;
		public var _vertexVec3:Vector.<Number>;
		
		public var _indiceVec:Vector.<int>;
		public var _uvVec:Vector.<Number>;
		
		public var _floorTex:String="../embeds/TextureFloor.jpg";
		public var _floorTexLoader:Loader;
		public var _floorBitmap:Bitmap;
		public var _floorSprite:Sprite=new Sprite();
		
		public var _wallArray:Array;
		public var _wallColor:uint ; //墙颜色
		
		[Embed(source="../embeds/Products/icon_AccHeader1.png")]
		private var imageCursor:Class;
		
		
		public function Room_Small2D()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		
		private function InitData()
		{
			_vertexVec1=new Vector.<Number>();
			_vertexVec2=new Vector.<Number>();
			_vertexVec3=new Vector.<Number>();
			_indiceVec =new Vector.<int>();
			_uvVec     =new Vector.<Number>();
			
			_vertexVec1.push(0,0,200,0,200,200,0,200);
			_indiceVec.push(0,1,2,0,2,3);
			for(var i:int=0;i<_vertexVec1.length;i+=2)
			{
				_uvVec.push(_vertexVec1[i]/200,_vertexVec1[i+1]/200);
			}
			
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
				var d:Number=Math.sin(ang);
				
				//sin ang
				var sina:Number=(vec1.x*vec2.y-vec1.y*vec2.x)/m;
				
				p.x=pos2.x-(vec2.x-vec1.x)*20/sina;
				p.y=pos2.y-(vec2.y-vec1.y)*20/sina;
				
				_vertexVec2[i]=p.x;
				_vertexVec2[i+1]=p.y;
				
				p.x=pos2.x+(vec2.x-vec1.x)*20/sina;
				p.y=pos2.y+(vec2.y-vec1.y)*20/sina;
				
				_vertexVec3[i]=p.x;
				_vertexVec3[i+1]=p.y;
				
			}
		}
		private function OnCreation_Complete(e:FlexEvent):void
		{
			InitData();
			
			_floorSprite=new Sprite();
			_floorSprite.buttonMode=true;
			_floorSprite.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			_floorSprite.addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			_floorSprite.addEventListener(MouseEvent.MOUSE_UP,MouseUp);
			addChild(_floorSprite);
			
			_floorTexLoader = new Loader();
			_floorTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_floorTexLoader.load(new URLRequest(_floorTex));
			
			function onComplete(e:Event):void
			{
				_floorBitmap = Bitmap(_floorTexLoader.content);
				DrawRoomFloor2D();
			}
			
			//walls
			_wallArray=new Array();
			_wallColor= 0xff0000; 
			for(var i:int=0;i<_vertexVec2.length;i+=2)
			{
				var wall:Room_Wall2D=new Room_Wall2D();
				wall._sprite.name="wall"+i;
				wall._sprite.addEventListener(MouseEvent.MOUSE_DOWN,WallMouseDown);
				wall._sprite.addEventListener(MouseEvent.MOUSE_OVER,WallMouseOVER);
				wall._sprite.addEventListener(MouseEvent.MOUSE_OUT,WallMouseOut);
				//wall._sprite.addEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
				//wall._sprite.addEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
				addChild(wall._sprite);
				_wallArray.push(wall);
			}
			
			DrawRoomWall2D();
		}
		public function DrawRoomFloor2D():void
		{
			_floorSprite.graphics.clear();
				
			_floorSprite.graphics.lineStyle(0, 0, 0);
				
			_floorSprite.graphics.beginFill(0xFF0000);
				
				
			if(_floorBitmap)
				_floorSprite.graphics.beginBitmapFill(_floorBitmap.bitmapData);
				
			//update uv
			_uvVec=new Vector.<Number>(); 
			for(var i:int=0;i<_vertexVec1.length;i+=2)
			{
				_uvVec.push(_vertexVec1[i]/200,_vertexVec1[i+1]/200);
			}
				
			_floorSprite.graphics.drawTriangles(_vertexVec1,_indiceVec,_uvVec);
				
			_floorSprite.graphics.endFill();	
		}
		
		public function DrawRoomWall2D():void
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
				var d:Number=Math.sin(ang);
				
				//sin ang
				var sina:Number=(vec1.x*vec2.y-vec1.y*vec2.x)/m;
				
				p.x=pos2.x-(vec2.x-vec1.x)*20/sina;
				p.y=pos2.y-(vec2.y-vec1.y)*20/sina;
				
				_vertexVec2[i]=p.x;
				_vertexVec2[i+1]=p.y;
				
				p.x=pos2.x+(vec2.x-vec1.x)*20/sina;
				p.y=pos2.y+(vec2.y-vec1.y)*20/sina;
				
				_vertexVec3[i]=p.x;
				_vertexVec3[i+1]=p.y;
				
			}
			
			for(var i:int=0;i<_vertexVec2.length;i+=2)
			{	
				var s:Sprite=_wallArray[i/2]._sprite;
				s.graphics.clear();
				s.graphics.lineStyle(3,0xff0000);
				s.graphics.beginFill(_wallColor,0.5);
				
				s.graphics.moveTo(_vertexVec2[i],_vertexVec2[i+1]);
				s.graphics.lineTo(_vertexVec2[(i+2)%_vertexVec2.length],_vertexVec2[(i+3)%_vertexVec2.length]);
				s.graphics.lineTo(_vertexVec3[(i+2)%_vertexVec3.length],_vertexVec3[(i+3)%_vertexVec3.length]);
				s.graphics.lineTo(_vertexVec3[i],_vertexVec3[i+1]);
				
				s.graphics.endFill();
			}
		}
		
		private function MouseDown(e:MouseEvent):void
		{
			this.startDrag();
			_wallColor=0x00ff00;
			DrawRoomWall2D();
		}
		
		private function MouseMove(e:MouseEvent):void
		{
		}
		
		private function MouseUp(e:MouseEvent):void
		{
			this.stopDrag();
			_wallColor=0xff0000;
			DrawRoomWall2D();
		}
		
		
		public var startPoint:Point=new Point;
		public var bStart:Boolean=false;
		private function WallMouseDown(e:MouseEvent):void
		{
			//e.target.startDrag(false);
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
			bStart=true;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_OUT,WallMouseUp);
		}
		
		private function WallMouseUp(e:MouseEvent):void
		{
			bStart=false;
			//e.target.stopDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_OUT,WallMouseUp);
		}
		private function WallMouseOVER(e:MouseEvent):void
		{
			CursorManager.setCursor(imageCursor);
		}
		private function WallMouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}
		
		private function WallMouseMove(e:MouseEvent):void
		{
			if(!bStart)
				
				return;
			
			
			
			var wallName:String=e.target.name;
			
			var wallNumber:String =wallName.slice(4,5);
			
			trace("wallName:"+wallName);
			
			trace("wallNumber:"+wallNumber);
			
			
			
			var i:int=Number(wallNumber);
			
			var vecLen:int=_vertexVec1.length;
			
			var P0:Point=new Point(_vertexVec1[(i+0)%vecLen],-_vertexVec1[(i+1)%vecLen]);
			
			var P1:Point=new Point(_vertexVec1[(i+2)%vecLen],-_vertexVec1[(i+3)%vecLen]);
			
			var P2:Point=new Point(_vertexVec1[(i+4)%vecLen],-_vertexVec1[(i+5)%vecLen]);
			
			var P3:Point=new Point(_vertexVec1[(i+6)%vecLen],-_vertexVec1[(i+7)%vecLen]);    
			trace("P0123:"+P0+P1+P2+P3);
			
			
			
			
			//1.求鼠标移动的向量
			
			var VMouseMove:Point=new Point((int)(this.mouseX-startPoint.x),int(-this.mouseY+startPoint.y));
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
			
			DrawRoomFloor2D();
			DrawRoomWall2D();
			
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
		}
		
		public static function intersection( a:Point, b:Point, A2:Number, B2:Number, C2:Number ):Point
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
		
	}
}