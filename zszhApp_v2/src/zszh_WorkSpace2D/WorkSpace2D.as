package zszh_WorkSpace2D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	import mx.rpc.http.HTTPService;
	
	import spark.components.Image;
	
	
	public class WorkSpace2D extends UIComponent
	{
		public var _grid:Grid;
		public var _objects:Array;
		
		//---for create 3d space-------------------
		public var _room2DVec:Vector.<Object2D_Room>;
		public var _wall2DVec:Vector.<Object2D_PartitionWall>;
		public var _modelsVec:Vector.<Object2D_Model>;
		
		
		public var _xMin:Number;
		public var _yMin:Number;
		public var _xMax:Number;
		public var _yMax:Number;
		
		public function WorkSpace2D()
		{
			super();
			_objects=new Array;
			this.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			this.addEventListener(ResizeEvent.RESIZE,OnResize);
		}
		
		public function SaveToXML(strPath:String):void
		{	
			var xml:XML = <Root></Root>;
			{
				for(var i:int=0;i<_room2DVec.length;i++)
				{
					var xmlList:XMLList = XMLList("<Object>"+"</Object>");
					xmlList.appendChild(new XMLList("<ClassName>"+_room2DVec[i].className+"</ClassName>"));
					xmlList.appendChild(new XMLList("<Position>"+_room2DVec[i].x+","+_room2DVec[i].y+"</Position>"));
					
					var len:int=_room2DVec[i]._vertexVec1.length;
					var str:String="";
					for(var j:int=0;j<len;j++)
					{
						if(j<len-1)
							str+=_room2DVec[i]._vertexVec1[j].toString()+",";
						else str+=_room2DVec[i]._vertexVec1[j].toString();
					}
						
					Alert.show(str);
					xmlList.appendChild(new XMLList("<Data>"+str+"</Data>"));
					xml.appendChild(xmlList);
				}
				
				for(var i:int=0;i<_wall2DVec.length;i++)
				{
					var xmlList:XMLList = XMLList("<Object>"+"</Object>");
					xmlList.appendChild(new XMLList("<ClassName>"+_wall2DVec[i].className+"</ClassName>"));
					xmlList.appendChild(new XMLList("<Position>"+_wall2DVec[i].x+","+_wall2DVec[i].y+"</Position>"));
					
					
					var len:int=_wall2DVec[i]._vertexVec1.length;
					var str:String="";
					for(var j:int=0;j<len;j++)
					{
						if(j<len-1)
							str+=_wall2DVec[i]._vertexVec1[j].toString()+",";
						else str+=_wall2DVec[i]._vertexVec1[j].toString();
					}
					
					Alert.show(str);
					xmlList.appendChild(new XMLList("<Data>"+str+"</Data>"));
					xml.appendChild(xmlList);
				}
				
				for(var i:int=0;i<_modelsVec.length;i++)
				{
					var xmlList:XMLList = XMLList("<Object>"+"</Object>");
					xmlList.appendChild(new XMLList("<ClassName>"+_modelsVec[i].className+"</ClassName>"));
					xmlList.appendChild(new XMLList("<Position>"+_modelsVec[i].x+","+_modelsVec[i].y+"</Position>"));
					xmlList.appendChild(new XMLList("<ModelName>"+_modelsVec[i]._modelName+"</ModelName>"));
					xmlList.appendChild(new XMLList("<ResourcePath>"+_modelsVec[i]._resourcePath+"</ResourcePath>"));
					xml.appendChild(xmlList);
				}
			}
			

			var data:Object = new Object();
			data.xmlData = xml;//.toXMLString();
			Alert.show(data.xmlData);
			
			var httpPost:HTTPService=new HTTPService;
			httpPost.url="services/SaveXML.php";
			httpPost.method="POST";
			httpPost.useProxy=false;
			httpPost.resultFormat="xml";
			//httpPost.contentType="application/xml";
			//httpPost.request=data;
			httpPost.send(data);
			
		}
		public function LoadFromXML(strPath:String):void
		{
			var myXML:XML=new XML();
			var myURLLoader:URLLoader = new URLLoader(new URLRequest(strPath));
			myURLLoader.addEventListener("complete", xmlLoaded);
			
			function xmlLoaded(evtObj:Event)
			{
				myXML=XML(myURLLoader.data);
				
				for (var pname:String in  myXML.Object)
				{
					trace(myXML.Object[pname]);
					
					if(myXML.Object[pname].ClassName=="Object2D_Room")
					{
						var vec:Vector.<Number>=new Vector.<Number>;
						var vecStr:String=myXML.Object[pname].Data;
						var paramsVec:Array = vecStr.split(",");
						
						for(var i:int=0;i<paramsVec.length;i++)
							vec.push(paramsVec[i])
						
		
						var room:Object2D_Room=new Object2D_Room("0",vec);
						
						var pos:String=myXML.Object[pname].Position;
						var params:Array = pos.split(",",2);
						room.x=params[0];
						room.y=params[1];
						
						_grid.addChild(room);
						_grid.setChildIndex(room,0);
						_room2DVec.push(room);
						_objects.push(room);
					}
					else if(myXML.Object[pname].ClassName=="Wall_2D")
					{
						var vec:Vector.<Number>=new Vector.<Number>;
						var vecStr:String=myXML.Object[pname].Data;
						var paramsVec:Array = vecStr.split(",");
						
						for(var i:int=0;i<paramsVec.length;i++)
							vec.push(paramsVec[i])
								
						var wall:Object2D_PartitionWall =new Object2D_PartitionWall("0",vec);
						
						var pos:String=myXML.Object[pname].Position;
						var params:Array = pos.split(",",2);
						wall.x=params[0];
						wall.y=params[1];

						_grid.addChild(wall);
						_wall2DVec.push(wall);
						_objects.push(wall);

					}
						
					else if(myXML.Object[pname].ClassName=="Object2D_Model")
					{
						var res:String=myXML.Object[pname].ResourcePath;
						var name:String=myXML.Object[pname].ModelName;
						var model:Object2D_Model=new Object2D_Model(res,name);
						
						model.name=name+pname;
						
						var pos:String=myXML.Object[pname].Position;
						var params:Array = pos.split(",",2);
						model.x=params[0];
						model.y=params[1];
				 
						 
						_grid.addChild(model);
						_modelsVec.push(model);
						_objects.push(model);
						
						current_object=model as Object;
					}
				}
				
			}
		}
		private function MouseDown(e:MouseEvent):void
		{
			SetAllNoSelected();
		}
		public function SetAllNoSelected():void
		{
			for(var i:int=0;i<_objects.length;i++)
			{
				if(_objects[i].visible==true)
					_objects[i].SetSelected(false);
				else _objects.splice(i,1);//删除
			}
		}
		
		
		public function ShowCenter():void
		{
			_grid.scaleX=0.5;
			_grid.scaleY=0.5;
			_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
			_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
		}
		
		public function GetBounds():void
		{
			_xMin=Number.MAX_VALUE;
			_yMin=Number.MAX_VALUE;
			_xMax=Number.MIN_VALUE;
			_yMax=Number.MIN_VALUE;
			
			for(var i:int=0;i<_room2DVec.length;i++)
			{
				for(var j:int=0;j<_room2DVec[i]._vertexVec1.length;j+=2)
				{
					var x1:Number=_room2DVec[i].x+_room2DVec[i]._vertexVec1[j];
					var y1:Number=_room2DVec[i].y-_room2DVec[i]._vertexVec1[j+1];
					
					if(_xMin>x1)
						_xMin=x1;
					if(_yMin>y1)
						_yMin=y1;			
					if(_xMax<x1)
						_xMax=x1;
					if(_yMax<y1)
						_yMax=y1;
				}	
			}
			
			/*
			_grid.graphics.clear();
			_grid.graphics.lineStyle(1,0xff0000);//白线
			_grid.graphics.beginFill(0xff00ff,0.8);
			_grid.graphics.moveTo(_xMin,_yMin);
			_grid.graphics.lineTo(_xMin,_yMax);
			_grid.graphics.lineTo(_xMax,_yMax);
			_grid.graphics.lineTo(_xMax,_yMin);
			_grid.graphics.endFill();*/
		}
		private function OnResize(e:ResizeEvent):void
		{
			if(_grid)
			{
				_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
				_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
			}
		}
		
		
		private function OnCreation_Complete(e:FlexEvent):void
		{
			_room2DVec=new Vector.<Object2D_Room>();
			_wall2DVec=new Vector.<Object2D_PartitionWall>();
			_modelsVec=new Vector.<Object2D_Model>();
			
			_grid=new Grid();
			_grid.scaleX=0.5;
			_grid.scaleY=0.5;
			
			_grid.x=-(_grid.width*_grid.scaleX)/2+this.unscaledWidth/2;
			_grid.y=-(_grid.height*_grid.scaleY)/2+this.unscaledHeight/2;
			
			addChild(_grid);

			_grid.addEventListener(DragEvent.DRAG_ENTER,DragEnter2D);
			_grid.addEventListener(DragEvent.DRAG_OVER,DragOver2D);
			_grid.addEventListener(DragEvent.DRAG_DROP,DragDrop2D);
		}

		
		
		//D&D
		private var room_number:int=0;
		private var current_object:Object;
		
		
		
		private function DragEnter2D(event:DragEvent):void
		{
			
			var className:String=String(event.dragSource.dataForFormat("className"));
			var classArgument:String=String(event.dragSource.dataForFormat("classArgument"));
			var resourcePath:String=String(event.dragSource.dataForFormat("resourcePath"));
			var objectName:String=String(event.dragSource.dataForFormat("objectName"));
			
			
			DragManager.acceptDragDrop(event.target as UIComponent);
		}
		private function DragOver2D(event:DragEvent):void
		{
		
		}
		private function DragDrop2D(event:DragEvent):void
		{
			var className:String=String(event.dragSource.dataForFormat("className"));
			var classArgument:String=String(event.dragSource.dataForFormat("classArgument"));
			var resourcePath:String=String(event.dragSource.dataForFormat("resourcePath"));
			var objectName:String=String(event.dragSource.dataForFormat("objectName"));
			
			current_object=null;

			if(className=="model")
			{
				var model:Object2D_Model=new Object2D_Model(resourcePath,objectName);
				model.x=event.localX;
				model.y=event.localY;
				model.name=model.className+room_number;
				room_number++;
				_grid.addChild(model);
				_modelsVec.push(model);
				_objects.push(model);
				
				current_object=model as Object;
			}
			
			
			else if(className=="Room_2D")
			{
				
				var room:Object2D_Room=new Object2D_Room(classArgument);
				trace("DragEnter2D");
				trace(room.width);
				trace(room.height);
				room.x=event.localX;
				room.y=event.localY;
				room.name=room.className+room_number;
				room_number++;
				_grid.addChild(room);
				_grid.setChildIndex(room,0);
				_room2DVec.push(room);
				_objects.push(room);
				
				current_object=room as Object;
			}
			else if(className=="Wall_2D")
			{
				var wall:Object2D_PartitionWall =new Object2D_PartitionWall(classArgument);
				wall.x=event.localX;
				wall.y=event.localY;
				wall.name=wall.className+room_number;
				room_number++;
				_grid.addChild(wall);
				_wall2DVec.push(wall);
				_objects.push(wall);
				
				current_object=wall as Object;
			}
			
			else if(className=="window")
			{
				var window:Room_2DWindows =new Room_2DWindows(new Point(-100,0),new Point(100,0));
				window.x=event.localX;
				window.y=event.localY;
				
				window.name=window.className+room_number;
				room_number++;
				_grid.addChild(window);
				_objects.push(window);
				
				current_object=window as Object;
			}
		}
	}
}