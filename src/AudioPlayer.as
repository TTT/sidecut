/*
   AudioPlayer.as
   src
   
   Created by kemuri on 2008-03-01.
   Copyright 2008 k3corp.jp. All rights reserved.
*/

package {

	import lt.uza.utils.*;							//Custom debugger
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import flash.events.*;
	import flash.system.Security;
	import flash.net.URLRequest;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.SoundShortcuts;
		
	public class AudioPlayer {

		private var Debug:Global = Global.init();

		//Debug.register(pause());
		
		/* ================ */
		/* = DECLARATIONS = */
		/* ================ */
		private var current_sndobj:Object;
		private var sound_parameters:SoundLoaderContext;
		private var sound_channel:SoundChannel;
		private var playlist:Array;
		
		private var player_status:String	= null;	
		private var player_volume:String;				
		private var buffer_length:Number	= 3000; 
		private var play_position:Number;
		//private var auto_play:Boolean 		= true;
		
		function AudioPlayer() {
			super();
			sound_parameters= new SoundLoaderContext(buffer_length,false);
			playlist		= new Array();
			
			SoundShortcuts.init();		// Required for tweener to tween volume.
		
		}
		
		/* =========== */
		/* = PRIVATE = */
		/* =========== */
		
		private function initSound(file:String = null, params:SoundLoaderContext = null):Object {
			var tmp_obj:Object = {snd:new Sound(), channel:new SoundChannel(), transformer:new SoundTransform(.8,0), play_position:0, state:"empty", id:file}; //Possible values : PLAYING, STOPPED, PAUSED, EMPTY;
			tmp_obj.snd.addEventListener(Event.COMPLETE, onSoundComplete);
           	tmp_obj.snd.addEventListener(Event.OPEN, onSoundOpen);
           	tmp_obj.snd.addEventListener(IOErrorEvent.IO_ERROR, onSoundError);
            tmp_obj.snd.addEventListener(ProgressEvent.PROGRESS, onSoundProgress);
			tmp_obj.snd.load(new URLRequest(file),params);

			playlist.push(tmp_obj);
			return playlist[playlist.length-1];
		}
		
		private function find_sound_object (snd_url:String):Object {
			for (var i:int = 0; i<playlist.length; i++){
				if (playlist[i].id == snd_url || playlist[i].snd.url == snd_url ) {
					return playlist[i];
				}
			}
			return null;
		}
		
	
		/* ========== */
		/* = PUBLIC = */
		/* ========== */

		
		public function play(p_url:String):void {
			
			//Check if snd object is exisiting, if not create a new one
			var sound_object:Object = find_sound_object(p_url);
			if ( sound_object == null) { sound_object = initSound(p_url,sound_parameters); } 
			
			if (sound_object.state == "playing") { pause(); return; } //pause if playing
			
			sound_object.channel = sound_object.snd.play(sound_object.play_position,0,sound_object.transformer);	// assign channel to snd object
			sound_object.channel.soundTransform = sound_object.transformer; 						// assign snd transform to the channel
			player_status = sound_object.state = "playing";											// set states to playing
			current_sndobj = sound_object;
		}
		
		public function pause() : void {
			Tweener.addTween(current_sndobj.channel, {_sound_volume:0, time:1, transition:"easeOutQuad"});
			//current_sndobj.channel.stop();
			//current_sndobj.
			//play_position = sound_channel.position;
			//sound_channel.stop();
			//state = "PAUSED";
			
			
		}
		
		public function stop():void {
			//play_position = 0;
			//sound_channel.stop();
			//state = "STOPPED";
		}
		
		
		
		/* ============== */
		/* = PROPERTIES = */
		/* ============== */
		public function get player_state() : String { 
			return "state"; 
		}
		
		public function get volume() : Number { 
			return 0; 
		}

		public function set volume( value:Number ) : void {
			//sound_mixer.volume = value;
		}
		
		public function get autoplay() : Boolean { 
			return true; 
		}

		public function set autoplay( value:Boolean ) : void {
			//auto_play = value;
		}
		
		/* ================== */
		/* = EVENT HANDLERS = */
		/* ================== */
		
		
		private function onSoundComplete(event:Event):void {
			Debug.trace("onsoundComplete fires ->		" + event.target.url);
			//find_sound_object(event.target.url).snd.play(0,0,sound_mixer);
		}
		
		private function onSoundError(event:IOErrorEvent):void {
			Debug.trace("onSoundError fires ->		" + event.target.url);
		}

		private function onSoundOpen(event:Event):void {
			//Debug.trace("onSoundOpen fires ->		" + event.target.url);
		}
		
		private function onSoundProgress(event:Event):void {
			
			Debug.trace("onSoundProgress fires ->		" + find_sound_object(event.target.url).state);
		}
		
	}
}