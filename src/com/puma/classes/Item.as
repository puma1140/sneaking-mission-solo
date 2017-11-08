package com.puma.classes {
	import flash.text.TextField;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Item extends Sprite {
		// Μερικά σταθερά αντικείμενα
		public static const WEAPON:String = "weapon";
		public static const CIRCUIT:String = "circuit";
		public static const ENTRANCE:String = "entrance";
		public static const CAMERA:String = "camera";
		public static const CAMERA_LINEOFSIGHT:String = "camera_lineofsight";
		public static const AIR_DUCT:String = "airduct";
		public static const BOX:String = "box";
		public static const LOCKER:String = "locker";
		public static const FILES:String = "files";
		public static const LASER:String = "laser";

		private var _tf : TextField;
		private var _sprite : Sprite;
		
		public function Item(description:String) {
			name = description;
			
			sprite = new Sprite();
			sprite.graphics.lineStyle(1.0, 0xFF0000);
			sprite.graphics.drawRect(0, 0, 40, 40);
			sprite.mouseEnabled = false;
			sprite.mouseChildren = false;
			
			tf = new TextField();
			tf.selectable = false;
			tf.width = sprite.width;
			tf.height = sprite.height;
			tf.text = description;
			
			sprite.addChild(tf);
			addChild(sprite);
		}

		// Getters and Setters
		public function get tf() : TextField {
			return _tf;
		}

		public function set tf(tf : TextField) : void {
			this._tf = tf;
		}

		public function get sprite() : Sprite {
			return _sprite;
		}

		public function set sprite(sprite : Sprite) : void {
			this._sprite = sprite;
		}
	}
}
