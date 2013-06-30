package zszh_away3d
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	
	public class WS2D_Room extends UIComponent
	{
		public var _vertexVec:Vector.<Number>=new Vector.<Number>();//inside
		public var _vertexVec2:Vector.<Number>=new Vector.<Number>();//outside
		public var _vertexVec3:Vector.<Number>=new Vector.<Number>();//outside
		
		public var _indiceVec:Vector.<int>=new Vector.<int>;
		public var _uvVec:Vector.<Number>=new Vector.<Number>;
		
		public var _floorTex:String="../embeds/TextureFloor.jpg";
		public var _floorTexLoader:Loader
		public var _floorSprite:Sprite=new Sprite();
			
		public function WS2D_Room()
		{
			super();
			
			
			_vertexVec.push(0,0,400,0,400,400,0,400);
			
			for(var i:int=0;i<_vertexVec.length;i+=2)
			{
				var pos1:Point=new Point(_vertexVec[i],_vertexVec[i+1]);
				var pos2:Point=new Point(_vertexVec[(i+2)%_vertexVec.length],_vertexVec[(i+3)%_vertexVec.length]);
				var pos3:Point=new Point(_vertexVec[(i+4)%_vertexVec.length],_vertexVec[(i+5)%_vertexVec.length]);
				
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
				
				_uvVec.push(_vertexVec[i]/400,_vertexVec[i+1]/400);
				
			}
			
			_indiceVec.push(0,1,2,0,2,3);
			
			addChild(_floorSprite);
			_floorSprite.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			_floorSprite.addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			_floorSprite.addEventListener(MouseEvent.MOUSE_UP,MouseUp);
			
			_floorTexLoader = new Loader();
			
			//_floorTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,DrawRoomFloor2D);
			
			_floorTexLoader.load(new URLRequest(_floorTex));
			
		}
		
		public function DrawRoomFloor2D():void
		{
			var bm:Bitmap = Bitmap(_floorTexLoader.content);
			_floorSprite.graphics.clear();
			_floorSprite.graphics.lineStyle(0, 0, 0);
			_floorSprite.graphics.beginFill(0xFF0000);
			_floorSprite.graphics.beginBitmapFill(bm.bitmapData);
			_floorSprite.graphics.drawTriangles(_vertexVec,_indiceVec,_uvVec);
			_floorSprite.graphics.endFill();
		}
		
		public function DrawRoomWall2D():void
		{
			for(var i:int=0;i<_vertexVec2.length;i+=2)
			{	
				var s:Sprite=new Sprite;
				s.name="wall"+i;
				addChild(s);
				s.graphics.clear();
				s.graphics.lineStyle(3,0xff0000);
				s.graphics.beginFill(0xff0000,0.5);
				
				s.graphics.moveTo(_vertexVec2[i],_vertexVec2[i+1]);
				s.graphics.lineTo(_vertexVec2[(i+2)%_vertexVec2.length],_vertexVec2[(i+3)%_vertexVec2.length]);
				s.graphics.lineTo(_vertexVec3[(i+2)%_vertexVec3.length],_vertexVec3[(i+3)%_vertexVec3.length]);
				s.graphics.lineTo(_vertexVec3[i],_vertexVec3[i+1]);
				
				s.graphics.endFill();
				
				s.addEventListener(MouseEvent.MOUSE_DOWN,WallMouseDown);
				s.addEventListener(MouseEvent.MOUSE_MOVE,WallMouseMove);
				s.addEventListener(MouseEvent.MOUSE_UP,WallMouseUp);
			}
		}
			
		
		
		
		
		
		private function MouseDown(e:MouseEvent):void
		{
			this.startDrag();
		}
		
		private function MouseMove(e:MouseEvent):void
		{
		}
		
		private function MouseUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		
		
		public var startPoint:Point=new Point;
		public var bStart:Boolean=false;
		private function WallMouseDown(e:MouseEvent):void
		{
			e.target.startDrag(false);
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
			bStart=true;
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
			var vecLen:int=_vertexVec.length;
			var P0:Point=new Point(_vertexVec[(i+0)%vecLen],_vertexVec[(i+1)%vecLen]);
			var P1:Point=new Point(_vertexVec[(i+2)%vecLen],_vertexVec[(i+3)%vecLen]);
			var P2:Point=new Point(_vertexVec[(i+4)%vecLen],_vertexVec[(i+5)%vecLen]);
			var P3:Point=new Point(_vertexVec[(i+6)%vecLen],_vertexVec[(i+7)%vecLen]);	
			
			
			//1.求移移动的距离
			var dx:Number=this.mouseX-startPoint.x;
			var dy:Number=this.mouseY-startPoint.y;
			var dis2:Number=dx*dx + dy*dy;
			trace("dis2:"+dis2);
			//2.求P0P1直线方程

			var k1:Number=(P1.y-P0.y)/(P1.x-P0.x);
			var b1:Number = P1.y - k1*P1.x; 
			trace("k1:"+k1);
			trace("b1:"+b1);
			
			//3.求直线上  的点 PX坐标 P1---PX 距离为dis
			//(x1-x0)^2+(y1-y0)^2=dis*dis
			//y1=x1*k1+b1
			//(x1-x0)^2+(x1*k1+b1-y0)^2=dis*dis
			//(x1-P1.x)^2+(x1*k1+b1-P1.y)^2=dis*dis
			
			//(1+k1*k1)*x1^2 + 2(-P1.x+(b1-P1.y)*k1)*x1 + P1.x^2+(b1-P1.y)^2- dis^2=0
			var a:Number=1+k1*k1;
			var b:Number=2*(-P1.x+(b1-P1.y)*k1);
			var c:Number=P1.x*P1.x+(b1-P1.y)*(b1-P1.y)- dis2;
			
			//PX的坐标
			var x1:Number;
			if(dx<0)
			 x1=(-b-Math.sqrt(b*b-4*a*c))/2*a;
			else  x1=(-b+Math.sqrt(b*b-4*a*c))/2*a;
			var y1:Number=k1*x1+b1;
			trace("P1.x-P0.x"+P1.x);
			trace("P1.x-P0.x"+P0.x);
			if(Math.abs(P1.x-P0.x)<=0.001)
			{
				x1=P1.x;
				y1=P1.y+dy;
				
				_vertexVec[(i+2)%8]=x1;
				_vertexVec[(i+3)%8]=y1;
			}
			
			_vertexVec[(i+2)%8]=x1;
			_vertexVec[(i+3)%8]=y1;
			trace("x1:"+x1);
			trace("y1:"+y1);
			
			
			
			
			
			var x2:Number;
			var y2:Number;
		
			
			
			//PX的 直线方程
			/*var k11:Number=(P2.y-P1.y)/(P2.x-P1.x);
			var b11:Number = y1 - k11*x1; 
			
			
			var k22:Number=(P3.y-P2.y)/(P3.x-P2.x);
			var b22:Number = P3.y - k22*P3.x; 
			
		 	x2=(b22-b11)/k11-k22;
		 	y2=k11*x2+b11;
			
			if((P2.x-P1.x)==0)
			{
				x2=x1;
				y2=k22*x2+b22;
			}
			
			if((P3.x-P2.x)==0)
			{
				x2=P3.x;
				y2=k11*x2+b11;
			}
			
			trace("x2:"+x2);
			trace("y2:"+y2);
			_vertexVec[(i+4)%8]=x2;
			_vertexVec[(i+5)%8]=y2;*/
			
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
			
			DrawRoomFloor2D();
		}
		
		private function WallMouseUp(e:MouseEvent):void
		{
			e.target.stopDrag();
			bStart=false;
		}
		
		
	}
}