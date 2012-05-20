package co.luwes.zebroid  {

	import flash.geom.Vector3D;
	
	public class Segment {
	
	
		internal var _segmentsBase:SegmentSet;
		internal var _start:Vector3D;
		internal var _end:Vector3D;
		internal var _thickness:Number;
		private var _color:uint;
		internal var _colorR:Number;
		internal var _colorG:Number;
		internal var _colorB:Number;
		private var _index:uint;
		

		public function Segment(_start:Vector3D, _end:Vector3D, _thickness:Number=4, _color:uint=0x000000):void {
			
			this._start = _start;
			this._end = _end;
			this._thickness = _thickness * 0.5;
			this._color = _color;
			update();
		}

		public function updateSegment(_start:Vector3D, _end:Vector3D, _thickness:Number=4, _color:uint=0x000000):void {
		
			this._start = _start;
			this._end = _end;
			this._thickness = _thickness * 0.5;
			this._color = _color;
			update();
		}

        public function get start():Vector3D {
            return _start;
        }
        public function set start(value:Vector3D):void {
			_start = value;
			update();
        }
		
        public function get end():Vector3D {
            return _end;
        }
        public function set end(value:Vector3D):void {
         	_end = value;
			update();
        }
		

        public function get thickness():Number {
            return _thickness;
        }
        public function set thickness(value:Number):void {
         	_thickness = value * 0.5;
			update();
        }

        public function get color():uint {
            return  _color;
        }
        public function set color(value:uint):void {
         	_colorR = ((value >> 16) & 0xff) / 255;
			_colorG = ((value >> 8) & 0xff) / 255;
			_colorB = (value & 0xff) / 255;
			update();
        }
		
		internal function get index():uint {
			return _index;
		}
		internal function set index(ind:uint):void {
			_index = ind;
		}
		
		internal function set segmentsBase(segBase:SegmentSet):void {
			_segmentsBase = segBase;
		}
		
		private function update():void {
			if (!_segmentsBase) return;
			_segmentsBase.updateSegment(this);
		}
	}
}
