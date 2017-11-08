package com.puma.classes.infobar {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class AlertToken extends Sprite {
		private var bg : Sprite;
		private var sprite1 : Sprite;
		private var sprite2 : Sprite;
		private var glowFilter : GlowFilter;
		private var dropShadowFilter : DropShadowFilter;

		public function AlertToken() {
			mouseChildren = false;

			glowFilter = new GlowFilter(0x000000);
			dropShadowFilter = new DropShadowFilter();

			bg = new Sprite();
			bg.graphics.beginFill(0xDDDDDD);
			bg.graphics.drawRect(0, 0, 42, 42);
			bg.graphics.endFill();
			bg.filters = [glowFilter];

			sprite1 = new Sprite();
			sprite1.graphics.beginFill(0x9D1309);
			sprite1.graphics.drawRect(0, 0, 6, 20);
			sprite1.x = (bg.width - sprite1.width ) / 2;
			sprite1.y = 5;
			sprite1.filters = [dropShadowFilter];

			sprite2 = new Sprite();
			sprite2.graphics.beginFill(0x9D1309);
			sprite2.graphics.drawRect(0, 0, sprite1.width, sprite1.width);
			sprite2.x = sprite1.x;
			sprite2.y = sprite1.y + sprite1.height + 5;
			sprite2.filters = [dropShadowFilter];

			addChild(bg);
		}

		public function enable(value : Boolean = true) : void {
			if (value) {
				alpha = 1.0;
				if (!contains(sprite1))
					addChild(sprite1);
				if (!contains(sprite2))
					addChild(sprite2);
			} else {
				alpha = 0.3;
				if (contains(sprite1))
					removeChild(sprite1);
				if (contains(sprite2))
					removeChild(sprite2);
			}
		}
	}
}
