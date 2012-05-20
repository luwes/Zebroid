package co.luwes.zebroid  {

	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	public class Zebroid {
		
		
		private static function makeOrthoProjection(w:Number, h:Number, n:Number, f:Number):Matrix3D {
			return new Matrix3D(Vector.<Number>([
				2/w, 0  ,       0,        0,
				0  , 2/h,       0,        0,
				0  , 0  , 1/(f-n), -n/(f-n),
				0  , 0  ,       0,        1
			]));
		}
		
		private var stage:Stage;
		private var context3D:Context3D;
		private var program:Program3D;
		
		private var segmentSets:Array = [];
		
		
		public function Zebroid(stage:Stage) {
			
			this.stage = stage;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
		}
		
		private function onContextCreated(e:Event):void {
		
			context3D = (e.target as Stage3D).context3D;
			
			if (context3D == null) {
				return;
			}
						
			context3D.enableErrorChecking = true;
			context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 4, true);
			context3D.setCulling(Context3DTriangleFace.BACK);
			
			var agalVertex:AGALMiniAssembler = new AGALMiniAssembler();
			var agalFragment:AGALMiniAssembler = new AGALMiniAssembler();

			var agalVertexSource:String =
				"m44 op, va0, vc0  \n" +        // 4x4 matrix transform to output clipspace
				"mov v0, va1       \n";         // pass color to fragment program 
			var agalFragmentSource:String =
				"mov oc, v0 \n";

			agalVertex.assemble(Context3DProgramType.VERTEX, agalVertexSource);
			agalFragment.assemble(Context3DProgramType.FRAGMENT, agalFragmentSource);
			
			program = context3D.createProgram();
			program.upload(agalVertex.agalcode, agalFragment.agalcode);
			context3D.setProgram(program);

			var mvp:Matrix3D = new Matrix3D();
			var viewMatrix:Matrix3D = new Matrix3D();
			viewMatrix.appendTranslation(-stage.stageWidth/2, -stage.stageHeight/2, 0);
			viewMatrix.appendScale(1, -1, 1);
			mvp.append(viewMatrix);
			mvp.append(makeOrthoProjection(stage.stageWidth, stage.stageHeight, 0, 100));
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mvp, true);
			
			context3D.setDepthTest(false, Context3DCompareMode.NOT_EQUAL);
			context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			stage.addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(e:Event):void {
		
			context3D.clear(0.8, 1, 1, 1);
			
			for (var i:int = 0; i < segmentSets.length; i++) {
			
				var segmentSet:* = segmentSets[i];
				
				var vertexbuffer:VertexBuffer3D = segmentSet.getVertexBuffer(context3D);
				context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_4);
				//context3D.setVertexBufferAt(2, vertexbuffer, 7, Context3DVertexBufferFormat.FLOAT_2);
				
				var indexbuffer:IndexBuffer3D = segmentSet.getIndexBuffer(context3D);
				context3D.drawTriangles(indexbuffer);
			}
			
			context3D.present();
		}
		
		public function addSet(segmentSet:SegmentSet):SegmentSet {
		
			segmentSets.push(segmentSet);
			return segmentSet;
		}
	}
}
