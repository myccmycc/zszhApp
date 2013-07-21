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
	
	public class WallInside_3D extends ObjectContainer3D
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
		
		public function WallInside_3D(_pos1:Vector.<Number>,lightPicker:StaticLightPicker)
		{
			super();
			_pos1Vec=_pos1;
			_pos2Vec=new Vector.<Number>;
			_pos3Vec=new Vector.<Number>;
			_wallHeight=270;
			_wallWidth=20;
			_lightPicker=lightPicker;
			
			InitVertexData();
			InitMaterials();
			BuiltRoom();
		}
		
		
		public function BuiltRoom():void
		{
			
			BuiltRoomFloor(_pos2Vec,_floorMaterial);
			BuiltRoomWall(_pos2Vec,_wallMaterial,270);
			var whiteMaterial :ColorMaterial = new ColorMaterial(0xffffff, 1);
			BuiltRoomWall(_pos3Vec,whiteMaterial,270);
			var redMaterial :ColorMaterial = new ColorMaterial(0xff0000, 1);
			BuiltTopBottom(_pos2Vec,_pos3Vec,redMaterial);
			var greenMaterial :ColorMaterial = new ColorMaterial(0x00ff00, 1);
			BuiltMid(_pos2Vec,_pos3Vec,greenMaterial);
			
			
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
				var p1:Number=Math.sqrt( posVec[i]*posVec[i]+posVec[i+1]*posVec[i+1])/uvScale;
				var p2:Number=Math.sqrt( posVec[(i+2)%posLen]*posVec[(i+2)%posLen]+posVec[(i+3)%posLen]*posVec[(i+3)%posLen])/uvScale;
				uv.push(p1, wallHeight/uvScale,
					-p2, wallHeight/uvScale,
					-p2, floorZ/uvScale,
					p1, floorZ/uvScale);
				
				trace("p1==",p1);
				trace("p2==",p2);
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

		private function BuiltTopBottom(posVecIn:Vector.<Number>,posVecOut:Vector.<Number>,material:MaterialBase):void
		{
		    //top
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
					, posVecIn[i], _wallHeight,posVecIn[i+1]);
			
			
				index.push(0, 1, 2,0,2,3);
			
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
				
				index.push(0, 1, 2,0,2,3,0,3,2,0,2,1);
				
				subGeom.updateVertexData(vertex);
				subGeom.updateIndexData(index);		
				gemTop.addSubGeometry(subGeom);
			}
			
			addChild(new Mesh(gemTop,material));
		}
		
		// ok
		private function BuiltRoomFloor(posVec:Vector.<Number>,material:MaterialBase,uvScale:int=100,floorZ:int=0):void
		{
			var gem:Geometry=new Geometry();
			
			
			var subGeom : SubGeometry = new SubGeometry;
			
			var vertex : Vector.<Number> = new Vector.<Number>;
			var index : Vector.<uint> = new Vector.<uint>;
			var uv : Vector.<Number> = new Vector.<Number>;
			
			var posLen:int=posVec.length;
			for(var i:int=0;i<posLen;i+=2)
			{
				vertex.push(posVec[i],floorZ,posVec[i+1]);
			}

			for(i=0;i<posLen;i++)
			{
				uv.push(posVec[i]/uvScale);
			}
			
			for(i=0;i<posLen/2-2;i++)
			{
				index.push(0,i+1,i+2);
			}
			
			subGeom.updateVertexData(vertex);
			subGeom.updateIndexData(index);
			subGeom.updateUVData(uv);
			gem.addSubGeometry(subGeom);
						
			material.repeat=true;
			addChild(new Mesh(gem,material));	
		}
		
		private function InitVertexData():void
		{
			var pos1Len:int=_pos1Vec.length;
			for(var i:int=0;i<pos1Len;i+=2)
			{
				var P1:Point=new Point(_pos1Vec[(i+pos1Len-2)%pos1Len], _pos1Vec[(i+pos1Len-1)%pos1Len]);
				var P2:Point=new Point(_pos1Vec[(i)%pos1Len],_pos1Vec[(i+1)%pos1Len]);
				var P3:Point=new Point(_pos1Vec[(i+2)%pos1Len],_pos1Vec[(i+3)%pos1Len]);
				
				//2 P1P2 直线方程  Ax+By+c=0的表达式
				var A1:Number=(P2.y-P1.y);
				var B1:Number=(P1.x-P2.x);
				var C1:Number = P2.x*P1.y-P1.x*P2.y;
				trace("ABC:"+A1+B1+C1);
				
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
				var aabb:Number=Math.sqrt(A1*A1+B1*B1);
				var dis:Number=10;
				var s:Number=dis*aabb;
				var C1_1:Number=C1+s;
				var C1_2:Number=C1-s;
				trace("C1_1:"+C1_1);
				trace("C1_2:"+C1_2);
				
							
				//2 P2P3 直线方程  Ax+By+c=0的表达式
				var A2:Number=(P3.y-P2.y);
				var B2:Number=(P2.x-P3.x);
				var C2:Number = P3.x*P2.y-P2.x*P3.y;
				trace("ABC:"+A2+B2+C2);
				
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
				
				var aabb:Number=Math.sqrt(A2*A2+B2*B2);
				var dis:Number=10;
				var s:Number=dis*aabb;
				var C2_1:Number=C2+s;
				var C2_2:Number=C2-s;
				trace("C2_1:"+C2_1);
				trace("C2_2:"+C2_2);
				
				//求P1P2平移线 和P2P3平移线 交点
				var p:Point=intersection(A1,B1,C1_1,A2,B2,C2_1);
				_pos3Vec[i]=p.x;
				_pos3Vec[i+1]=p.y;
				
				var p:Point=intersection(A1,B1,C1_2,A2,B2,C2_2);
				_pos2Vec[i]=p.x;
				_pos2Vec[i+1]=p.y;
			}
			
		}
		
		private static function intersection( A1:Number, B1:Number, C1:Number , A2:Number, B2:Number, C2:Number ):Point
		{
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
		private function InitMaterials():void
		{
			_wallMaterial = new TextureMaterial(Cast.bitmapTexture(WallDiffuse));
			_floorMaterial= new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			
			//_wallMaterial.lightPicker=_lightPicker;
			//_floorMaterial.lightPicker=_lightPicker;
		}
		private function onObjectMouseDown( event:MouseEvent3D ):void {
			event.target.showBounds=true;
		}
	}
}