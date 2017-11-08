package com.puma.classes {
	import com.puma.general.Game;
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Map extends Sprite {
		private var _game : Game = Game.getInstance();
		private var _tiles : Vector.<MapTile>;
		
		public function Map() {
		}
		
		public function build():void {
			tiles = new Vector.<MapTile>();
			if (game.map.length) {
				var mapTile:MapTile;
				var currentRoomNum:uint = 0;
				
				for (var i:uint = 0; i < game.map.length; i++) {
					mapTile = new MapTile();
					mapTile.room = game.map[i];
					mapTile.num = i;
					mapTile.x = mapTile.room.col * MapTile.TILESIZE;
					mapTile.y = mapTile.room.row * MapTile.TILESIZE;
					
					if (mapTile.room == game.player.tile.room)
						currentRoomNum = i;

					addChild(mapTile);
					tiles.push(mapTile);
				}
				
				setChildIndex(tiles[currentRoomNum], numChildren - 1);
				moveToTile(tiles[currentRoomNum]);
			}
		}
		
		private function moveToTile(mapTile:MapTile):void {
			x = (game.stage.stageWidth - MapTile.TILESIZE) / 2 - mapTile.x;
			y = (game.stage.stageHeight - MapTile.TILESIZE) / 2 - mapTile.y;
		}

		// Getters and Setters
		public function get tiles() : Vector.<MapTile> {
			return _tiles;
		}

		public function set tiles(tiles : Vector.<MapTile>) : void {
			this._tiles = tiles;
		}

		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}
	}
}
