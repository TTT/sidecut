package {
	
import flash.util.describeType;
import flash.display.MovieClip;
import flash.display.TextField;
import flash.text.TextFormat;
import flash.text.AntiAliasType;
  
   public class Test extends MovieClip {
    
      // be sure this is pointing to a ttf font in your hardrive
      [Embed(source="UniversLTStd-Light.otf", fontFamily="foo")] 
      public var bar:String;
      			
      public function Test() {
                	
          var format:TextFormat	      = new TextFormat();
          format.font		      = "foo";
          format.color                = 0xFFFFFF;
          format.size                 = 130;
						
          var label:TextField         = new TextField();
          label.embedFonts            = true;
          label.autoSize              = TextFieldAutoSize.LEFT;
          label.antiAliasType         = AntiAliasType.ADVANCED;
          label.defaultTextFormat     = format;
          label.text                  = "Hello World!";
          addChild(label);
       }
    }
}