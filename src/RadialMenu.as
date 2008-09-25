package {
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.*;
	
	import lt.uza.utils.*;
	import caurina.transitions.Tweener;
	//Example:

	[SWF(backgroundColor="0xffffff", width="800", height="680", frameRate="31")] 

	public class RadialMenu extends Sprite {
		
		private var menuNames:Array;
		private var menuColor:Array;
		private var menuSource:Array;
		private var menuHolder:Array;
		private var menuAngle:uint;
		
		private var Debug:Global 		= Global.init();
		
		private var isPlaying:Boolean 	= false;
		private var isStreaming:Boolean = false;
		
		private var menuRadius:uint 	= 100;
		private var menuWidth:uint		= 25;
		private var menuBgColor:uint	= 0;
		
		private var pbRadius:uint		= 150;
		private var pbWidth:uint		= 20;
		
		private var trackProgress:ProgressBar;
		private var nameDisplay:TextDisplay;
		private var trackDisplay:RadialTextDisplay;
		private var menuBg:CircleArc;
		private var scPlayer:AudioPlayer = new AudioPlayer();
		
		private var isActive:Boolean	= true;
		
		private var highlightSpeed:Number	= .5;
		
		function RadialMenu(){
			super();
			//Set up Debugging
			Debug.stage = this.stage;
			Debug.stage.scaleMode = StageScaleMode.NO_SCALE;
			Debug.stage.align = StageAlign.TOP_LEFT;
			Debug.console = new Console();
			
			//Position menu to center
			this.x = stage.stageWidth / 2;
			this.y = stage.stageHeight / 2;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			//Setup fake menu
			menuNames	= new Array('A.mp3',	'B.mp3',	'gamma force',	'delta charlie','delta charlie', 'b', 'a','b', 'a');
			menuColor	= new Array(0x2DFD00,	0xFFB500,		0xFF00BD,		0x0038FF, 		0x81DDE0, 0x81DDE0, 0x81DDE0, 0x81DDE0, 0x81DDE0);
			menuSource	= new Array('files/a.mp3',	'files/b.mp3',	'files/a.mp3',		'delta',	'	blah.mp3', 'fff');
		
			//Set up displays
			nameDisplay = new TextDisplay();
			nameDisplay.text 		= "side/cut";
			nameDisplay.wordWrap	= true;
			nameDisplay.multiline 	= true;
			nameDisplay.alpha		= .6;
		
			trackDisplay = new RadialTextDisplay(menuRadius + 30);
			
			//Create&Configure menuItems
			menuHolder	= new Array();
			menuAngle = (360 / menuNames.length);
			for (var i:int = 0; i<menuNames.length; i++){
				var tmpItem:MenuItem = new MenuItem();
				///tmpItem.angle 		= menuAngle;
				tmpItem.angle 		= 360 / menuNames.length + 2.2; // Add +2.2 to fill the gaps between elements.
				tmpItem.color 		= menuColor[i];
				tmpItem.radius 		= menuRadius;
				tmpItem.stroke 		= menuWidth + 10;
				tmpItem.track 		= menuSource[i];
				tmpItem.trackTitle	= menuNames[i];
				tmpItem.id 			= i;
				tmpItem.rotation	= (i*1) * menuAngle;
				tmpItem.alpha		= 0;
				tmpItem.displayer 	= nameDisplay;
				tmpItem.player		= scPlayer;
				menuHolder.push(tmpItem);	
			}	
			
			//Set up progressBar
			trackProgress = new ProgressBar();
			trackProgress.radius 		= pbRadius;
			trackProgress.stroke 		= pbWidth;
			trackProgress.enabled 		= false;
			trackProgress.forceProgress = true;
			trackProgress.alpha 		= 0;
			
			//Set up Background Circle
			menuBg = new CircleArc();
			menuBg.radius = menuRadius;
			menuBg.stroke = menuWidth;
			menuBg.color = menuBgColor;
			menuBg.angle = 363;
			
			render();
			
		}
		
		private function render ():void {
			addChild(menuBg);
			
			for (var i:int = 0; i<menuHolder.length; i++){			//Add menu items
				addChild(menuHolder[i]);
			}
			
			addChild(nameDisplay);
			addChild(trackProgress);
			addChild(trackDisplay);
		}
		
		private function highlightMenu(id:int,angle:int,mouseX:Number,mouseY:Number):void {
			//Highlight selected menu item.
			if (!menuHolder[id].highlighted) {
				menuHolder[id].highlighted = true;
				for (var i:int = 0; i<menuHolder.length; i++){
					if ( i != id) {											//Dehighlight every other menuitem
						Tweener.addTween(menuHolder[i], {alpha:0, time:highlightSpeed, transition:"easeOutQuad"});
						menuHolder[i].highlighted = false;
					} else {												//Set previoussly highlighted item back
						Tweener.addTween(menuHolder[i], {alpha:1, time:highlightSpeed, transition:"easeOutQuad"});
					}
				}
			}
			//Display and position menu name
			if (!trackDisplay.active) {
				trackDisplay.angle = angle;
				trackDisplay.changeText(menuNames[id]);
				trackDisplay.animateIn();
			} else {
				trackDisplay.angle = angle;
				trackDisplay.changeText(menuNames[id]);
			}
		}
		
		private function deHighlightMenu():void {
			for (var i:int = 0; i<menuHolder.length; i++){
				Tweener.addTween(menuHolder[i], {alpha:0, time:highlightSpeed, transition:"easeOutQuad"});
				menuHolder[i].highlighted = false;
				if (trackDisplay.active) {
					trackDisplay.animateOut();
				}
			}
		}
				
		private function showProgressBar():void {
			Tweener.addTween(trackProgress, {alpha:1, time:.3, transition:"easeOutQuad"});
			trackProgress.enabled 		= true;
		}	
		
		private function hideProgressBar() : void {
			Tweener.addTween(trackProgress, {alpha:0, time:.5, transition:"easeOutQuad"});
			trackProgress.enabled 		= false;
		}	
		
		
		private function onMouseMove(event:MouseEvent):void {
			var xMouse:Number	= stage.mouseX;
			var yMouse:Number	= stage.mouseY;
			var angle:Number 	= Utils.computeAngle(this.x,this.y,xMouse,yMouse);
			var dist:Number		= Utils.computeDistance(this.x,this.y,xMouse,yMouse);
			var menuItemID:int	= Math.floor(angle/menuAngle);
			
			if (dist <= menuRadius*1.2 ) {						//Mouse is close to menu, highlight menu item
				highlightMenu(menuItemID,angle,xMouse,yMouse);		
			} else if (dist > menuRadius*1.2) {					//Mouse is away from menu
				deHighlightMenu();
			} 
			
			if (dist <= pbRadius*1.2 && dist >= pbRadius*0.9) {
				showProgressBar();	
			} else {						
				hideProgressBar();	
			}
			
		}
	}
}