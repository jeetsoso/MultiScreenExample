package
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MultiScreenExample extends Sprite
	{
		private const TITLE_BAR_HEIGHT:Number = .3; // Height of the title bar in fractions of an inch
		private const TITLE_FONT_SIZE:Number  = .15; // Height of the title font in fractions of an inch
		private const BLOCK_SIZE:Number       = .5; // Size of blocks in fractions of an inch
		private const BLOCK_BUFFER:Number     = 3; // Space between blocks in pixels
		
		private const BACKGROUND_COLOR:uint   = 0x006E59;
		private const TITLE_BAR_COLOR:uint    = 0x003037;
		private const APP_TITLE:String        = "Multi-Screen Example";
		private const BLOCK_COLORS:Array      = [0xAAC228, 0xFFDE25, 0xFF840C];
		
		private var dpi:uint;
		private var bevel:BevelFilter;
		
		public function MultiScreenExample()
		{
			super();
			
			this.bevel = new BevelFilter(1);
			this.stage.addEventListener(Event.RESIZE, doLayout);
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
		}
		
		/**
		 * This gets called when the this.stage dimensions have been set.
		 * Good time to do layout.
		 */
		private function doLayout(e:Event):void
		{
			// Remove any children that have already been added
			while (this.numChildren > 0) this.removeChildAt(0);
			
			// TBD: Remove for code sample. Work around for DPI bug.
			//this.dpi = 83; // External Dell monitor
			//this.dpi = 110; // 15" MacBook Pro
			//this.dpi = 163; // iPhone
			//this.dpi = 265; // Android
			this.dpi = Capabilities.screenDPI;
			
			
			// Background.
			var bg:Sprite = new Sprite();
			bg.x = 0;
			bg.y = 0;
			bg.graphics.beginFill(BACKGROUND_COLOR);
			bg.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.addChild(bg);
			
			// Title bar
			var titleBar:Sprite = new Sprite();
			titleBar.x = 0;
			titleBar.y = 0;
			titleBar.graphics.beginFill(TITLE_BAR_COLOR);
			titleBar.graphics.drawRect(0, 0, this.stage.stageWidth, this.inchesToPixels(TITLE_BAR_HEIGHT));
			titleBar.graphics.endFill();
			this.addChild(titleBar);
			
			// Footer
//			var footer:Sprite = new Sprite();
//			footer.graphics.beginFill(TITLE_BAR_COLOR);
//			footer.graphics.drawRect(0, 0, this.stage.stageWidth, this.inchesToPixels(TITLE_BAR_HEIGHT));
//			footer.graphics.endFill();
//			footer.x = 0;
//			footer.y = this.stage.stageHeight - footer.height;
//			this.addChild(footer);
			
			// Title
			var title:SimpleLabel = new SimpleLabel(APP_TITLE, "bold", 0xffffff, "_sans", this.inchesToPixels(TITLE_FONT_SIZE));
			this.center(title, titleBar);
			this.addChild(title);
			
			// Test Button
//			var button:Sprite = new Sprite();
//			button.x = 20;
//			button.y = 20;
//			button.graphics.beginFill(0xff0000);
//			button.graphics.drawRect(0, 0, this.mmToPixels(10), this.mmToPixels(10));
//			button.graphics.endFill();
//			this.addChild(button);
			
			// Test button2
//			this.dpi = 72;
//			var button2:Sprite = new Sprite();
//			button2.x = 100;
//			button2.y = 100;
//			button2.graphics.beginFill(0xff0000);
//			button2.graphics.drawRect(0, 0, this.mmToPixels(10), this.mmToPixels(10));
//			button2.graphics.endFill();
//			this.addChild(button2);
			
			
			// Display as many blocks on the screen as will fit
			var blockSize:uint = this.inchesToPixels(BLOCK_SIZE);
			var blockTotal:uint = blockSize + BLOCK_BUFFER;
			var cols:uint = Math.floor(this.stage.stageWidth / blockTotal);
			var rows:uint = Math.floor((this.stage.stageHeight - titleBar.height) / blockTotal);
			var blockXStart:uint = (this.stage.stageWidth - ((cols * blockSize) + ((cols - 1) * BLOCK_BUFFER))) / 2;
			var blockX:uint = blockXStart;
			var blockY:uint = ((this.stage.stageHeight + titleBar.height) - ((rows * blockSize) + ((rows - 1) * BLOCK_BUFFER))) / 2;
			for (var colIndex:uint = 0; colIndex < rows; ++colIndex)
			{
				for (var rowIndex:uint = 0; rowIndex < cols; ++rowIndex)
				{
					var block:Sprite = this.getBlock(blockSize);
					block.x = blockX;
					block.y = blockY;
					this.addChild(block);
					blockX += blockTotal;
				}
				blockY += blockTotal;
				blockX = blockXStart;
			}
		}

		/**
		 * Get a new block to add to the game board
		 */
		private function getBlock(blockSize:uint):Sprite
		{
			var block:Sprite = new Sprite();
			block.graphics.beginFill(BLOCK_COLORS[this.getRandomWholeNumber(0, 2)]);
			block.graphics.drawRect(0, 0, blockSize, blockSize);
			block.graphics.endFill();
			block.filters = [this.bevel];
			block.cacheAsBitmap = true;
			return block;
		}
		
		/**
		 * Convert inches to pixels.
		 */
		private function inchesToPixels(inches:Number):uint
		{
			return Math.round(this.dpi * inches);
		}

		/**
		 * Convert millimeters to pixels.
		 */
		private function mmToPixels(mm:Number):uint
		{
			return Math.round(this.dpi * (mm / 25.4));
		}

		/**
		 * Center one DisplayObject relative to another.
		 */
		private function center(foreground:DisplayObject, background:DisplayObject):void
		{
			foreground.x = (background.width / 2) - (foreground.width / 2);
			foreground.y = (background.height / 2) + (foreground.height / 2);
		}
		
		private function getRandomWholeNumber(min:Number, max:Number):Number
		{
			return Math.round(((Math.random() * (max - min)) + min));
		}
	}
}