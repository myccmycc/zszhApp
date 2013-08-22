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
	import mx.core.INavigatorContent;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	
	import zszh_Core.CommandManager;
	
	public class Room_2DFloor extends UIComponent
	{
		public var _floorTex:String="zszh_res/basic/wall/TextureFloor.jpg";
		private var _floorTexLoader:Loader;
		private var _floorBitmap:Bitmap;
		private var _uvVec:Vector.<Number>;
		private var _uvScale:int;
		
		private var _popupWindowMenu:PopupMenu_Room2D_Floor;
		private var _selected:Boolean;
		
		public function Room_2DFloor()
		{
			super();
			_uvScale=100;
			this.addEventListener(DragEvent.DRAG_ENTER,DragEnter2D);
			this.addEventListener(DragEvent.DRAG_DROP,OnDrap);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			
		}
		
		private function DragEnter2D(event:DragEvent):void
		{			
			DragManager.acceptDragDrop(event.target as UIComponent);
		}
		
	    public function OnDrap(event:DragEvent):void
		{
			var className:String=String(event.dragSource.dataForFormat("className"));
			var classArgument:String=String(event.dragSource.dataForFormat("classArgument"));
			var resourcePath:String=String(event.dragSource.dataForFormat("resourcePath"));
			var objectName:String=String(event.dragSource.dataForFormat("objectName"));
			
			if(className=="diban")
			{
				_floorTex=resourcePath+"texture.jpg";
				_floorTexLoader = new Loader();
				_floorTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				_floorTexLoader.load(new URLRequest(_floorTex));
				
				function onComplete(e:Event):void
				{
					_floorBitmap = Bitmap(_floorTexLoader.content);
					Update();
				}
			}
		}
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
			Update();
		}
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		private function OnDeleteThisRoom(e:Event):void
		{
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			room_2d.DeleteThisRoom();
		}
		
		private function OnChangeFloor(e:Event):void
		{
			
		}
		private function OnChangeFloorTile(e:Event):void
		{}
			
		private function OnAddFurniture(e:Event):void	
		{}
			
		private function OnCreation_Complete(e:FlexEvent):void
		{
			addEventListener(MouseEvent.MOUSE_OVER,FloorMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,FloorMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,FloorMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,FloorMouseUp);
			addEventListener(MouseEvent.RIGHT_CLICK,FloorMouseClick);
		
			_floorTexLoader = new Loader();
			_floorTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_floorTexLoader.load(new URLRequest(_floorTex));
			_uvVec  =	new Vector.<Number>();
		
			function onComplete(e:Event):void
			{
				_floorBitmap = Bitmap(_floorTexLoader.content);
				Update();
			}
		}
		
		public function Update():void
		{
			graphics.clear();
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(0xFF0000);
			
			if(_floorBitmap)
				graphics.beginBitmapFill(_floorBitmap.bitmapData);
			
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			var vectex:Vector.<Number>=new Vector.<Number>;
			var len:int=room_2d._vertexVec1.length;
			
			for(var i:int=0;i<len;i++)
			{
				vectex.push(room_2d._vertexVec1[i]);
			}
			
			//多边形面积
			var points:Vector.<Point>=new Vector.<Point>;
			for(var i:int=0;i<vectex.length;i+=2)
			{
				var p1:Point=new Point(vectex[i],vectex[i+1]);
				//var p2:Point=new Point(vectex[(i+2)%vectex.length],vectex[(i+3)%vectex.length]);
				//var p1p2:Point=new Point(p2.x-p1.x,p2.y-p1.y);
				points.push(p1);
			}
			
			var mArea:int=GetPolygonArea(points);
			trace("面积：",mArea);
			 
			
			//三角分解
			var iPos:int=0;
			while(vectex.length>=6)
			{
				var index11:int=iPos%vectex.length;
				var index12:int=(iPos+1)%vectex.length;
				var index21:int=(iPos+2)%vectex.length;
				var index22:int=(iPos+3)%vectex.length;
				var index31:int=(iPos+4)%vectex.length;
				var index32:int=(iPos+5)%vectex.length;
				
				var p1:Point=new Point(vectex[index11],vectex[index12]);
				var p2:Point=new Point(vectex[index21],vectex[index22]);
				var p3:Point=new Point(vectex[index31],vectex[index32]);
					 
				var points:Vector.<Point>=new Vector.<Point>;
				points.push(p1);
				points.push(p2);
				points.push(p3);
					 
				var area:Number = GetPolygonArea(points);  //area==0 it is mean that the points on the same line
				
				var bCover:Boolean=false;//是否有其他 顶点在三角形中。。。
				for(var i:int=0;i<vectex.length;i+=2)
				{
					if(i!=index11&&i!=index21&&i!=index31)
					{
						bCover=PointinTriangle(p1,p2,p3,new Point(vectex[i],vectex[i+1]));
						if(bCover)
							break;
					}
				}
					 
				if(!bCover && area>=0||vectex.length==6)
				{     
					vectex.splice((iPos+2)%vectex.length,2);
					graphics.lineStyle(1,0xffff00);
							 
					graphics.moveTo(p1.x,-p1.y);
					graphics.lineTo(p3.x,-p3.y);
		 
					//graphics.endFill();

					//vertex
					var vertexVec:Vector.<Number>=new Vector.<Number>();
					vertexVec.push(p1.x,-p1.y,p2.x,-p2.y,p3.x,-p3.y);
					//indice
					var indiceVec:Vector.<int>=new Vector.<int>();
					indiceVec.push(0,1,2);
					//uv
					var uvVec:Vector.<Number>=new Vector.<Number>();
					uvVec.push(p1.x/_uvScale,-p1.y/_uvScale,p2.x/_uvScale,-p2.y/_uvScale,p3.x/_uvScale,-p3.y/_uvScale);

					graphics.drawTriangles(vertexVec,indiceVec,uvVec);
						
					continue;
					 
				}
				
				iPos+=2;
			}
			
			
			graphics.endFill();	
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
		}

		
		
		
		//--------------floor mouse event----------------------------------------
		private function FloorMouseOver(e:MouseEvent):void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		private function FloorMouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}
		
		private var _oldPos:Point;
		private function FloorMouseDown(e:MouseEvent):void
		{
			SetSelected(false);
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(room_2d.GetSelected())
			{
				room_2d.startDrag();
				_oldPos=new Point(room_2d.x,room_2d.y);
				e.stopPropagation();
			}
			
		}
		
		private function FloorMouseUp(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(room_2d.GetSelected())
			{
				room_2d.stopDrag();
				
				if(_oldPos.x!=room_2d.x || _oldPos.y!=room_2d.y)
				{
					CommandManager.Instance.Move(room_2d,_oldPos,new Point(room_2d.x,room_2d.y));
				}
				//e.stopPropagation();
			}
			else room_2d.SetSelected(true);
		}
		private function FloorMouseClick(e:MouseEvent):void
		{
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			if(room_2d.GetSelected())
			{
				if(_popupWindowMenu)
				{
					PopUpManager.removePopUp(_popupWindowMenu);
					_popupWindowMenu=null;
				}
				
				_popupWindowMenu=new PopupMenu_Room2D_Floor;
				_popupWindowMenu.addEventListener(PopupMenu_Room2D_Floor.DELETE_THIS_ROOM,OnDeleteThisRoom,false,0,true);
				_popupWindowMenu.addEventListener(PopupMenu_Room2D_Floor.CHANGE_FLOOR,OnChangeFloor,false,0,true);
				_popupWindowMenu.addEventListener(PopupMenu_Room2D_Floor.CHANGE_FLOORTILE,OnChangeFloorTile,false,0,true);
				_popupWindowMenu.addEventListener(PopupMenu_Room2D_Floor.ADD_FURNITURE,OnAddFurniture,false,0,true);
				
				PopUpManager.addPopUp(_popupWindowMenu,this,false);
				var pt:Point = new Point(0, 0);
				pt = e.target.localToGlobal(pt);
				_popupWindowMenu.move(pt.x,pt.y);
			}
			
		}
		
		
		
		
		//--------------some private function----------------------------------------
		private function PointinTriangle( A:Point, B:Point, C:Point, P:Point):Boolean
		{
			var  v0:Point =new Point(C.x - A.x,C.y-A.y) ;
			var  v1:Point =new Point(B.x - A.x,B.y-A.y) ;
			var  v2:Point =new Point(P.x - A.x,P.y-A.y) ;
			
			var dot00 = v0.x*v0.x+v0.y*v0.y;
			var dot01 = v0.x*v1.x+v0.y*v1.y;
			var dot02 = v0.x*v2.x+v0.y*v2.y;
			var dot11 = v1.x*v1.x+v1.y*v1.y;
			var dot12 = v1.x*v2.x+v1.y*v2.y;
			
			var inverDeno = 1 / (dot00 * dot11 - dot01 * dot01) ;
			
			var u = (dot11 * dot02 - dot01 * dot12) * inverDeno ;
			if (u <= 0 || u >=1) // if u out of range, return directly  =0在A点，1在B点
			{
				return false ;
			}
			
			var v = (dot00 * dot12 - dot01 * dot02) * inverDeno ;
			if (v <=0 || v >= 1) // if v out of range, return directly  =0在A点，1在C点
			{
				return false ;
			}
			
			return u + v < 1 ; //u+v ==1 是在线上，在这里不算在三角形内。
		}

		public static function GetPolygonArea(points:Vector.<Point>):Number
		{
			if (points.length < 3) {//至少是三角形
				return 0;
			}
			var result:Number = 0;
			for (var i:int = 1; i < points.length - 1; i++) {
				
				var p0:Point = points[0];
				var pi1:Point = points[i];
				var pi2:Point = points[i+1];
				var area:Number=-(pi1.x-p0.x)*(pi2.y-p0.y)+(pi2.x-p0.x)*(pi1.y-p0.y);
				result += area;
			}
			result *= 0.5;
			return result;
		}
	}
}