package
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.getDefinitionByName;
	
	[SWF(width = "240", height = "240")]
	public class Preloader extends Sprite
	{
		// Change these values
		private static const BG_COLOR:uint = Com.COLOR_0;
		private static const FG_COLOR:uint = Com.COLOR_3;
		
		// Ignore everything else
		
		private var className:String = "Stray"
		private var progressBar: Shape;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;
		
		private var p:Number;
		
		public function Preloader ()
		{
			p = 0;
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.6;
			h = 3;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5;
			
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			graphics.beginFill(FG_COLOR);
			graphics.drawRect(px - 2, py - 2, w + 4, h + 4);
			graphics.endFill();
			
			progressBar = new Shape();
			
			addChild(progressBar);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		public function onEnterFrame (e:Event): void
		{
			if (hasLoaded())
			{
				graphics.clear();
				graphics.beginFill(BG_COLOR);
				graphics.drawRect(0, 0, sw, sh);
				graphics.endFill();
				
				startup();
			} else {
				p = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
				
				progressBar.graphics.clear();
				progressBar.graphics.beginFill(BG_COLOR);
				progressBar.graphics.drawRect(px, py, p * w, h);
				progressBar.graphics.endFill();
				
			}
			
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = Class(getDefinitionByName(className));
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
	}
}// ActionScript file