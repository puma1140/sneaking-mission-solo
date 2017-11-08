package com.puma.general {
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Screen extends Sprite {
		private var _game:Game = Game.getInstance();
		
		public function Screen() {
			if (game.currentScreen != null) {
				game.currentScreen.destroy();
			}

			game.previousScreen = game.currentScreen;
			game.currentScreen = this;
		}
		
		public function destroy():void {
			while (numChildren)
				removeChildAt(0);
			
			while (game.root.numChildren)
				game.root.removeChildAt(0);
		}
		
		public function addToStage():void {
			game.root.addChild(this);
		}

		// Getters and Setters
		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			_game = game;
		}
	}
}