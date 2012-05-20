package co.luwes.zebroid  {
	
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	
	public class SegmentSet {
	

		/** The total number of elements (Numbers) stored per vertex. */
        public static const ELEMENTS_PER_VERTEX:int = 9;
        
        /** The offset of position data (x, y) within a vertex. */
        public static const POSITION_OFFSET:int = 0;
        
        /** The offset of color data (r, g, b, a) within a vertex. */ 
        public static const COLOR_OFFSET:int = 3;
        
        /** The offset of texture coordinate (u, v) within a vertex. */
        public static const TEXCOORD_OFFSET:int = 7;
		
		
		protected var _segments:Vector.<Segment>;
		private var _lineCount:uint;
		private var _indexCount:uint;
		
		internal var _vertices:Vector.<Number>;
		internal var _numVertices:uint;
		private var _vertexBufferDirty:Boolean;
		private var _vertexBuffer:VertexBuffer3D;
		
		internal var _indices:Vector.<uint>;
		internal var _numIndices:uint;
		private var _indexBufferDirty:Boolean;
		private var _indexBuffer:IndexBuffer3D;
		
		
		public function SegmentSet() {
			
			_segments = new Vector.<Segment>();
			_vertices = new Vector.<Number>();
			_numVertices = 0;
			_indices = new Vector.<uint>();
			_numIndices = 0;
			_lineCount = 0;
			_indexCount = 0;
		}
		
		public function addSegment(segment:Segment):void {
		
			segment.index = _vertices.length;
			segment.segmentsBase = this;
			_segments.push(segment);
			_lineCount += 1;
			
			updateSegment(segment);
			_indices.push(	_indexCount, _indexCount + 1, _indexCount + 2,
							_indexCount, _indexCount + 2, _indexCount + 3	);
			_indexCount += 4;	
			
			_numVertices = _vertices.length / ELEMENTS_PER_VERTEX;
			_numIndices = _indices.length;
			
			_vertexBufferDirty = true;
			_indexBufferDirty = true;
		}
		
		internal function updateSegment(segment:Segment):void {
		
			var start:Vector3D = segment._start;
			var end:Vector3D = segment._end;
			
			var delta:Vector3D = start.subtract(end);
			delta.normalize();
			
			var normal:Vector3D = new Vector3D(delta.y, -delta.x);
			
			var colorR:Number = segment._colorR;
			var colorG:Number = segment._colorG;
			var colorB:Number = segment._colorB;
			var alpha:Number = 1.0;
			
			var t:Number = segment.thickness;
			var index:uint = segment.index;
			
			_vertices[index++] = start.x + t * normal.x;
			_vertices[index++] = start.y + t * normal.y;
			_vertices[index++] = 0;
			_vertices[index++] = colorR;
			_vertices[index++] = colorG;
			_vertices[index++] = colorB;
			_vertices[index++] = alpha;
			_vertices[index++] = 0;
			_vertices[index++] = 0;

			_vertices[index++] = start.x - t * normal.x;
			_vertices[index++] = start.y - t * normal.y;
			_vertices[index++] = 0;
			_vertices[index++] = colorR;
			_vertices[index++] = colorG;
			_vertices[index++] = colorB;
			_vertices[index++] = alpha;
			_vertices[index++] = 0;
			_vertices[index++] = 0;

			_vertices[index++] = end.x - t * normal.x;
			_vertices[index++] = end.y - t * normal.y;
			_vertices[index++] = 0;
			_vertices[index++] = colorR;
			_vertices[index++] = colorG;
			_vertices[index++] = colorB;
			_vertices[index++] = alpha;
			_vertices[index++] = 0;
			_vertices[index++] = 0;

			_vertices[index++] = end.x + t * normal.x;
			_vertices[index++] = end.y + t * normal.y;
			_vertices[index++] = 0;
			_vertices[index++] = colorR;
			_vertices[index++] = colorG;
			_vertices[index++] = colorB;
			_vertices[index++] = alpha;
			_vertices[index++] = 0;
			_vertices[index++] = 0;

			_vertexBufferDirty = true;
		}
		
		public function getIndexBuffer(context3D:Context3D):IndexBuffer3D {
			if (_indexBufferDirty) {
				_indexBuffer = context3D.createIndexBuffer(_numIndices);
				_indexBuffer.uploadFromVector(_indices, 0, _numIndices);
				_indexBufferDirty = false;
			}
			return _indexBuffer;
		}

		public function getVertexBuffer(context3D:Context3D):VertexBuffer3D {
			if (_numVertices == 0) {
				addSegment(new Segment(new Vector3D(), new Vector3D())); // buffers cannot be empty
			}

			if (_vertexBufferDirty) {
				_vertexBuffer = context3D.createVertexBuffer(_numVertices, ELEMENTS_PER_VERTEX);
				_vertexBuffer.uploadFromVector(_vertices, 0, _numVertices);
				_vertexBufferDirty = false;
			}
			return _vertexBuffer;
		}
		
	}
}
