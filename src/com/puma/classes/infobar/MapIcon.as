package com.puma.classes.infobar {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class MapIcon extends Sprite {
		public static const MAP:String = "Map";
		public static const CLOSE:String = "Close";
		public static const CENTER:String = "Center";
		
		private var sprite:Sprite;
		private var format:TextFormat;
		private var tf : TextField;
		private var _type : String;
		
		public function MapIcon() {
			mouseChildren = false;

			sprite = new Sprite();
			sprite.graphics.beginFill(0x8E2323);
			sprite.graphics.drawRect(0, 0, 42, 42);
			sprite.graphics.endFill();
			
			format = new TextFormat();
			format.font = "verdana";
			format.size = 10;
			format.bold = true;
			format.color = 0xFFFFFF;
			format.align = "center";
			
			tf = new TextField();
			tf.width = sprite.width;
			tf.height = sprite.height;
			tf.selectable = false;
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
			
			sprite.addChild(tf);
			addChild(sprite);
		}
		
		public function setText(txt:String):void {
			tf.text = txt;
			type = txt;
		}

		// Getters and Setters
		public function get type() : String {
			return _type;
		}

		public function set type(type : String) : void {
			this._type = type;
		}
	}
}
