package com.puma.classes {
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Action extends Sprite {
		public static const FIGHT : String = "Fight";
		public static const HIDE : String = "Just Hide";
		public static const USE_GUN : String = "Use Weapon";
		public static const CHANGE_ROOM:String = "Change Room";
		private var _type : String;
		// Προσωρινές μεταβλητές
		private var sprite : Sprite;
		private var tf : TextField;
		private var format : TextFormat;

		public function Action(t:String) {
			type = t;
			mouseChildren = false;

			sprite = new Sprite();
			tf = new TextField();
			format = new TextFormat();

			format.font = "verdana";
			format.size = 12;
			format.color = 0xFFFFFF;
			format.bold = true;
			format.align = "center"	;

			tf.selectable = false;
			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
			tf.width = 100;
			tf.height = 30;
			tf.border = true;
			tf.text = type;
			
			sprite.addChild(tf);
			addChild(sprite);
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
