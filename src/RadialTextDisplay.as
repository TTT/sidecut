package {
	import flash.display.Sprite;
	import lt.uza.utils.*;
	
	import caurina.transitions.Tweener;
		
	public class RadialTextDisplay extends Sprite {

		private var textDisplayer:TextDisplay;

		private var circleRadius:Number			= 100;
		private var textAngle:Number			= 0;
		private var initDuration:Number 		= .2;
		private var removeDuration:Number		= .4;
		private var selectedDuration:Number 	= .3;
		private var textChangeDuration:Number 	= .1;
		
		private var activated:Boolean			= false;
		
		private static var Debug:Global = Global.init();

		public function RadialTextDisplay(radius:Number = 100) {
			super();
			
			circleRadius = radius;
			textDisplayer = new TextDisplay();
			textDisplayer.size 			= 12;
			textDisplayer.text 			= "";
			textDisplayer.objectAlign 	= "left-center";
			textDisplayer.textAlign 	= "left";	
			textDisplayer.wordWrap 		= false;	
			textDisplayer.alpha 		= 0;
			
			render();
		}
		
		private function render():void {
			if (!contains(textDisplayer)) {
				addChild(textDisplayer);
			}
			textDisplayer.width = textDisplayer.textWidth + 5;	
		}
		
		private function destroy():void {
			if (contains(textDisplayer)) {
				removeChild(textDisplayer);
			}
		}

		private function setPos(angle:Number, radius:Number):void {
			textDisplayer.x = Math.sin(Utils.to_radian(angle)) * (radius);
			textDisplayer.y = Math.cos(Utils.to_radian(angle)) * (radius * -1);		
			if (textAngle > 180) {
				textDisplayer.objectAlign = "right-center";
				textDisplayer.rotation = angle + 90;
			} else {
				textDisplayer.objectAlign 	= "left-center";
				textDisplayer.rotation = angle - 90;
			}
		}
		
		private function calculatePosition(angle:Number, radius:Number):Array {
			var tmpArray:Array = new Array();
				tmpArray.push(Math.sin(Utils.to_radian(angle)) * (radius));
				tmpArray.push(Math.cos(Utils.to_radian(angle)) * (radius * -1));
			return tmpArray;
		}
		
		
		public function animateIn():void {
			if (activated) {
				textDisplayer.alpha = 1;
				setPos(textAngle,circleRadius);
			} else {
				activated = true;
				textDisplayer.alpha = 0;
				textDisplayer.scaleX = .2;
				textDisplayer.scaleY = .2;
				setPos(textAngle,circleRadius);
				//Tweener.addTween(textDisplayer, {alpha:1, time:initDuration, transition:"easeInQuad"});
				Tweener.addTween(textDisplayer, {alpha:1, scaleX:1,scaleY:1, time:initDuration, transition:"easeInQuad"});
			}		
		}
		
		public function animateOut():void {
			activated = false;
			//var endPos:Array = calculatePosition(textAngle,circleRadius*1.5)
			//Tweener.addTween(textDisplayer, {alpha:0, x:endPos[0], y:endPos[1], time:removeDuration, transition:"easeOutQuad"});
			Tweener.addTween(textDisplayer, {alpha:0, scaleX:.2, scaleY:.2, time:removeDuration, transition:"easeOutQuad"});
		}
		
		
		public function get angle() : Number { 
			return textAngle; 
		}

		public function set angle( value:Number ) : void {
			textAngle = value;
			setPos(textAngle,circleRadius);
		}
		
		public function get text() : String { 
			return textDisplayer.text; 
		}

		public function set text( value:String ) : void {
			if (textDisplayer.text != value){
				textDisplayer.text = value;
				render();
			}
		}
		
		public function changeText(value:String): void {
			if (textDisplayer.text != value){
				textDisplayer.changeText(value,textChangeDuration);
				render();
			}
		}
		
		public function get radius() : Number { 
			return circleRadius; 
		}

		public function set radius( value:Number ) : void {
			circleRadius = value;
			setPos(textAngle,circleRadius)
		}
		
		public function get active() : Boolean { 
			return activated;
		}

		public function set active( value:Boolean ) : void {
			activated = value;
		}
		
	}
}