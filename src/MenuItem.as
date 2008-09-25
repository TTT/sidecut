package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import lt.uza.utils.*;
	import caurina.transitions.Tweener;
	
	public class MenuItem extends CircleArc {
		
		private var itemId:uint;
		private var trackUrl:String;
		private var trackName:String;
		private var isActive:Boolean	= false;
		private var isHovered:Boolean	= false;
		private var textDisplayer:TextDisplay;
		private var audio_player:AudioPlayer;
		//private var zoomAmount:Number 	= 1.3;
		//private var alphaAmount:Number	= .5;
		
		private var Debug:Global 		= Global.init();
		
		function MenuItem() {
			super();

			//Behave as a button
			buttonMode = true;
			useHandCursor = true;
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		//Event Handlers
		
		private function onMouseClick(event:MouseEvent):void {
			if (!isActive) {
				isActive = true;
				textDisplayer.changeText(trackName);
				audio_player.play(trackUrl);
			} else {
				isActive = false;
				
			}
		}
		
		
		//Properties
		public function get selected() : Boolean { 
			return isActive; 
		}

		public function set selected( value:Boolean ) : void {
			isActive = value;
		}
		
		public function get highlighted() : Boolean { 
			return isHovered; 
		}

		public function set highlighted( value:Boolean ) : void {
			isHovered = value;
		}
		
		public function get track() : String { 
			return trackUrl; 
		}

		public function set track( value:String ) : void {
			trackUrl = value;
		}
		
		public function get trackTitle() : String { 
			return trackName; 
		}

		public function set trackTitle( value:String ) : void {
			trackName = value;
		}
		
		public function get id() : uint { 
			return itemId; 
		}

		public function set id( value:uint ) : void {
			itemId = value;
		}
		
		public function get enabled() : Boolean { 
			return buttonMode; 
		}

		public function set enabled( value:Boolean ) : void {
			buttonMode = value;
			useHandCursor = value;
		}
		
		public function get displayer() : TextDisplay { 
			return textDisplayer; 
		}

		public function set displayer( value:TextDisplay ) : void {
			textDisplayer = value;
		}
		
		public function get player() : AudioPlayer { 
			return audio_player; 
		}

		public function set player( value:AudioPlayer ) : void {
			audio_player = value;
		}
		
	}
}