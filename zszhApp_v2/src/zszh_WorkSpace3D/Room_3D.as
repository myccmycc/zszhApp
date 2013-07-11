package zszh_WorkSpace3D
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
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
	import away3d.utils.Cast;
	
	public class Room_3D extends ObjectContainer3D
	{
		//plane textures
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var WallDiffuse:Class;
		[Embed(source="/../embeds/floor_specular.jpg")]
		public static var FloorSpecular:Class;
		[Embed(source="/../embeds/floor_normal.jpg")]
		public static var FloorNormals:Class;
		
		
			
		[Embed(source="/../embeds/TextureFloor.jpg")]
		public static var FloorDiffuse:Class;
		
		//material objects
		private var _wallMaterial:TextureMaterial;
		private var _floorMaterial:TextureMaterial;
		
		
		private var _pointLight:PointLight;
		private var directionalLight:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		
		//vertexs data
		private var _pos1Vec:Vector.<Number>;//inside
		private var _pos2Vec:Vector.<Number>;//outside
		
		var _wallHeight:int;
		
		public function Room_3D(_pos1:Vector.<Number>)
		{
			super();
			
			_pos1Vec=_pos1;
			
			//compute the pos2 according pos1
			//Qi  ＝  Pi  ＋  （Vi － Vi+1）* d / sina
			
			_pos2Vec=new Vector.<Number>;
			
			var pos1Len:int=_pos1Vec.length;
			for(var i:int=0;i<pos1Len;i+=2)
			{
				var pos1:Point=new Point(_pos1Vec[i],_pos1Vec[i+1]);
				var pos2:Point=new Point(_pos1Vec[(i+2)%pos1Len],_pos1Vec[(i+3)%pos1Len]);
				var pos3:Point=new Point(_pos1Vec[(i+4)%pos1Len],_pos1Vec[(i+5)%pos1Len]);
		
				//单位向量 vec1，vexc2
				var vec1:Point=new Point(pos2.x-pos1.x,pos2.y-pos1.y);
				var disVec1:Number=Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y);
				vec1.x=vec1.x/disVec1;
				vec1.y=vec1.y/disVec1;
				
				var vec2:Point=new Point(pos3.x-pos2.x,pos3.y-pos2.y);
				var disVec2:Number=Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				vec2.x=vec2.x/disVec2;
				vec2.y=vec2.y/disVec2;
				
				//求角度   AXB=|A|.|B|.SIN(ang);
				var AB:Number=Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y)*Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				var sina:Number=(vec1.x*vec2.y-vec1.y*vec2.x)/AB;
				
				//求_pos2Vec
				_pos2Vec[i]=pos2.x+(vec2.x-vec1.x)*20/sina;
				_pos2Vec[i+1]=pos2.y+(vec2.y-vec1.y)*20/sina;
				
				trace("_pos2Vec="+_pos2Vec[i] + _pos2Vec[i+1]);
			}
			
			_wallHeight=270;
			
			//initMaterial
			/*_wallMaterial = new TextureMaterial(Cast.bitmapTexture(WallDiffuse));
			_floorMaterial= new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			
			_pointLight=new PointLight();
			_pointLight.castsShadows=false;
			_pointLight.color=0xffffff;
			_pointLight.position=new Vector3D(0,270,0);
			_pointLight.radius=5000;
			addChild(_pointLight);
			
			directionalLight = new DirectionalLight(0, -1, 0);
			directionalLight.castsShadows = false;
			directionalLight.color = 0xffffff;
			directionalLight.diffuse = .7;
			directionalLight.ambient = .3;
			directionalLight.specular = 0;
			directionalLight.ambientColor = 0x808090;
			addChild(directionalLight);
			
			
			
			lightPicker = new StaticLightPicker([_pointLight,directionalLight]);
			
			_wallMaterial.lightPicker=lightPicker;
			_floorMaterial.lightPicker=lightPicker;*/
		}
		
		
		public function BuiltRoom()
		{
			//draw wall inside
			//if(_pos2Vec.length>2 )
			{
				var tupmaterial :ColorMaterial = new ColorMaterial(0xffffff, 1);
				
				BuiltRoomWall(_pos1Vec,tupmaterial,270);
				BuiltRoomWall(_pos2Vec,tupmaterial,270);
				BuiltRoomFloor(_pos1Vec,tupmaterial);
			}
			
			/*if(_pos2Array.length>2 )
			{
				var gem:Geometry=new Geometry();
				
				for(var i:int=0;i<_pos2Array.length;i++)
				{
				//top
				var subGeom : SubGeometry = new SubGeometry;
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var tupmaterial :ColorMaterial = new ColorMaterial(0xffff00, 1);
				
				vertex.push(_pos1Array[i].x, _wallHeight,  _pos1Array[i].y
					
					, _pos2Array[i].x, _wallHeight,_pos2Array[i].y
					
					,  _pos1Array[(i+1)%_pos1Array.length].x,_wallHeight, _pos1Array[(i+1)%_pos1Array.length].y);
				index.push(0, 1, 2);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				
				
				gem.addSubGeometry(subGeom);
			
				
				
				//top
				var subGeom : SubGeometry = new SubGeometry;
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var tupmaterial :ColorMaterial = new ColorMaterial(0xffffff, 1);
				
				vertex.push(_pos1Array[(i+1)%_pos1Array.length].x,_wallHeight, _pos1Array[(i+1)%_pos1Array.length].y,  _pos2Array[i].x, _wallHeight,_pos2Array[i].y,_pos2Array[(i+1)%_pos2Array.length].x,_wallHeight, _pos2Array[(i+1)%_pos2Array.length].y);
				index.push(0, 1, 2);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				
				gem.addSubGeometry(subGeom);
				

				}
				
				tupmaterial.lightPicker=lightPicker;
				var mesh :Mesh = new Mesh(gem,tupmaterial);
				
				addChild(mesh);
			}
			
			if(_pos2Array.length>2 )
			{
				var gem:Geometry=new Geometry();
				
				for(var i:int=0;i<_pos2Array.length;i++)
				{
					//top
					var subGeom : SubGeometry = new SubGeometry;
					var vertex : Vector.<Number> = new Vector.<Number>;
					var index : Vector.<uint> = new Vector.<uint>;
					var tupmaterial :ColorMaterial = new ColorMaterial(0xffff00, 1);
					
					vertex.push(_pos1Array[i].x, 0,  _pos1Array[i].y
						
						, _pos2Array[i].x, 0,_pos2Array[i].y
						
						,  _pos1Array[(i+1)%_pos1Array.length].x,0, _pos1Array[(i+1)%_pos1Array.length].y);
					index.push(0, 1, 2);
					
					subGeom.updateVertexData(vertex);
					subGeom.updateIndexData(index);
					
					
					gem.addSubGeometry(subGeom);
					
					
					
					//top
					var subGeom : SubGeometry = new SubGeometry;
					var vertex : Vector.<Number> = new Vector.<Number>;
					var index : Vector.<uint> = new Vector.<uint>;
					var tupmaterial :ColorMaterial = new ColorMaterial(0xffffff, 1);
					
					vertex.push(_pos1Array[(i+1)%_pos1Array.length].x,0, _pos1Array[(i+1)%_pos1Array.length].y,  _pos2Array[i].x, 0,_pos2Array[i].y,_pos2Array[(i+1)%_pos2Array.length].x,0, _pos2Array[(i+1)%_pos2Array.length].y);
					index.push(0, 1, 2);
					
					subGeom.updateVertexData(vertex);
					subGeom.updateIndexData(index);
					
					gem.addSubGeometry(subGeom);
					
					
				}
				
				tupmaterial.lightPicker=lightPicker;
				var mesh :Mesh = new Mesh(gem,tupmaterial);
				
				addChild(mesh);
			}*/
		}
		
		//ok
		private function BuiltRoomWall(posVec:Vector.<Number>,material:MaterialBase,wallHeight:int,uvScale:int=100,floorZ:int=0):void
		{
			var gem:Geometry=new Geometry();
			var posLen:int=posVec.length;
			
			for(var i:int=0;i<posLen;i+=2)
			{
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
				uv.push(posVec[i]/uvScale, posVec[i+1]/uvScale,
					posVec[(i+2)%posLen]/uvScale, posVec[(i+3)%posLen]/uvScale,
					posVec[(i+2)%posLen]/uvScale, posVec[(i+3)%posLen]/uvScale);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				subGeom.updateUVData(uv);
				gem.addSubGeometry(subGeom);
			}
			
			material.repeat=true;
			addChild(new Mesh(gem,material));	
			//_plane.mouseEnabled=true;
			//_plane.addEventListener(MouseEvent3D.MOUSE_DOWN,onObjectMouseDown);
			
		}

		// ok
		private function BuiltRoomFloor(posVec:Vector.<Number>,material:MaterialBase,uvScale:int=100,floorZ:int=0):void
		{
			var gem:Geometry=new Geometry();
			var posLen:int=posVec.length;
			
			for(var i:int=0;i<posLen-4;i+=2)
			{
				var subGeom : SubGeometry = new SubGeometry;
				
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var uv : Vector.<Number> = new Vector.<Number>;
				
				//p0  pi pi+1
				vertex.push(posVec[0],floorZ, posVec[1],
					posVec[i+2],floorZ, posVec[i+3],
					posVec[i+4],floorZ, posVec[i+5]);
				
				index.push(0, 1, 2);
				
				uv.push(posVec[0]/uvScale, posVec[1]/uvScale,
					posVec[i+2]/uvScale, posVec[i+3]/uvScale,
					posVec[i+4]/uvScale, posVec[i+5]/uvScale);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);
				subGeom.updateUVData(uv);
				gem.addSubGeometry(subGeom);
			}
			
			material.repeat=true;
			addChild(new Mesh(gem,material));	
		}
		
		private function onObjectMouseDown( event:MouseEvent3D ):void {
			event.target.showBounds=true;
		}
	}
}