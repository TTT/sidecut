package {
	import flash.display.Sprite;
	import lt.uza.utils.*;
	
	public class CircleArc extends Sprite {
		private var cAngle_start:Number	= Utils.to_radian(180);
		private var cAngle_end:Number	= Utils.to_radian(300);
		private var cAngle:Number		= 0;
		private var cStroke:uint		= 15;
		private var cColor:uint 		= 0x000;
		private var cRadius:uint 		= 100;
		private var cDetail:Number		= .05;
		private var xpos:Number			= 0;
		private var ypos:Number			= 0;
		
		// For Debugging purposes.
		private static var Debug:Global = Global.init();

		public function CircleArc() {
			super();
			drawCircle();
		}

		private function drawCircle():void{
			graphics.clear();
			graphics.lineStyle(cStroke, cColor, 1, false, "normal", "none", "BEVEL");
			
			cAngle = cAngle_start;
			while (cAngle > cAngle_end) {
				xpos = Math.sin(cAngle)*cRadius;
				ypos = Math.cos(cAngle)*cRadius;
				if (cAngle == cAngle_start) {
					graphics.moveTo(xpos, ypos);
				} else {
					graphics.lineTo(xpos, ypos);
				}
				cAngle -= cDetail;
			}
		}
		

		//Properties
		
		public function get color():uint {
			return cColor;
		} 
		
		public function set color(value:uint):void {
			cColor = value;
			drawCircle();
		}
		
		public function get stroke():uint {
			return cStroke;
		} 
		
		public function set stroke(value:uint):void {
			cStroke = value;
			drawCircle();
		}
		
		public function get radius():uint {
			return cRadius;
		} 
		
		public function set radius(value:uint):void {
			cRadius = value;
			drawCircle();
		}
		
		public function get angle() : Number { 
			return 180-Utils.to_degree(cAngle_end); 
		}

		public function set angle( value:Number ) : void {
			cAngle_start = Utils.to_radian(180);
			cAngle_end = Utils.to_radian(180-value);
			drawCircle();
		}
		
		
		//Public functions
		
		public function setAngles(min:uint, max:uint):void {
			cAngle_start = Utils.to_radian(180-min);
			cAngle_end = Utils.to_radian(180-max);
			drawCircle();
		}
	
	}
}