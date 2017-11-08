package com.puma.classes {
	import com.puma.general.Game;

	/**
	 * @author puma
	 */
	// A* algorithm (http://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode)
	public class Pathfinder {
		private var _game : Game = Game.getInstance();
		private var _room : Room;
		// Οι μεταβλητές του αλγορίθμου
		private var _closedSet : Vector.<Tile>;
		private var _openSet : Vector.<Tile>;
		private var _neighbours : Vector.<Tile>;
		private var _cameFrom : Vector.<Tile>;
		private var _path : Vector.<Tile>;

		public function Pathfinder(room : Room) {
			this._room = room;
		}

		public function run(start : Tile, goal : Tile) : Vector.<Tile> {
			var current : Tile;
			var tentantiveScoreG : int;

			path = new Vector.<Tile>();
			cameFrom = new Vector.<Tile>();
			closedSet = new Vector.<Tile>();
			openSet = new Vector.<Tile>();
			openSet.push(start);

			start.scoreG = 0;
			start.scoreF = start.scoreG + heuristic(start, goal);

			while (openSet.length) {
				current = lowestF();
				if (current == goal) {
					reconstructPath(goal);
					path.splice(0, 1);
					return path;
				}

				openSet.splice(openSet.indexOf(current), 1);
				closedSet.push(current);
				findNeighbours(current);

				if (neighbours.length) {
					for (var i : uint = 0; i < neighbours.length; i++) {
						tentantiveScoreG = current.scoreG + findDistance(current, neighbours[i]);

						if (closedSet.indexOf(neighbours[i]) >= 0 && tentantiveScoreG >= neighbours[i].scoreG)
							continue;
						else {
							cameFrom.push(neighbours[i]);
							neighbours[i].cameFrom = current;
							neighbours[i].scoreG = tentantiveScoreG;
							neighbours[i].scoreF = neighbours[i].scoreG + heuristic(neighbours[i], goal);
							if (openSet.indexOf(neighbours[i]) == -1)
								openSet.push(neighbours[i]);
						}
					}
				}
			}

			return null;
		}

		private function reconstructPath(current : Tile) : Vector.<Tile> {
			var index : int = -1;
			if (cameFrom.length)
				index = cameFrom.indexOf(current);

			if (index != -1) {
				path = reconstructPath(current.cameFrom);
				path.push(current);
			} else {
				path = new Vector.<Tile>();
				path.push(current);
			}

			return path;
		}

		// Πρέπει να αλλάξει σε άλλη περίπτωση
		private function heuristic(tile1 : Tile, tile2 : Tile) : int {
			return Math.abs(tile1.row - tile2.row) + Math.abs(tile1.col - tile2.col);
		}

		// Manhattan Distance
		private function findDistance(tile1 : Tile, tile2 : Tile) : uint {
			return Math.abs(tile1.row - tile2.row) + Math.abs(tile1.col - tile2.col);
		}

		private function lowestF() : Tile {
			var lowest : int = 9999;
			var tile : Tile;

			if (openSet.length) {
				for (var i : uint = 0; i < openSet.length; i++) {
					if (openSet[i].scoreF < lowest) {
						tile = openSet[i];
						lowest = openSet[i].scoreF;
					}
				}
			}

			return tile;
		}

		private function findNeighbours(tile : Tile) : void {
			neighbours = new Vector.<Tile>();

			// North
			if (tile.row > 0)
				if (room.tiles[tile.num - Room.cols].type != Tile.WALL)
					neighbours.push(room.tiles[tile.num - Room.cols]);

			// South
			if (tile.row < Room.rows - 1)
				if (room.tiles[tile.num + Room.cols].type != Tile.WALL)
					neighbours.push(room.tiles[tile.num + Room.cols]);

			// West
			if (tile.col > 0)
				if (room.tiles[tile.num - 1].type != Tile.WALL)
					neighbours.push(room.tiles[tile.num - 1]);

			// East
			if (tile.col < Room.cols - 1)
				if (room.tiles[tile.num + 1].type != Tile.WALL)
					neighbours.push(room.tiles[tile.num + 1]);
		}

		public function print() : void {
			if (path.length) {
				for (var i : uint = 0; i < path.length; i++)
					trace(path[i].num);
			}
		}

		// Getters and Setters
		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}

		public function get room() : Room {
			return _room;
		}

		public function set room(room : Room) : void {
			this._room = room;
		}

		public function get closedSet() : Vector.<Tile> {
			return _closedSet;
		}

		public function set closedSet(closedSet : Vector.<Tile>) : void {
			this._closedSet = closedSet;
		}

		public function get openSet() : Vector.<Tile> {
			return _openSet;
		}

		public function set openSet(openSet : Vector.<Tile>) : void {
			this._openSet = openSet;
		}

		public function get neighbours() : Vector.<Tile> {
			return _neighbours;
		}

		public function set neighbours(neighbours : Vector.<Tile>) : void {
			this._neighbours = neighbours;
		}

		public function get path() : Vector.<Tile> {
			return _path;
		}

		public function set path(path : Vector.<Tile>) : void {
			this._path = path;
		}

		public function get cameFrom() : Vector.<Tile> {
			return _cameFrom;
		}

		public function set cameFrom(cameFrom : Vector.<Tile>) : void {
			this._cameFrom = cameFrom;
		}
	}
}
