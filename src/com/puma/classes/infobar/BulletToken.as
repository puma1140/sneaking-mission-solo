package com.puma.classes.infobar {
	import flash.filters.DropShadowFilter;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class BulletToken extends Sprite {
		private var sprite : Sprite;
		private var dropShadowFilter : DropShadowFilter;

		public function BulletToken() {
			mouseChildren = false;

			dropShadowFilter = new DropShadowFilter();

			sprite = new Sprite();
			sprite.graphics.beginFill(0xCDD704);
			sprite.graphics.drawRoundRect(0, 0, 10, 30, 5);
			sprite.graphics.endFill();
			sprite.filters = [dropShadowFilter];

			addChild(sprite);
		}
	}
}
