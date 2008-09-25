package {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import lt.uza.utils.*;
	
	import caurina.transitions.Tweener;
		
	public class TextDisplay extends Sprite {
		
		private var stringDisplay:TextField;
		private var stringDisplay2:TextField;
		private var stringTextFormat:TextFormat;
		private var _objectAlign:String			= "center";
		private var animatingText:Boolean 		= false;
		
		private var Debug:Global 				= Global.init();
		
		[Embed(source='/assets/UniversLTStd-Light.otf', fontName="Univers", mimeType="application/x-font")]
		private static const UNIVERS_LIGHT:String;

		function TextDisplay() {
			
			super();
			cacheAsBitmap 	= true;
			
			stringDisplay = new TextField();
			stringDisplay.wordWrap 			= true;
			stringDisplay.multiline 		= true;
			stringDisplay.autoSize 			= "center";
			stringDisplay.embedFonts 		= true;					
			stringDisplay.mouseWheelEnabled = false;
			stringDisplay.selectable 		= false;
			stringDisplay.border			= false;
			stringDisplay.alpha				= 1;
			stringDisplay.width 			= 100;
			
			stringDisplay2 = new TextField();					//Second textfield, for change animation. Identical to he first one
			stringDisplay2.wordWrap 			= true;
			stringDisplay2.multiline 			= true;
			stringDisplay2.autoSize 			= "center";
			stringDisplay2.embedFonts 			= true;					
			stringDisplay2.mouseWheelEnabled	= false;
			stringDisplay2.selectable 			= false;
			stringDisplay2.border				= false;
			stringDisplay2.alpha				= 0;
			stringDisplay2.width 				= 100;
			
			stringTextFormat = new TextFormat();
			stringTextFormat.align 			= "center";
			stringTextFormat.bold 			= false;
			stringTextFormat.font			= "Univers";
			stringTextFormat.kerning		= true;
			stringTextFormat.letterSpacing 	= -.35;
			stringTextFormat.color			= 0x000;
			stringTextFormat.size			= 24;
			
			stringDisplay.defaultTextFormat = stringTextFormat;
			stringDisplay2.defaultTextFormat = stringTextFormat;
		
			render();
			
		}
		
		private function render():void {
			stringDisplay.setTextFormat(stringTextFormat);
			stringDisplay2.setTextFormat(stringTextFormat);			//Update textformats
			
			if (!contains(stringDisplay)) { addChild(stringDisplay); }
			if (!contains(stringDisplay2)) { addChild(stringDisplay2); }
			
			switch (_objectAlign){
				case "center" :										//Align to Center
					stringDisplay.x = 0 - stringDisplay.width/2;
					stringDisplay.y = 0 - stringDisplay.height/2;
					
					stringDisplay2.x = 0 - stringDisplay2.width/2;
					stringDisplay2.y = 0 - stringDisplay2.height/2;
					break;
				case "left" :										//Align to Left
					stringDisplay.x = 0
					stringDisplay.y = 0
					
					stringDisplay2.x = 0
					stringDisplay2.y = 0
					break;
				case "left-center" :
					stringDisplay.x = 0
					stringDisplay.y = 0 - stringDisplay.height/2;
					
					stringDisplay2.x = 0
					stringDisplay2.y = 0 - stringDisplay2.height/2;
					break;
				case "right-center" :
					stringDisplay.x = 0 - stringDisplay.width;
					stringDisplay.y = 0 - stringDisplay.height/2;
					
					stringDisplay2.x = 0 - stringDisplay2.width;
					stringDisplay2.y = 0 - stringDisplay2.height/2;
					break;
			}								
		}
		
		
		
		//PUBLIC FUNCTIONS
		
		/*
			TODO Add the possibility to slide text as well along to fading.
		*/
		public function changeText(newText:String, duration:Number = .3) : void { 		//Change text via animation. using 2 textfields for smoother, faster results
			if (!animatingText) {														//Only start new animation if none is in progress
				if (stringDisplay2.alpha == 0) {
					stringDisplay2.text = newText;	
					render();
					animatingText = true;
					Tweener.addTween(stringDisplay, {alpha:0, time:duration, transition:"easeInQuad"});
					Tweener.addTween(stringDisplay2, {alpha:1, time:duration, transition:"easeInQuad", onComplete: function():void { animatingText = false; }});
				} else {
					stringDisplay.text = newText;	
					render();
					animatingText = true;				
					Tweener.addTween(stringDisplay, {alpha:1, time:duration, transition:"easeInQuad"});
					Tweener.addTween(stringDisplay2, {alpha:0, time:duration, transition:"easeInQuad", onComplete: function():void { animatingText = false; }});
				}
			}
		}
		
		
		
		

				
		//PROPERTIES
	
		public function get textAlign() : String { 
			return stringTextFormat.align; 
		}

		public function set textAlign( value:String ) : void {
			if (stringTextFormat.align != value) {
				stringTextFormat.align = value;
				render();
			}
		}
		
		public function get objectAlign() : String { 
			return _objectAlign; 
		}

		public function set objectAlign( value:String ) : void {
			if (_objectAlign != value) {
				_objectAlign = value;
				render();
			}
		}
		
		public function get text() : String { 
			return stringDisplay.text; 
		}

		public function set text( value:String ) : void {
			if (stringDisplay.text != value) {
				stringDisplay.text = value; 
				render();	
			}
		}
		
		public function get color() : Object { 
			return stringTextFormat.color; 
		}

		public function set color( value:Object ) : void {
			stringTextFormat.color = value;
		}
		
		public function get wordWrap() : Boolean { 
			return stringDisplay.wordWrap; 
		}

		public function set wordWrap( value:Boolean ) : void {
			stringDisplay.wordWrap = value;
			stringDisplay2.wordWrap = value;
		}
		
		public function get multiline() : Boolean { 
			return stringDisplay.multiline; 
		}

		public function set multiline( value:Boolean ) : void {
			stringDisplay.multiline = value;
			stringDisplay2.multiline = value;
		}
		
		public function get italic() : Boolean { 
			return stringTextFormat.italic; 
		}

		public function set italic( value:Boolean ) : void {
			stringTextFormat.italic = value;
		}
		
		public function get bold() : Boolean { 
			return stringTextFormat.bold; 
		}

		public function set bold( value:Boolean ) : void {
			stringTextFormat.bold = value;
		}
		
		public function get size() : Object { 
			return stringTextFormat.size; 
		}

		public function set size( value:Object ) : void {
			stringTextFormat.size = value;
		}
		
		public function get spacing() : Object { 
			return stringTextFormat.letterSpacing; 
		}

		public function set spacing( value:Object ) : void {
			stringTextFormat.letterSpacing = value;
		}
		
		public function get textformat() : TextFormat { 
			return stringTextFormat; 
		}

		public function set textformat( value:TextFormat ) : void {
			stringTextFormat = value;
		}
		
		override public function get width() : Number { 
			return stringDisplay.width; 
		}

		override public function set width( value:Number ) : void {
			stringDisplay.width = value;
			stringDisplay2.width = value;
			render();
		}
		
		override public function get height() : Number { 
			return stringDisplay.height; 
		}

		override public function set height( value:Number ) : void {
			stringDisplay.height = value;
			stringDisplay2.height = value;
			render();
		}
		
		public function get textWidth() : Number { 
			return stringDisplay.textWidth; 
		}
				
		public function get textHeight() : Number { 
			return stringDisplay.textHeight; 
		}
		
	}
}