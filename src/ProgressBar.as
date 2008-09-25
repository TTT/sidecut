package {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.*;
	
	import lt.uza.utils.*;

	public class ProgressBar extends Sprite {
				
		private var circleStroke:uint		= 10;
		private var circleColor:uint		= 0x000;
		private var circleRadius:uint		= 150;
		private var bgAlpha:Number			= .15;
		private var forcePBar:Boolean		= true;
		private var mousePressed:Boolean	= false;
		
		private var bg_circle:Sprite;
		private var stream_circle:CircleArc;
		private var progress_circle:CircleArc;
		private var timeDisplayer:RadialTextDisplay;
		
		private var Debug:Global = Global.init();
		
		public function ProgressBar() {
			super();
			buttonMode = true;
			useHandCursor = true;
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			
			bg_circle = new Sprite();  
			progress_circle = new CircleArc();  
			stream_circle = new CircleArc();

			timeDisplayer = new RadialTextDisplay(circleRadius+25);
			timeDisplayer.animateIn();
			timeDisplayer.angle = progress_circle.angle;
			timeDisplayer.text 	= "";
			
			timeDisplayer.animateIn();
			
			render();
		}
					
		//TODO: Remove circles if they exist.
		private function render():void {
			
			bg_circle.graphics.clear();
			bg_circle.graphics.lineStyle(circleStroke, circleColor, bgAlpha);
			bg_circle.graphics.drawCircle(0, 0, circleRadius);        
		
			progress_circle.radius = circleRadius;
			progress_circle.color = circleColor;
			progress_circle.stroke = circleStroke;
			progress_circle.alpha = .3;
			progress_circle.angle = 3;	
			
			stream_circle.radius = circleRadius;
			stream_circle.color = circleColor;
			stream_circle.stroke = circleStroke;
			stream_circle.alpha = .3;
			stream_circle.angle = 270;
			
			addChild(bg_circle);
			addChild(stream_circle);
			addChild(progress_circle);
			addChild(timeDisplayer);
			
			set_progress(0);
		
		}
		
		private function update():void {
			bg_circle.graphics.clear();
			bg_circle.graphics.lineStyle(circleStroke, circleColor, bgAlpha);
			bg_circle.graphics.drawCircle(0, 0, circleRadius);
			
			progress_circle.radius = circleRadius;
			progress_circle.color = circleColor;
			progress_circle.stroke = circleStroke;
			
			stream_circle.radius = circleRadius;
			stream_circle.color = circleColor;
			stream_circle.stroke = circleStroke;
		}
		
		private function getDegreeFromPercentage(value:Number):Number {
			return (value/100)*360;
		}
		
		private function onMouseMove(event:MouseEvent):void {
			var new_angle:Number = Utils.computeAngle(this.x,this.y,this.mouseX,this.mouseY);
			// Set progressbar while dragging
			if (mousePressed) {
				set_progress(new_angle);
			} else {
				//Set scantext according to mouse
			}
		}

	
		private function onMouseClick(event:MouseEvent):void {
			set_progress(Utils.computeAngle(this.x,this.y,this.mouseX,this.mouseY))
		}
		
		private function onMouseDown(event:MouseEvent):void {
			mousePressed = true;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			mousePressed = false;
		}
		
		private function set_progress(value:Number):void {
			if (stream_circle.angle >= value && forcePBar) {
				progress_circle.angle = value;
				timeDisplayer.angle = value;
			} else if (stream_circle.angle <= value && forcePBar) {
				progress_circle.angle = stream_circle.angle;
				timeDisplayer.angle = stream_circle.angle;
			} else {
				progress_circle.angle = value;
				timeDisplayer.angle = value;
			}
			timeDisplayer.text = this.progressPercent.toString() + "%";
		}
		
		private function set_stream(value:Number):void {
			stream_circle.angle = value;
		}
				
		public function get streamPercent() : uint { 
			return Utils.computePercentage(stream_circle.angle,360); 
		}

		public function set streamPercent( value:uint ) : void {
			set_stream(getDegreeFromPercentage(value));
		}
		
		public function get progressPercent() : Number { 
			return Utils.computePercentage(progress_circle.angle,360);
		}
		
		public function set progressPercent( value:Number ) : void {
			set_progress(getDegreeFromPercentage(value));
		}
		
		public function get streamAngle() : Number { 
			return stream_circle.angle; 
		}

		public function set streamAngle( value:Number ) : void {
			set_stream(value);
		}
		
		public function get progressAngle() : Number { 
			return progress_circle.angle; 
		}

		public function set progressAngle( value:Number ) : void {
			set_progress(value);
		}
		
		public function get stroke() : uint { 
			return circleStroke; 
		}

		public function set stroke( value:uint ) : void {
			circleStroke = value;
			update();
		}
		
		public function get color() : uint { 
			return circleColor; 
		}

		public function set color( value:uint ) : void {
			circleColor = value;
			update();
		}
		
		public function get radius() : uint { 
			return circleRadius; 
		}

		public function set radius( value:uint ) : void {
			circleRadius = value;
			update();
		}
		
		public function get forceProgress() : Boolean { 
			return forcePBar; 
		}

		public function set forceProgress( value:Boolean ) : void {
			forcePBar = value;
		}
		
		public function get enabled() : Boolean { 
			return buttonMode; 
		}

		public function set enabled( value:Boolean ) : void {
			buttonMode = value;
			useHandCursor = value;
		}
		
		public function get scale() : Number { 
			return scaleX; 
		}

		public function set scale( value:Number ) : void {
			scaleX = value;
			scaleY = value;
		}
		
		public function get text() : String { 
			return timeDisplayer.text; 
		}

		public function set text( value:String ) : void {
			timeDisplayer.text = value;
		}
		
		
	}
}