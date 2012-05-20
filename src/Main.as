package  {

	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import co.luwes.zebroid.*;
	
	[SWF(width="900", height="506", frameRate="30")]
	public class Main extends Sprite {
		
		
		public function Main() {
		
			var zebroid:Zebroid = new Zebroid(stage);
				
			var set0:SegmentSet = zebroid.addSet(new SegmentSet());
			set0.addSegment(new Segment(new Vector3D(10, 10), new Vector3D(200, 130)));
			set0.addSegment(new Segment(new Vector3D(200, 130), new Vector3D(400, 130)));
			set0.addSegment(new Segment(new Vector3D(400, 130), new Vector3D(400, 430)));
		}
	}
}
