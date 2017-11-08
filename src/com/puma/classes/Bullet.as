package com.puma.classes {
	import flash.filters.GlowFilter;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Bullet extends Sprite {
		private var sprite : Sprite;
		private var glowFilter : GlowFilter;
		private var _angle : Number;
		private var _tile : Tile;
		private var _target : Tile;
		private var _moving : Boolean;
		private var _speed : Number = 0.5;

		public function Bullet() {
			glowFilter = new GlowFilter(0x000000);

			sprite = new Sprite();
			sprite.graphics.beginFill(0xCDD704);
			sprite.graphics.drawRoundRect(-3, -8, 6, 16, 5);
			sprite.graphics.endFill();
			sprite.filters = [glowFilter];

			addChild(sprite);
			visible = false;
		}

		// Getters and Setters
		public function get angle() : Number {
			return _angle;
		}

		public function set angle(angle : Number) : void {
			this._angle = angle;
			rotation = 90 + angle * 180 / Math.PI;
		}

		public function get tile() : Tile {
			return _tile;
		}

		public function set tile(tile : Tile) : void {
			this._tile = tile;
		}

		public function get moving() : Boolean {
			return _moving;
		}

		public function set moving(moving : Boolean) : void {
			this._moving = moving;
			visible = moving;
		}

		public function get speed() : Number {
			return _speed;
		}

		public function set speed(speed : Number) : void {
			this._speed = speed;
		}

		public function get target() : Tile {
			return _target;
		}

		public function set target(target : Tile) : void {
			this._target = target;
		}
	}
}
