package zszh_WorkSpace3D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import mx.containers.Panel;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.math.MathConsts;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.PlaneGeometry;
	
	import away3d.core.pick.PickingColliderType;
	import away3d.utils.Cast;
	
	import zszh_WorkSpace2D.Room_2DFloor;
	import zszh_WorkSpace3D.WorkSpace3D;
	
	public class Room_3D extends ObjectContainer3D
	{
		//plane textures
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var WallDiffuse:Class;
		
		
		[Embed(source="/../embeds/floor_specular.jpg")]
		public static var FloorSpecular:Class;
		[Embed(source="/../embeds/floor_normal.jpg")]
		public static var FloorNormals:Class;
		[Embed(source="/../embeds/rooms/TextureFloor.jpg")]
		public static var FloorDiffuse:Class;
		
		public var _floorTex:String="zszh_res/basic/wall/TextureFloor.jpg";
		private var _floorTexLoader:Loader;
		private var _floorBitmap:Bitmap;
		
		
		
		//WorkSpace3D _lightPicker
		private var _lightPicker:StaticLightPicker;
		
		//material objects
		private var _wallMaterial:TextureMaterial;
		private var _floorMaterial:TextureMaterial;

		
		//vertexs data
		private var _pos1Vec:Vector.<Number>;
		private var _pos2Vec:Vector.<Number>;//inside
		private var _pos3Vec:Vector.<Number>;//outside
		
		private var _wallHeight:int;
		private var _wallWidth:int;
		
		public function Room_3D(_pos1:Vector.<Number>,_pos2:Vector.<Number>,_pos3:Vector.<Number>,floorTex:String,lightPicker:StaticLightPicker)
		{
			super();
			_pos1Vec=_pos1;
			_pos2Vec=_pos2;
			_pos3Vec=_pos3;
			
			_wallHeight=270;
			_wallWidth=20;
			_lightPicker=lightPicker;
		
			_floorTex=floorTex;
			_floorTexLoader = new Loader();
			_floorTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_floorTexLoader.load(new URLRequest(_floorTex));
			
			function onComplete(e:Event):void
			{
				_floorBitmap = Bitmap(_floorTexLoader.content);
				InitMaterials();
				BuiltRoom();
			}
			
			
		}
		
		
		public function BuiltRoom():void
		{
			
			BuiltRoomFloor(_pos2Vec,_floorMaterial);
			
			var whiteMaterial :ColorMaterial = new ColorMaterial(0xccd3d9, 1);
			whiteMaterial.lightPicker=this._lightPicker;
			BuiltRoomWall(_pos2Vec,whiteMaterial,_wallHeight);
			BuiltRoomWall(_pos3Vec,whiteMaterial,_wallHeight);
			
			var redMaterial :ColorMaterial = new ColorMaterial(0xeff3f6, 1);
			BuiltTopBottom(_pos2Vec,_pos3Vec,redMaterial);
			
			var greenMaterial :ColorMaterial = new ColorMaterial(0xeff3f6, 1);
			BuiltMid(_pos2Vec,_pos3Vec,greenMaterial);
		}
		
		//ok
		private function BuiltRoomWall(posVec:Vector.<Number>,material:MaterialBase,wallHeight:int,uvScale:int=100,floorZ:int=0):void
		{
			var posLen:int=posVec.length;
			
			for(var i:int=0;i<posLen;i+=2)
			{
				var gem:Geometry=new Geometry();
				var subGeom : SubGeometry = new SubGeometry;
				
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var uv : Vector.<Number> = new Vector.<Number>;
				
				//p0  pi pi+1 顺时针方向 三角形
				vertex.push(posVec[i],wallHeight, posVec[i+1],
					posVec[(i+2)%posLen],wallHeight, posVec[(i+3)%posLen],
					posVec[(i+2)%posLen],floorZ, posVec[(i+3)%posLen],
					posVec[i],floorZ, posVec[i+1]);
				
				index.push(0,1,2,0,2,3);
				
				//uv 还是有点问题
				var dx:Number= posVec[(i+2)%posLen]- posVec[i];
				var dy:Number= posVec[(i+3)%posLen]- posVec[i+1];				
				var p1:Number=Math.sqrt(dx*dx+dy*dy);
				
				
				uv.push(0, _wallHeight/uvScale,
					p1/uvScale, _wallHeight/uvScale,
					p1/uvScale, floorZ/uvScale,
					0, floorZ/uvScale);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				subGeom.updateUVData(uv);
				gem.addSubGeometry(subGeom);
				
				
				var wallPlane:Mesh=new Mesh(gem,material);
				addChild(wallPlane);
				
				wallPlane.mouseEnabled=true;
				wallPlane.pickingCollider=PickingColliderType.AS3_BEST_HIT;
				
				wallPlane.addEventListener(MouseEvent3D.MOUSE_DOWN,onObjectMouseDown);
				wallPlane.addEventListener(MouseEvent3D.MOUSE_OVER,onObjectMouseOver);
				wallPlane.addEventListener(MouseEvent3D.MOUSE_OUT,onObjectMouseOut);
			}
			
			
			
		}

		private function BuiltTopBottom(posVecIn:Vector.<Number>,posVecOut:Vector.<Number>,material:MaterialBase,floorZ:int=0):void
		{
		    //top and bottom
			var gemTop:Geometry=new Geometry();

			var len:int=posVecIn.length;
			for(var i:int=0;i<len;i+=2)
			{
				var subGeom : SubGeometry = new SubGeometry;
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
			
				vertex.push(posVecOut[i], _wallHeight, posVecOut[i+1]
					, posVecOut[(i+2)%len], _wallHeight, posVecOut[(i+3)%len]
					, posVecIn[(i+2)%len], _wallHeight, posVecIn[(i+3)%len]
					, posVecIn[i], _wallHeight,posVecIn[i+1]
					,posVecOut[i], floorZ, posVecOut[i+1]
					, posVecOut[(i+2)%len], floorZ, posVecOut[(i+3)%len]
					, posVecIn[(i+2)%len], floorZ, posVecIn[(i+3)%len]
					, posVecIn[i], floorZ,posVecIn[i+1]
					);
			
			
				index.push(0, 1, 2,0,2,3, 4,5,6, 4,6,7);
			
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);		
				gemTop.addSubGeometry(subGeom);
			}
			
			addChild(new Mesh(gemTop,material));
		}
		
		private function BuiltMid(posVecIn:Vector.<Number>,posVecOut:Vector.<Number>,material:MaterialBase,floorZ:int=0):void
		{
			
			var gemTop:Geometry=new Geometry();
			
			var len:int=posVecIn.length;
			for(var i:int=0;i<len;i+=2)
			{
				var subGeom : SubGeometry = new SubGeometry;
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				
				vertex.push(posVecOut[i], _wallHeight, posVecOut[i+1]
					, posVecIn[i], _wallHeight,posVecIn[i+1]
					, posVecIn[i], floorZ,posVecIn[i+1]
					, posVecOut[i], floorZ, posVecOut[i+1]);			
				
				index.push(0,3,2,0,2,1);
				index.push(0,1,2,0,2,3);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);		
				gemTop.addSubGeometry(subGeom);
			}
			
			addChild(new Mesh(gemTop,material));
		}
		
		// ok
		private function BuiltRoomFloor(posVec:Vector.<Number>,material:MaterialBase,uvScale:int=100,floorY:int=0):void
		{
			var gem:Geometry=new Geometry();
			
			//三角分解
			var vertexTmp : Vector.<Number> = new Vector.<Number>;
			var posLen:int=posVec.length;
			for(var i:int=0;i<posLen;i+=2)
			{
				vertexTmp.push(posVec[i],posVec[i+1]);
			}
			var iPos:int=0;
			while(vertexTmp.length>=6)
			{
				var len:int=vertexTmp.length;
				
				var p1:Point=new Point(vertexTmp[iPos%len],vertexTmp[(iPos+1)%len]);
				var p2:Point=new Point(vertexTmp[(iPos+2)%len],vertexTmp[(iPos+3)%len]);
				var p3:Point=new Point(vertexTmp[(iPos+4)%len],vertexTmp[(iPos+5)%len]);
				
				var p1p2:Point=new Point(p2.x-p1.x,p2.y-p1.y);
				var p2p3:Point=new Point(p3.x-p2.x,p3.y-p2.y);
				var p3p1:Point=new Point(p1.x-p3.x,p1.y-p3.y);
				
				var points:Vector.<Point>=new Vector.<Point>;
				points.push(p1p2);
				points.push(p2p3);
				points.push(p3p1);
				
				var test:Number = Room_2DFloor.GetPolygonArea(points);
				
				//test==0 it is mean that the points on the same line
				
				if(test>0||vertexTmp.length==6)
				{     
					var bCover:Boolean=false;//是否有其他 顶点在三角形中。。。
					/*for(var i:int=0;i<vectex.length;i+=2)
					{
					if(!b&&i<iPos||i>iPos+5)
					{
					b=PointinTriangle(p1,p2,p3,new Point(vectex[i],vectex[i+1]));
					}
					}*/
					
					
					if(!bCover)//凸点
					{
						
						
						var vertex : Vector.<Number> = new Vector.<Number>;
						var index : Vector.<uint> = new Vector.<uint>;
						var uv : Vector.<Number> = new Vector.<Number>;
						
						var tmpLen:int=vertexTmp.length;
						
						vertex.push(vertexTmp[iPos%tmpLen],floorY-1,vertexTmp[(iPos+1)%tmpLen],
							vertexTmp[(iPos+2)%tmpLen],floorY-1,vertexTmp[(iPos+3)%tmpLen],
							vertexTmp[(iPos+4)%tmpLen],floorY-1,vertexTmp[(iPos+5)%tmpLen]);//floorY-1 is necessary
						
						uv.push(vertexTmp[iPos%tmpLen]/uvScale,vertexTmp[(iPos+1)%tmpLen]/uvScale,
							vertexTmp[(iPos+2)%tmpLen]/uvScale,vertexTmp[(iPos+3)%tmpLen]/uvScale,
							vertexTmp[(iPos+4)%tmpLen]/uvScale,vertexTmp[(iPos+5)%tmpLen]/uvScale);
						
						
				 
						index.push(0,1,2);
						
						var subGeom : SubGeometry = new SubGeometry;
						subGeom.updateVertexData(vertex);
						subGeom.updateIndexData(index);
						subGeom.updateUVData(uv);
						gem.addSubGeometry(subGeom);
						
						vertexTmp.splice((iPos+2)%vertexTmp.length,2);
						continue;
					}
				}
				
				iPos+=2;
			}
		
			
			

			addChild(new Mesh(gem,material));	
		}
		
		private function InitMaterials():void
		{
			_wallMaterial = new TextureMaterial(Cast.bitmapTexture(WallDiffuse));
			_floorMaterial= new TextureMaterial(Cast.bitmapTexture(_floorBitmap));
			_floorMaterial.specularMap = Cast.bitmapTexture(FloorSpecular);
			//_floorMaterial.normalMap = Cast.bitmapTexture(FloorNormals);
			_floorMaterial.lightPicker = _lightPicker;
			_floorMaterial.repeat = true;
			//_floorMaterial.mipmap = false;
			
			_wallMaterial.lightPicker=_lightPicker;
			_wallMaterial.repeat=true;
		}
		
		
		//-------------mouse event----------------------------------
		private function onObjectMouseDown( event:MouseEvent3D ):void {
			var mesh:Mesh=event.target as Mesh;  
			mesh.bounds.boundingRenderable.color=0xff0000;
			mesh.showBounds=true;
		}
		
		private function onObjectMouseOver( event:MouseEvent3D ):void {
			var mesh:Mesh=event.target as Mesh;  
			mesh.bounds.boundingRenderable.color=0xff0000;
			mesh.showBounds=true;
			
			WorkSpace3D.SetCurrentWallMesh(mesh);
		}
		
		private function onObjectMouseOut( event:MouseEvent3D ):void {
			var mesh:Mesh=event.target as Mesh;  
			mesh.showBounds=false;
		}
		
		
	}
}