package zszh_away3d
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
	
	public class WS3D_Room extends ObjectContainer3D
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
		var _pos1Array:Array;//inside
		var _pos2Array:Array;//outside
		var _wallHeight:int;
		
		public function WS3D_Room(_pos1:Array)
		{
			super();
			if(!_pos1 || _pos1.length<3 )
				return;
			_pos1Array=_pos1;
			
			//compute the pos2 according pos1
			//Qi  ＝  Pi  ＋  （Vi － Vi+1）* d / sina
			
			_pos2Array=new Array();
			
			for(var i:int=0;i<_pos1Array.length;i++)
			{
				var pos1:Point=_pos1Array[i];
				var pos2:Point=_pos1Array[(i+1)%_pos1Array.length];
				var pos3:Point=_pos1Array[(i+2)%_pos1Array.length];
				
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
				p.x=pos2.x+(vec2.x-vec1.x)*20/sina;
				p.y=pos2.y+(vec2.y-vec1.y)*20/sina;
				
				trace("ClassRoom:ang="+ang);
				trace("ClassRoom:p="+p);
				
				_pos2Array[i]=p;
			}
			
			_wallHeight=270;
			
			//initMaterial
			_wallMaterial = new TextureMaterial(Cast.bitmapTexture(WallDiffuse));
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
			_floorMaterial.lightPicker=lightPicker;
		}
		
		
		public function BuiltRoom()
		{
			//draw wall inside
			if(_pos1Array.length>2 )
			{
				var tupmaterial :ColorMaterial = new ColorMaterial(0xffffff, 1);
				tupmaterial.lightPicker=lightPicker;
				
				BuiltRoomWall(_pos1Array,tupmaterial);
				BuiltRoomWall(_pos2Array,tupmaterial);
				BuiltRoomFloor(_pos1Array,_floorMaterial);
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
			}
			
			
			

		}
		
		//ok
		private function BuiltRoomWall(posArr:Array,material:ColorMaterial)
		{
			for(var i:int=0;i<posArr.length;i++)
			{
				var p0:Point=posArr[i];
				var p1:Point=posArr[(i+1)%posArr.length];
				
				var x:Number= p1.x-p0.x;
				var y:Number= p1.y-p0.y;
				var w:Number=Math.sqrt(x*x +y*y);
				
				var _plane:Mesh = new Mesh(new PlaneGeometry(w, _wallHeight,1,1,false,false), material);
				
				addChild(_plane);
				
				//position
				_plane.position=new Vector3D((p0.x+p1.x)/2,_wallHeight/2,(p0.y+p1.y)/2);
				
				
				//angle for rotation
				var vec1:Point=new Point(y,-x);//normal vector
				
				var vec2:Point=new Point(0,-1);
				
				var n:Number=vec1.x*vec2.x+vec1.y*vec2.y;
				var m:Number=Math.sqrt(vec1.x*vec1.x+vec1.y*vec1.y)*Math.sqrt(vec2.x*vec2.x+vec2.y*vec2.y);
				
				var ang:Number=Math.acos(n/m)*MathConsts.RADIANS_TO_DEGREES;
				
				
				var dc:Number=vec2.x*vec1.y-vec2.y*vec1.x;
				if(dc<=0)
					_plane.rotationY=ang;
				else _plane.rotationY=-ang;
				
				
				_plane.mouseEnabled=true;
				_plane.addEventListener(MouseEvent3D.MOUSE_DOWN,onObjectMouseDown);
			
			}
		}

		// ok
		private function BuiltRoomFloor(posArr:Array,material:MaterialBase,uvScale:int=100)
		{
			var gem:Geometry=new Geometry();
			for(var i:int=0;i<posArr.length-2;i++)
			{
				var subGeom : SubGeometry = new SubGeometry;
				
				var vertex : Vector.<Number> = new Vector.<Number>;
				var index : Vector.<uint> = new Vector.<uint>;
				var uv : Vector.<Number> = new Vector.<Number>;
				vertex.push(posArr[0].x,0, posArr[0].y,
					posArr[i+1].x,0, posArr[i+1].y,
					posArr[i+2].x,0, posArr[i+2].y);
				index.push(0, 1, 2);
				uv.push(posArr[0].x/uvScale, posArr[0].y/uvScale,
					posArr[i+1].x/uvScale, posArr[i+1].y/uvScale,
					posArr[i+2].x/uvScale, posArr[i+2].y/uvScale);
				
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