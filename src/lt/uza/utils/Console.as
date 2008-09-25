package lt.uza.utils
{
	
	/**
	 * Console Class for runtime debugging
	 *  
	 * @version 1.1
	 * @author Paulius Uza
	 * 
	 * More information: http://www.uza.lt
	 * 
	 */
	
	// Flash imports
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.*;
	
	// Reference to location of Global class
	import lt.uza.utils.*;
	
	public class Console extends Sprite
	{
		private var $:Global = Global.init();
		
		private var background:Sprite = new Sprite();
		private var msk:Sprite = new Sprite();
		private var masked:Sprite = new Sprite();
		
		private var console:TextField = new TextField();
		private var input:TextField = new TextField();
		private var numbering:TextField = new TextField();
		
		private var f1:TextFormat = new TextFormat();
		private var f2:TextFormat = new TextFormat();
		private var f3:TextFormat = new TextFormat();
		private var f_trace:TextFormat = new TextFormat();
		
		private var functions:HashMap = new HashMap();
		
		private var history:ArrayedQueue = new ArrayedQueue(2);
		private var historyID:int = 0;
		private var linecount:int = 0;
		private var enabled:Boolean;
		
		// ******* BEGIN public functions
		
		/**
		 * Constructor. Creates New Console
		 */
		
		public function Console() {

			var s:Stage = $.stage as Stage;
			s.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			s.addEventListener(Event.RESIZE,onResize);
			s.addChild(this);
			
			$.trace = trace;
			disable();
			
			this.addChild(background);
			this.addChild(input);
			this.addChild(masked);
			masked.addChild(console);
			masked.addChild(numbering);
			
            setUpTextfields();
			redraw();
			
			this.trace('Type "-help" for a list of available commands');
		}
		
		/**
		 * Registers new function / command pair for use in the console.
		 */
		
		public function register(func:Function, command:String):void {
			functions.put(command,func);
		}
		
		/**
		 * Unregisters a function from console.
		 * key can be either function or the command string
		 */
		
		public function unregister(key:*):void {
			if(getQualifiedSuperclassName(key) == "Function") {
				functions.remove(functions.getKey(key));
			} else {
				functions.remove(key);
			}
		}
		
		/**
		 * Shows the console.
		 */
		
		public function enable():void {
			this.visible = true;
			enabled = true;
		}
		
		/**
		 * Hides the console.
		 */
		
		public function disable():void {
			this.visible = false;
			enabled = false;
		}
		
				
		/**
		 * Writes the result from Object.toString() into the console.
		 * Similar to built-in trace() function.
		 */
		
		public function trace(obj:*):void {
			linecount++;
			numbering.appendText(linecount + "\n");
			var str:String = "] " + obj.toString() + "\n";
			var s_index:int = console.length;
			var e_index:int = s_index + str.length;
			console.appendText(str);
			console.setTextFormat(f_trace,s_index,e_index);
			update();
		}
		
		// ******* END public functions 
		// ******* BEGIN listeners 
		
		/**
		 * Forces console to redraw everytime the stage is resized.
		 */
		
		private function onResize(e:Event):void {
			redraw();
		}
		
		/**
		 * Listens for keyboard input.
		 */
		
		private function onKeyDown(e:KeyboardEvent):void {
			var funct:String = "";
			if(e.charCode != 0) {
				if(e.ctrlKey)  { funct += "CTRL + ";}
				if(e.altKey)   { funct += "ALT + ";}
				if(e.shiftKey) { funct += "SHIFT + ";}
				funct += e.charCode.toString();
			}
			
			switch (funct) {
				case "CTRL + SHIFT + 126":
					// power tidle
					if(enabled) {disable()} else {enable()}
				break;
				case "96":
					// tidle
					if(enabled) {disable()} else {enable()}
				break;
				case "13":
					// return
					if(enabled) { exec(); }
				break;
				case "8":
					// backspace
					if(enabled && input.text.length > 2) { input.text = input.text.substr(0,input.text.length-1); }
				break;
				case "27":
					// escape
					if(enabled) { disable(); }
				break;
				default:
					if(enabled) {
						if(e.keyCode == 33) {scrollUp();} else if (e.keyCode == 34) {scrollDown();}
						if(e.keyCode == 38) {historyUp();} else if (e.keyCode == 40) {historyDown();}
						input.appendText(String.fromCharCode(e.charCode));
					}
				break;
			}
		}
		
		// ******* END listeners 
		// ******* BEGIN private functions
		
		/**
		 * Sets up TextField and TextFormat instances.
		 */
		
		private function setUpTextfields():void {
			f1.font = "_sans";
            f1.color = 0xfCC000;
			f1.bold = true;
            f1.size = 11;
			
			input.type = "dynamic";
			input.multiline = false;
			input.defaultTextFormat = f1;
			input.text = "] ";
			
			f2.font = "_sans";
            f2.color = 0x80c4fc;
			f2.bold = false;
            f2.size = 11;
			
			console.type = "dynamic";
			console.multiline = true;
			console.autoSize = TextFieldAutoSize.LEFT;
			console.defaultTextFormat = f2;
			console.setTextFormat(f2);
			
			f3.font = "_sans";
			f3.color = 0x555555;
			f3.size = 11;
			f3.bold = false;
			f3.align = "right";
			
			numbering.type = "dynamic";
			numbering.selectable = false;
			numbering.multiline = true;
			numbering.autoSize = TextFieldAutoSize.RIGHT;
			numbering.defaultTextFormat = f3;
			numbering.x = 36;
			
			f_trace.font = "_sans";
			f_trace.color = 0xCCCCCC;
			f_trace.size = 11;
			f_trace.bold = false;
		}
		
		/**
		 * Adds an expression to console's history.
		 */
		
		private function historyAdd(s:String):void {
			if(history.size == history.maxSize-1) {
				history.dequeue();
				history.dispose();
				history.enqueue(s);
			} else {
				history.enqueue(s);
			}
		}
		
		/**
		 * Displays next expression in the history.
		 */
		
		private function historyUp():void {
			if (historyID < history.size-1) {
				historyID++;
				input.text = history.getAt(history.size - 1 - historyID);
			}
		}
		
		/**
		 * Displays previous expression in the history.
		 */
		
		private function historyDown():void {
			if(historyID > 0) {
				historyID--;
				input.text = history.getAt(history.size - 1 - historyID);
			}
		}
		
		/**
		 * Scrolls console up.
		 */
		
		private function scrollUp():void {
			if(console.y + 56 <= background.height) {
				console.y += 56;
				numbering.y += 56;
			}
		}
		
		/**
		 * Scrolls console down.
		 */
		
		private function scrollDown():void {
			if(console.y + console.height > background.height){
				console.y -= 56;
				numbering.y -= 56;
			}
		}
		
		/**
		 * Writes the current text from the text input field into the console.
		 */
		
		private function write():void {
			linecount++;
			numbering.appendText(linecount + "\n");
			var str:String = input.text + "\n";
			var s_index:int = console.length;
			var e_index:int = s_index + str.length;
			console.appendText(str);
			console.setTextFormat(f2,s_index,e_index);
		}
		
		/**
		 * Executes the expression in the console.
		 */
		
		private function exec():void {
			var qry:Array = input.text.substr(2,input.text.length).split(" ");
			var key:String = qry[0];
			var paramA:String = qry[1];
			var paramB:String = qry[2];
			var paramC:String = qry[3];
			
			switch(key) {
				case "-c":
				case "-clear":
					console.text = "";
					numbering.text = "";
					linecount = 0;
					this.trace('Type "-help" for a list of available commands');
				break;
				case "-h":
				case "-help":
					write();
					this.trace('');
					this.trace('    Available Commands ');
					this.trace('------------------------------------------------------------------------------------------------------------------------');
					this.trace('    -help (or -h)                   displays this information');
					this.trace('    -clear (or -c)                  clears the list');
					this.trace('    -global                         returns a list of items in global storage');
					this.trace('    -get [key]                      returns a value of a global key');
					this.trace('    -set [key] [value] [type]       sets a value for a global key');
					this.trace('    -delete [key]                   deletes a key');
					this.trace('    -hello                          copyright notice');
					this.trace('    -sys                            gets system information');
					this.trace('');
					this.trace('    You can also access *registered* functions by typing in the associated command (without "-" sign)');
					this.trace('');
					this.trace('    Types: Number, int, uint, Object, Array, Boolean, XML');
					this.trace('    Use "PageUp" & "PageDown" on the keyboard to scroll the list');
					this.trace('');
				break;
				case "-global":
					write();
					this.trace($);
				break;
				case "-get":
					if(paramA) {
						if($.containsKey(paramA)) {
							this.trace(typeof($[paramA]));
							this.trace(paramA + " : " + $[paramA]);
						} else {
							this.trace("please enter key name");
						}
					}
				break;
				case "-set":
					if(paramA && paramB && paramC) {
						switch(paramC) {
							case "Number":
								$[paramA] = Number(paramB);
							break;
							case "int":
								$[paramA] = int(paramB);
							break;
							case "uint":
								$[paramA] = uint(paramB);
							break;
							case "Object":
								$[paramA] = Object(paramB);
							break;
							case "Array":
								$[paramA] = paramB.split(",");
							break;
							case "Boolean":
								$[paramA] = Boolean(paramB);
							break;
							case "XML":
								$[paramA] = XML(paramB);
							break;
							default:
								$[paramA] = paramB;
							break;
						}
						
						this.trace(paramA + " has been set to " + paramB);
					} else {
						this.trace("please enter key / value / type");
					}
				break;
				case "-delete":
					if(paramA) {
						$.remove(paramA);
						this.trace(paramA + " has been deleted");
					}
				break;
				case "-hello":
					write();
					this.trace('Hello from AS3Console (1.1), Copyright Paulius Uza 2007 - http://www.uza.lt');
				break;
				case "-sys":
					write();
					this.trace('');
					this.trace('    System Information ');
					this.trace('------------------------------------------------------------------------------------------------------------------------');
					this.trace("    Language: " + Capabilities.language);
					this.trace("    OS: " + Capabilities.os);
					this.trace("    Pixel aspect ratio: " + Capabilities.pixelAspectRatio);
					this.trace("    Player type: " + Capabilities.playerType);
					this.trace("    Screen DPI: " + Capabilities.screenDPI);
					this.trace("    Screen resolution: " + Capabilities.screenResolutionX + " x "+ Capabilities.screenResolutionY);
					this.trace("    Version: " + Capabilities.version);
					this.trace("    Debugger: " + Capabilities.isDebugger);
					this.trace('');
					this.trace("    Memory usage: " + System.totalMemory / 1024 + " Kb")
					this.trace('');
				break;
				default:
					write();
					if(key != "") {
						if(functions.containsKey(key)) {
							if(!paramA) {
								functions[key]();
							} else {
								functions[key](paramA.split(","));
							}
						} else {
							this.trace(key + ': command not recognized');
						}
					}
				break;
			}
			historyAdd(input.text);
			historyID = -1;
			input.text = "] ";
			update();
		}
		
		// ******* END private functions
		// ******* BEGIN utility functions
		
		/**
		 * Redraws and repositions the console.
		 */
		
		private function redraw():void {
			var s:Stage = $.stage as Stage;
			// BG
			with(background.graphics) {
				clear();
				beginFill(0x000000,0.9);
				drawRect(0,0,s.stageWidth,Math.floor(s.stageHeight/3));
				endFill();
				beginFill(0x000000,1);
				drawRect(0,0,40,Math.floor(s.stageHeight/3));
				endFill();
			}
			with(msk.graphics) {
				clear();
				beginFill(0x000000,0.9);
				drawRect(0,4,s.stageWidth,Math.floor(s.stageHeight/3)- 22);
				endFill();
			}
			// Input
				input.width = s.stageWidth - 52;
				input.height = 18;
				input.x = 46;
				input.y = background.height - 20;
			// Console
				console.width = s.stageWidth - 52;
				console.x = 46;
				console.y = 0;
				console.cacheAsBitmap = false;
			// Numbering	
				numbering.y = 0;
				numbering.cacheAsBitmap = false;
			// Scroll Masking
				msk.cacheAsBitmap = false;
				masked.mask = msk;
			update();
		}
		
		/**
		 * Repositions the console's output fields, limits output size.
		 */
		
		private function update():void {
			// patch for memory and cpu leak, all text looses coloring after 1000 lines. 
			if(console.numLines >= 1000) {
				var regxA:RegExp = /(^]\s.*\s*)/g;
				console.text = console.text.replace(regxA,"");
				var regxB:RegExp = /(^.*\s*)/g;
				numbering.text = numbering.text.replace(regxB,"");
			}
			console.y = background.height - console.textHeight - 22;
			numbering.y = background.height - numbering.textHeight - 22;
		}
		
		// ******* END utility functions
		
	}
	
}

/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * Trimmed down mobile version of Arrayed Queue class by Paulius Uza
 * 
 */

internal class ArrayedQueue {
	
		private var _que:Array;
		private var _size:int;
		private var _divisor:int;
		
		private var _count:int;
		private var _front:int;
		
		/**
		 * Initializes a queue object to match the given size.
		 * The size must be a power of two to use fast bitwise AND modulo. 
		 * 
		 * @param sizeShift The size exponent. (e.g. size is 1 << sizeShift eq. 2^sizeShift)
		 */
		public function ArrayedQueue(sizeShift:int)
		{
			if (sizeShift < 3) sizeShift = 3;
			_size = 1 << sizeShift;
			_divisor = _size - 1;
			clear();
		}
		
		/**
		 * Indicates the front item.
		 * 
		 * @return The front item.
		 */
		public function peek():*
		{
			return _que[_front];
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param  obj The data.
		 * @return True if operation succeeded, otherwise false (queue is full).
		 */
		public function enqueue(obj:*):Boolean
		{
			if (_size != _count)
			{
				_que[int((_count++ + _front) & _divisor)] = obj;
				return true;
			}
			return false;
		}
		
		/**
		 * Dequeues and returns the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
		public function dequeue():*
		{
			if (_count > 0)
			{
				var data:* = _que[_front++];
				if (_front == _size) _front = 0;
				_count--;
				return data;
			}
			return null;
		}
		
		/**
		 * Deletes the last dequeued item to free it
		 * for the garbage collector. Use only directly
		 * after calling the dequeue() function.
		 */
		public function dispose():void
		{
			if (!_front) _que[int(_size  - 1)] = null;
			else 		 _que[int(_front - 1)] = null;
		}
		
		/**
		 * Reads an item relative to the front index.
		 * 
		 * @param i The index of the item.
		 * @return The item at the given relative index.
		 */
		public function getAt(i:int):*
		{
			if (i >= _count) return null;
			return _que[int((i + _front) & _divisor)];
		}
		
		/**
		 * Writes an item relative to the front index.
		 * 
		 * @param i   The index of the item.
		 * @param obj The data.
		 */
		public function setAt(i:int, obj:*):void
		{
			if (i >= _count) return;
			_que[int((i + _front) & _divisor)] = obj;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 0; i < _count; i++)
			{
				if (_que[int((i + _front) & _divisor)] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * Clears all elements.
		 */
		public function clear():void
		{
			_que = new Array(_size);
			_front = _count = 0;
		}
		
		/**
		 * The total number of items in the queue.
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * Checks if the queue is empty.
		 */
		public function isEmpty():Boolean
		{
			return _count == 0;
		}
		
		/**
		 * The maximum allowed size.
		 */
		 
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		 
		public function toString():String
		{
			return "[ArrayedQueue, size=" + size + "]";
		}
	}