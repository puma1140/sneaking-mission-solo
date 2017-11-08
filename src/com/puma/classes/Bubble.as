package com.puma.classes {
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	import com.puma.general.Game;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Bubble extends Sprite {
		public static const HERO : uint = 1;
		public static const ENEMY : uint = 2;
		public static const DESCRIPTION : uint = 3;
		private var _game : Game = Game.getInstance();
		private var format : TextFormat;
		private var tf : TextField = new TextField();
		private var bg : Sprite;
		private var glowFilter : GlowFilter;
		private var dropShadowFilter : DropShadowFilter;

		public function Bubble() {
			mouseChildren = false;
			mouseEnabled = false;
			visible = false;

			glowFilter = new GlowFilter(0x000000, 1.0, 2.0, 2.0, 10);
			glowFilter.quality = BitmapFilterQuality.MEDIUM;

			dropShadowFilter = new DropShadowFilter();

			drawBG(80);

			format = new TextFormat();
			format.font = "arial";
			format.size = 18;
			format.bold = true;
			format.color = 0xFFFF00;
			format.align = "center";
			format.letterSpacing = 2;

			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = bg.width - 20;
			tf.height = bg.height - 20;
			tf.filters = [glowFilter];
			tf.x = 10;
			tf.y = 10;
			tf.text = "";
			// tf.border = true;

			bg.addChild(tf);
			addChild(bg);
		}

		private function drawBG(textHeight : Number) : void {
			while (numChildren)
				removeChildAt(0);

			bg = new Sprite();
			bg.graphics.beginFill(0xDDDDDD);
			bg.graphics.drawRoundRect(0, 0, game.stage.stageWidth - 2 * 110, textHeight + 20, 10);
			bg.graphics.endFill();
			bg.filters = [dropShadowFilter];

			bg.addChild(tf);
			addChild(bg);
		}

		public function setText(txt : String, type : uint = HERO) : void {
			switch (type) {
				case HERO:
					format.color = "0x05B8CC";
					break;
				case ENEMY:
					format.color = "0xBC7642";
					break;
				case DESCRIPTION:
					format.color = "0xC5C1AA";
					break;
			}

			tf.setTextFormat(format);
			tf.defaultTextFormat = format;
			tf.text = txt;

			if (txt == "")
				visible = false;
			else {
				alpha = 0.0;
				visible = true;
				tf.height = tf.textHeight + 10;
				drawBG(tf.textHeight);
			}
		}

		// Getters and Setters
		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}
	}
}
