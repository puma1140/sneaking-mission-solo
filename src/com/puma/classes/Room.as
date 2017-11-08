package com.puma.classes {
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.puma.general.AssetManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.puma.general.Game;

	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Room extends Sprite {
		private var _game : Game = Game.getInstance();
		// Τα είδη δωματίων
		public static const EMPTY : uint = 0;
		public static const WEAPON : uint = 1;
		public static const CIRCUIT : uint = 2;
		public static const ENTRANCE : uint = 3;
		public static const GUARD : uint = 4;
		public static const LASER : uint = 5;
		public static const CAMERA : uint = 6;
		public static const AIRDUCT : uint = 7;
		public static const BOXES : uint = 8;
		public static const LOCKERS : uint = 9;
		public static const FILES : uint = 10;
		public static const ARROW_TOKEN : uint = Math.round(1 + 3 * Math.random());
		// public static const ARROW_TOKEN:uint = SOUTH;
		// Κατευθύνσεις
		public static const NORTH : uint = 1;
		public static const EAST : uint = 2;
		public static const SOUTH : uint = 3;
		public static const WEST : uint = 4;
		// Αν υπάρχει έξοδος σε κάθε κατεύθυνση
		private var _exitNorth : Boolean = false;
		private var _exitSouth : Boolean = false;
		private var _exitWest : Boolean = false;
		private var _exitEast : Boolean = false;
		// Με ποιο δωμάτιο συνδέεται η έξοδος σε κάθε κατεύθυνση
		private var _roomNorth : Room;
		private var _roomSouth : Room;
		private var _roomWest : Room;
		private var _roomEast : Room;
		private var _guard : Guard;
		// Ο φρουρός στο δωμάτιο
		private var _type : uint;
		// Το είδος του δωματίου
		private var _types : Array;
		// Τα είδη των tiles του δωματίου
		private var _tiles : Vector.<Tile>;
		// Τα tiles του δωματίου
		public static var rows : uint = 0;
		public static var cols : uint = 0;
		private var _row : int;
		// Ποια σειρά κατέχει στο χάρτη
		private var _col : int;
		// Ποια στήλη κατέχει στο χάρτη
		// Τα γραφικά του δωματίου
		private var backgrounds : Array;
		private var tilesetCols : uint = 0;
		private var tilesetBitmapData : BitmapData;
		private var roomBitmapData : BitmapData;

		public function Room(t : uint = 0, exNorth : Boolean = false, exEast : Boolean = false, exSouth : Boolean = false, exWest : Boolean = false, g : Guard = null) {
			type = t;
			exitNorth = exNorth;
			exitSouth = exSouth;
			exitWest = exWest;
			exitEast = exEast;
			guard = g;

			// Για λόγους τυχαιότητας
			var rand : uint = game.randomNumbers(0, 3);

			while (rand > 0) {
				this.rotate();
				rand--;
			}
		}

		public function describe() : void {
			var output : String = "";

			output += "--------------------------------";
			output += "\nType: " + type;
			output += "\nGuard: " + guard;
			output += "\nExit North: " + exitNorth + ", Room North: " + roomNorth;
			if (roomNorth)
				output += "(" + roomNorth.row + ", " + roomNorth.col + ")";
			output += "\nExit East: " + exitEast + ", Room East: " + roomEast;
			if (roomEast)
				output += "(" + roomEast.row + ", " + roomEast.col + ")";
			output += "\nExit South: " + exitSouth + ", Room South: " + roomSouth;
			if (roomSouth)
				output += "(" + roomSouth.row + ", " + roomSouth.col + ")";
			output += "\nExit West: " + exitWest + ", Room West: " + roomWest;
			if (roomWest)
				output += "(" + roomWest.row + ", " + roomWest.col + ")";
			output += "\n--------------------------------";

			trace(output);
		}

		public function init() : void {
			if (types != null)
				return;

			types = [[1, 1, 1, 1, 1, (exitNorth ? 2 : 1), (exitNorth ? 2 : 1), 1, 1, 1, 1, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [(exitWest ? 2 : 1), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (exitEast ? 2 : 1)], [(exitWest ? 2 : 1), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (exitEast ? 2 : 1)], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], [1, 1, 1, 1, 1, (exitSouth ? 2 : 1), (exitSouth ? 2 : 1), 1, 1, 1, 1, 1]];
			backgrounds = [[12, 8, 8, 8, 8, (exitNorth ? 4 : 8), (exitNorth ? 0 : 8), 8, 8, 8, 8, 14], [11, 16, 17, 16, 17, 16, 17, 16, 17, 16, 17, 10], [11, 17, 16, 17, 16, 17, 16, 17, 16, 17, 16, 10], [11, 16, 17, 16, 17, 16, 17, 16, 17, 16, 17, 10], [(exitWest ? 3 : 11), 17, 16, 17, 16, 17, 16, 17, 16, 17, 16, (exitEast ? 6 : 10)], [(exitWest ? 7 : 11), 16, 17, 16, 17, 16, 17, 16, 17, 16, 17, (exitEast ? 2 : 10)], [11, 17, 16, 17, 16, 17, 16, 17, 16, 17, 16, 10], [11, 16, 17, 16, 17, 16, 17, 16, 17, 16, 17, 10], [11, 17, 16, 17, 16, 17, 16, 17, 16, 17, 16, 10], [15, 9, 9, 9, 9, (exitSouth ? 1 : 9), (exitSouth ? 5 : 9), 9, 9, 9, 9, 13]];
		}

		public function build() : void {
			if (tiles && tiles.length) // Αν έχουν δημιουργηθεί τα tiles, επέστρεψε
				return;

			init();

			if (types != null)
				if (types[0] != undefined) {
					rows = types.length;
					var colsArray : Array = types[0];
					cols = colsArray.length;
				}

			if (rows && cols) {
				var tilesetImage : Bitmap = new AssetManager.TilesetRoom();
				tilesetBitmapData = new BitmapData(tilesetImage.width, tilesetImage.height);
				tilesetBitmapData.draw(tilesetImage);
				tilesetCols = tilesetBitmapData.width / Tile.TILESIZE;

				roomBitmapData = new BitmapData(cols * Tile.TILESIZE, rows * Tile.TILESIZE);

				tiles = new Vector.<Tile>();
				var tempTile : Tile;

				for (var i : uint = 0; i < rows; i++) {
					for (var j : uint = 0; j < cols; j++) {
						tempTile = new Tile();
						tempTile.type = types[i][j];
						tempTile.row = i;
						tempTile.col = j;
						tempTile.num = (i * cols) + j;
						tempTile.x = j * Tile.TILESIZE;
						tempTile.y = i * Tile.TILESIZE;
						tempTile.room = this;

						if (backgrounds[i] != undefined && backgrounds[i][j] != undefined)
							drawTile(j, i, backgrounds[i][j]);

						addChild(tempTile);
						tiles.push(tempTile);
					}
					// end for
				}
				// end for

				var roomBitmap : Bitmap = new Bitmap(roomBitmapData);
				addChildAt(roomBitmap, 0);

				createRandomItems();
			}
			// end if
		
			// trace("(" + row + ", " + col + ")");
		}

		public function drawTile(x : uint, y : uint, graphic : uint) : void {
			var row : uint = Math.floor(graphic / tilesetCols);
			var col : uint = graphic - row * tilesetCols;

			roomBitmapData.copyPixels(tilesetBitmapData, new Rectangle(col * Tile.TILESIZE, row * Tile.TILESIZE, Tile.TILESIZE, Tile.TILESIZE), new Point(x * Tile.TILESIZE, y * Tile.TILESIZE));
		}

		public function rotate() : void {
			var temp1 : Boolean;
			var temp2 : Boolean;

			temp1 = exitEast;
			exitEast = exitNorth;

			temp2 = exitSouth;
			exitSouth = temp1;

			temp1 = exitWest;
			exitWest = temp2;

			exitNorth = temp1;

			if (guard)
				guard.rotate();

			// trace("Room '" + name + "' is rotated to: " + exitNorth + ", " + exitEast + ", " + exitSouth + ", " + exitWest);
		}

		public function clearItems() : void {
			for (var i : uint = 0; i < tiles.length; i++)
				tiles[i].item = null;
			type = EMPTY;
		}

		public function findDirection(from : uint, to : uint) : uint {
			if (to == from - 1)
				return WEST;

			if (to == from + 1)
				return EAST;

			if (to == from - cols)
				return NORTH;

			if (to == from + cols)
				return SOUTH;

			return 0;
		}

		/* Δημιουργία αντικειμένων και φρουρών στο χώρο /*
		/**********************************************************************************************/
		/**********************************************************************************************/
		private function createRandomItems() : void {
			switch (type) {
				case WEAPON:
					createWeapon();
					break;
				case CIRCUIT:
					createCircuit();
					break;
				case ENTRANCE:
					createEntrance();
					break;
				case CAMERA:
					createCameras();
					break;
				case AIRDUCT:
					createAirduct();
					break;
				case BOXES:
					createBoxes();
					break;
				case LOCKERS:
					createLockers();
					break;
				case FILES:
					createFiles();
					break;
				case LASER:
					createLaser();
					break;
				case GUARD:
					createGuard();
					break;
			}
		}

		private function createWeapon() : void {
			var num : uint = game.randomNumbers(1, rows - 2) * cols + game.randomNumbers(1, cols - 2);
			tiles[num].item = new Item(Item.WEAPON);
		}

		private function createCircuit() : void {
			var num : uint = game.randomNumbers(1, rows - 2) * cols + game.randomNumbers(1, cols - 2);
			tiles[num].item = new Item(Item.CIRCUIT);
		}

		private function createEntrance() : void {
			var num : uint = game.randomNumbers(1, rows - 2) * cols + game.randomNumbers(1, cols - 2);
			tiles[num].item = new Item(Item.ENTRANCE);
		}

		private function createAirduct() : void {
			var num : uint = game.randomNumbers(1, rows - 2) * cols + game.randomNumbers(1, cols - 2);
			tiles[num].item = new Item(Item.AIR_DUCT);
		}

		private function createCameras() : void {
			var num : uint = 0 * cols + 2;
			tiles[num].item = new Item(Item.CAMERA);

			num = 0 * cols + cols - 3;
			tiles[num].item = new Item(Item.CAMERA);

			num = (rows - 1) * cols + 2;
			tiles[num].item = new Item(Item.CAMERA);

			num = (rows - 1) * cols + cols - 3;
			tiles[num].item = new Item(Item.CAMERA);

			num = 2 * cols + 0;
			tiles[num].item = new Item(Item.CAMERA);

			num = (rows - 3) * cols + 0;
			tiles[num].item = new Item(Item.CAMERA);

			num = 2 * cols + cols - 1;
			tiles[num].item = new Item(Item.CAMERA);

			num = (rows - 3) * cols + cols - 1;
			tiles[num].item = new Item(Item.CAMERA);

			for (var i : uint = 0; i < rows; i++)
				for (var j : uint = 0; j < cols; j++) {
					if (i == rows / 2 - 3 || i == rows / 2 + 2) {
						if (j > 0 && j < cols - 1)
							tiles[i * cols + j].item = new Item(Item.CAMERA_LINEOFSIGHT);
					} else if (j == cols / 2 - 4 || j == cols / 2 + 3)
						if (i > 0 && i < rows - 1)
							tiles[i * cols + j].item = new Item(Item.CAMERA_LINEOFSIGHT);
				}
		}

		private function createBoxes() : void {
			var total : uint = game.randomNumbers(1, 4);
			var num : uint;

			for (var i : uint = 0; i < total; i++) {
				num = game.randomNumbers(1, rows - 2) * cols + game.randomNumbers(1, cols - 2);
				tiles[num].item = new Item(Item.BOX);
			}
		}

		private function createLockers() : void {
			var rand : uint = game.randomNumbers(1, 4);

			switch (rand) {
				case 1:
					tiles[1 * cols + 1].item = new Item(Item.LOCKER);
					tiles[1 * cols + 2].item = new Item(Item.LOCKER);
					tiles[1 * cols + 3].item = new Item(Item.LOCKER);
					break;
				case 2:
					tiles[1 * cols + cols - 2].item = new Item(Item.LOCKER);
					tiles[1 * cols + cols - 3].item = new Item(Item.LOCKER);
					tiles[1 * cols + cols - 4].item = new Item(Item.LOCKER);
					break;
				case 3:
					tiles[(rows - 2) * cols + 1].item = new Item(Item.LOCKER);
					tiles[(rows - 2) * cols + 2].item = new Item(Item.LOCKER);
					tiles[(rows - 2) * cols + 3].item = new Item(Item.LOCKER);
					break;
				case 4:
					tiles[(rows - 2) * cols + cols - 2].item = new Item(Item.LOCKER);
					tiles[(rows - 2) * cols + cols - 3].item = new Item(Item.LOCKER);
					tiles[(rows - 2) * cols + cols - 4].item = new Item(Item.LOCKER);
					break;
			}
		}

		private function createFiles() : void {
			var num : uint = game.randomNumbers(1, rows - 2) * cols + game.randomNumbers(1, cols - 2);
			tiles[num].item = new Item(Item.FILES);
		}

		private function createLaser() : void {
			for (var i : uint = 0; i < rows; i++)
				for (var j : uint = 0; j < cols; j++) {
					if (i == rows / 2 - 3 || i == rows / 2 + 2) {
						if (j > 0 && j < cols - 1)
							tiles[i * cols + j].item = new Item(Item.LASER);
					} else if (j == cols / 2 - 4 || j == cols / 2 + 3)
						if (i > 0 && i < rows - 1)
							tiles[i * cols + j].item = new Item(Item.LASER);
				}
		}

		private function createGuard() : void {
			if (guard == null)
				return;
			var row : uint = game.randomNumbers(rows / 2 - 2, rows / 2 + 1);
			var col : uint = game.randomNumbers(cols / 2 - 2, cols / 2 + 1);

			tiles[row * cols + col].guard = guard;
		}

		/* Ρυθμίσεις δωματίων για σύνδεση /*
		/**********************************************************************************************/
		/**********************************************************************************************/
		public function connect(newRoom : Room, direction : uint) : void {
			// Αν δεν υπάρχει έξοδος ή υπάρχει ήδη σύνδεση με δωμάτιο, return
			switch (direction) {
				case Room.NORTH:
					if (!exitNorth || roomNorth)
						return;
					break;
				case Room.EAST:
					if (!exitEast || roomEast)
						return;
					break;
				case Room.SOUTH:
					if (!exitSouth || roomSouth)
						return;
					break;
				case Room.WEST:
					if (!exitWest || roomWest)
						return;
					break;
			}

			// Στην περίπτωση ξύπνιου φρουρού, κάλεσε άλλη συνάρτηση
			if (newRoom.type == Room.GUARD && newRoom.guard != null && newRoom.guard.sleeping == false) {
				// Σύνδεση με βάση το βελάκι
				if (newRoom.guard.arrowDirection > 0)
					connectGuardByArrow(newRoom, direction);
				else if (newRoom.guard.redSquare > 0)
					connectGuardByRedSquare(newRoom, direction);
				else {
					trace("Δεν υπάρχει βελάκι ή κόκκινο κουτάκι στο φρουρό (σφάλμα). Θα πραγματοποιηθεί κλασική σύνδεση δωματίου.");
					connectStandard(newRoom, direction);
				}
			} else {
				// Κλασική σύνδεση
				connectStandard(newRoom, direction);
			}
		}

		// Κλασική σύνδεση δωματίου
		private function connectStandard(newRoom : Room, direction : uint) : void {
			// trace("Κλασική σύνδεση δωματίου");
			var count : uint = 0;

			switch (direction) {
				case Room.NORTH:
					while (!newRoom.exitSouth && count < 4) {
						newRoom.rotate();
						count++;
					}
					break;
				case Room.EAST:
					while (!newRoom.exitWest && count < 4) {
						newRoom.rotate();
						count++;
					}
					break;
				case Room.SOUTH:
					while (!newRoom.exitNorth && count < 4) {
						newRoom.rotate();
						count++;
					}
					break;
				case Room.WEST:
					while (!newRoom.exitEast && count < 4) {
						newRoom.rotate();
						count++;
					}
					break;
			}

			attachRoom(newRoom, direction);
		}

		// Σύνδεση δωματίου φρουρού με βάση το βελάκι
		private function connectGuardByArrow(newRoom : Room, direction : uint) : void {
			// trace("Σύνδεση δωματίου με φρουρό με βάση το βελάκι");
			var count : uint = 0;

			while (newRoom.guard.arrowDirection != Room.ARROW_TOKEN && count < 4) {
				newRoom.rotate();
				count++;
			}

			if (!attachRoom(newRoom, direction))
				connectGuardByDoor(newRoom, direction);
		}

		// Σύνδεση δωματίου με φρουρό με βάση την πόρτα εισόδου
		private function connectGuardByDoor(newRoom : Room, direction : uint) : void {
			// trace("Σύνδεση δωματίου με φρουρό με βάση την πόρτα εισόδου");
			var count : uint = 0;
			var oppositeDirection : uint;
			(direction <= 2) ? oppositeDirection = direction + 2 : oppositeDirection = direction - 2;

			while (newRoom.guard.arrowDirection != oppositeDirection && count < 4) {
				newRoom.rotate();
				count++;
			}

			if (!attachRoom(newRoom, direction))
				connectStandard(newRoom, direction);
		}

		private function connectGuardByRedSquare(newRoom : Room, direction : uint) : void {
			// trace("Σύνδεση δωματίου με φρουρό με βάση το κόκκινο κουτάκι.");
			var count : uint = 0;
			var oppositeDirection : uint;
			(direction <= 2) ? oppositeDirection = direction + 2 : oppositeDirection = direction - 2;

			while (newRoom.guard.redSquare != oppositeDirection && count < 4) {
				newRoom.rotate();
				count++;
			}

			if (!attachRoom(newRoom, direction))
				connectStandard(newRoom, direction);
		}

		/* Τελική σύνδεση δωματίου */
		/**********************************************************************************************/
		/**********************************************************************************************/
		private function attachRoom(newRoom : Room, direction : uint) : Boolean {
			switch (direction) {
				case Room.NORTH:
					if (!exitNorth || !newRoom.exitSouth)
						return false;
					roomNorth = newRoom;
					newRoom.roomSouth = this;
					newRoom.setRowCol(row - 1, col);
					break;
				case Room.EAST:
					if (!exitEast || !newRoom.exitWest)
						return false;
					roomEast = newRoom;
					newRoom.roomWest = this;
					newRoom.setRowCol(row, col + 1);
					break;
				case Room.SOUTH:
					if (!exitSouth || !newRoom.exitNorth)
						return false;
					roomSouth = newRoom;
					newRoom.roomNorth = this;
					newRoom.setRowCol(row + 1, col);
					break;
				case Room.WEST:
					if (!exitWest || !newRoom.exitEast)
						return false;
					roomWest = newRoom;
					newRoom.roomEast = this;
					newRoom.setRowCol(row, col - 1);
					break;
			}

			game.map.push(newRoom);
			switch (newRoom.type) {
				default:
					break;
				case Room.AIRDUCT:
					game.airducts++;
					break;
				case Room.CAMERA:
					game.securitySystems++;
					break;
				case Room.LASER:
					game.securitySystems++;
					break;
			}

			// Ρυθμίσεις υπολοίπων εξόδων
			var adjacentRoom : Room;

			// NORTH
			if (newRoom.exitNorth && newRoom.roomNorth == null) {
				adjacentRoom = game.searchMap(newRoom.row - 1, newRoom.col);
				if (adjacentRoom != null) {
					if (adjacentRoom.exitSouth) {
						newRoom.roomNorth = adjacentRoom;
						adjacentRoom.roomSouth = newRoom;
					} else {
						newRoom.exitNorth = false;
					}
				}
			}

			// EAST
			if (newRoom.exitEast && newRoom.roomEast == null) {
				adjacentRoom = game.searchMap(newRoom.row, newRoom.col + 1);
				if (adjacentRoom != null) {
					if (adjacentRoom.exitWest) {
						newRoom.roomEast = adjacentRoom;
						adjacentRoom.roomWest = newRoom;
					} else {
						newRoom.exitEast = false;
					}
				}
			}

			// SOUTH
			if (newRoom.exitSouth && newRoom.roomSouth == null) {
				adjacentRoom = game.searchMap(newRoom.row + 1, newRoom.col);
				if (adjacentRoom != null) {
					if (adjacentRoom.exitNorth) {
						newRoom.roomSouth = adjacentRoom;
						adjacentRoom.roomNorth = newRoom;
					} else {
						newRoom.exitSouth = false;
					}
				}
			}

			// WEST
			if (newRoom.exitWest && newRoom.roomWest == null) {
				adjacentRoom = game.searchMap(newRoom.row, newRoom.col - 1);
				if (adjacentRoom != null) {
					if (adjacentRoom.exitEast) {
						newRoom.roomWest = adjacentRoom;
						adjacentRoom.roomEast = newRoom;
					} else {
						newRoom.exitWest = false;
					}
				}
			}

			newRoom.build();

			return true;
		}

		/* Ρύθμιση οπτικών πεδίων φρουρού /*
		/**********************************************************************************************/
		/**********************************************************************************************/
		public function clearLineOfSight() : void {
			for (var i : uint = 0; i < tiles.length; i++)
				tiles[i].lineOfSight = false;
		}

		public function setLineOfSight(num : uint, direction : uint) : void {
			var i : int;
			var j : int;
			var step : int = 0;
			var tile : Tile = tiles[num];

			switch (direction) {
				case NORTH:
					for (i = tile.row; i >= 0; i--) {
						for (j = tile.col - step; j <= tile.col + step; j++) {
							if (i * cols + j >= 0 && i * cols + j < tiles.length && tiles[i * cols + j].type != Tile.WALL)
								tiles[i * cols + j].lineOfSight = true;
						}
						step++;
					}
					break;
				case SOUTH:
					for (i = tile.row; i <= rows - 1; i++) {
						for (j = tile.col - step; j <= tile.col + step; j++) {
							if (i * cols + j >= 0 && i * cols + j < tiles.length && tiles[i * cols + j].type != Tile.WALL)
								tiles[i * cols + j].lineOfSight = true;
						}
						step++;
					}
					break;
				case WEST:
					for (j = tile.col; j >= 0; j--) {
						for (i = tile.row - step; i <= tile.row + step; i++) {
							if (i * cols + j >= 0 && i * cols + j < tiles.length && tiles[i * cols + j].type != Tile.WALL)
								tiles[i * cols + j].lineOfSight = true;
						}
						step++;
					}
					break;
				case EAST:
					for (j = tile.col; j <= cols - 1; j++) {
						for (i = tile.row - step; i <= tile.row + step; i++) {
							if (i * cols + j >= 0 && i * cols + j < tiles.length && tiles[i * cols + j].type != Tile.WALL)
								tiles[i * cols + j].lineOfSight = true;
						}
						step++;
					}
					break;
			}
		}

		public static function getNum(row : int, col : int) : int {
			if (row < 0 || row > rows - 1 || col < 0 || col > cols - 1)
				return -1;

			return cols * row + col;
		}

		public function setRowCol(r : int, c : int) : void {
			row = r;
			col = c;
		}

		public function searchByItemType(itemType : String) : Tile {
			for (var i : uint = 0; i < tiles.length; i++)
				if (tiles[i].item != null && tiles[i].item.name == itemType) {
					return tiles[i];
				}

			return null;
		}

		// Getters and Setters
		public function get exitNorth() : Boolean {
			return _exitNorth;
		}

		public function set exitNorth(exitNorth : Boolean) : void {
			this._exitNorth = exitNorth;
		}

		public function get exitSouth() : Boolean {
			return _exitSouth;
		}

		public function set exitSouth(exitSouth : Boolean) : void {
			this._exitSouth = exitSouth;
		}

		public function get exitWest() : Boolean {
			return _exitWest;
		}

		public function set exitWest(exitWest : Boolean) : void {
			this._exitWest = exitWest;
		}

		public function get exitEast() : Boolean {
			return _exitEast;
		}

		public function set exitEast(exitEast : Boolean) : void {
			this._exitEast = exitEast;
		}

		public function get roomNorth() : Room {
			return _roomNorth;
		}

		public function set roomNorth(roomNorth : Room) : void {
			this._roomNorth = roomNorth;
		}

		public function get roomSouth() : Room {
			return _roomSouth;
		}

		public function set roomSouth(roomSouth : Room) : void {
			this._roomSouth = roomSouth;
		}

		public function get roomWest() : Room {
			return _roomWest;
		}

		public function set roomWest(roomWest : Room) : void {
			this._roomWest = roomWest;
		}

		public function get roomEast() : Room {
			return _roomEast;
		}

		public function set roomEast(roomEast : Room) : void {
			this._roomEast = roomEast;
		}

		public function get type() : uint {
			return _type;
		}

		public function set type(type : uint) : void {
			_type = type;
		}

		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}

		public function get types() : Array {
			return _types;
		}

		public function set types(types : Array) : void {
			this._types = types;
		}

		public function get tiles() : Vector.<Tile> {
			return _tiles;
		}

		public function set tiles(tiles : Vector.<Tile>) : void {
			this._tiles = tiles;
		}

		public function get guard() : Guard {
			return _guard;
		}

		public function set guard(guard : Guard) : void {
			this._guard = guard;
		}

		public function get row() : int {
			return _row;
		}

		public function set row(row : int) : void {
			_row = row;
		}

		public function get col() : int {
			return _col;
		}

		public function set col(col : int) : void {
			_col = col;
		}
	}
}