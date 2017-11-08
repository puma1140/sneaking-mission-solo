package com.puma.classes {
	import com.puma.classes.infobar.BulletToken;
	import com.puma.classes.infobar.AlertToken;
	import com.puma.screens.MapScreen;
	import com.puma.classes.infobar.MapIcon;
	import com.puma.general.Game;

	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class InfoBar extends Sprite {
		private var _game : Game = Game.getInstance();

		public function InfoBar() {
		}

		public function update() : void {
			while (numChildren)
				removeChildAt(0);

			// Σφαίρες
			if (game.player.ammoBlips) {
				var bulletToken : BulletToken;

				for (var i : uint = 0; i < game.player.ammoBlips; i++) {
					bulletToken = new BulletToken();
					bulletToken.x = 10 + i * (bulletToken.width + 5);
					bulletToken.y = Tile.TILESIZE / 2 - bulletToken.height / 2;

					addChild(bulletToken);
				}
			}

			// Alert Tokens
			var alertToken : AlertToken;

			for (var j : uint = 0; j < 5; j++) {
				alertToken = new AlertToken();
				alertToken.x = (game.stage.stageWidth / 2 + Tile.TILESIZE + 10) + j * (alertToken.width + 5);
				alertToken.y = Tile.TILESIZE / 2 - alertToken.height / 2;
				j < game.alertTokens ? alertToken.enable() : alertToken.enable(false);

				addChild(alertToken);
			}

			var mapIcon : MapIcon = new MapIcon();
			mapIcon.x = game.stage.stageWidth - mapIcon.width - 10;
			mapIcon.y = 10;
			if (game.currentScreen is MapScreen)
				mapIcon.setText(MapIcon.CLOSE);
			else
				mapIcon.setText(MapIcon.MAP);
			addChild(mapIcon);

			if (game.currentScreen is MapScreen) {
				var centerMapIcon : MapIcon = new MapIcon();
				centerMapIcon.x = mapIcon.x;
				centerMapIcon.y = mapIcon.y + mapIcon.height + 10;
				centerMapIcon.setText(MapIcon.CENTER);
				addChild(centerMapIcon);
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
