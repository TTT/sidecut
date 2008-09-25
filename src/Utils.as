package {
	
	import lt.uza.utils.*;
	
	public class Utils {
		
		// For Debugging purposes.
		private static var Debug:Global = Global.init();
		
		public function Utils ():void {
			
		}
		
		public static function to_radian(degree:Number):Number {
			return degree * Math.PI / 180;
		}
		
		public static function to_degree(radian:Number):Number {
			return radian * 180 / Math.PI;
		}
		
		public static function computeAngle(originX:Number,originY:Number,targetX:Number,targetY:Number):Number {
			var deltaX:Number = originX - targetX;
			var deltaY:Number = originY - targetY;
			var angle:Number = to_degree(Math.atan2(deltaX,deltaY));
			if (angle < 0) {
				angle *= -1 ;
			}  else {
				angle = 360 - angle;
			}
			
			return angle;
		}
		
		public static function computeDistance(originX:Number,originY:Number,targetX:Number,targetY:Number):Number {
			var dx:Number = targetX - originX; 
			var dy:Number = targetY - originY; 
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public static function computePercentage(a:Number,b:Number):uint{
			return Math.round((a/b)*100);
		}
	}
}