package com.puma.classes {
	import flash.text.TextField;

	import com.puma.general.Game;

	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class MapTile extends Sprite {
		public static const TILESIZE : uint = 64;
		private var _game : Game = Game.getInstance();
		private var _room : Room;
		private var _num : uint = 0;
		private var sprite : Sprite;
		private var tf : TextField;

		public function MapTile() {
			mouseChildren = false;
			tf = new TextField();
		}

		// Getters and Setters
		public function get room() : Room {
			return _room;
		}

		public function set room(room : Room) : void {
			this._room = room;

			sprite = new Sprite();
			if (game.player.tile.room && game.player.tile.room == room)
				sprite.graphics.lineStyle(2.0, 0xFF0000);
			else
				sprite.graphics.lineStyle(2.0, 0x000000);
			sprite.graphics.beginFill(0xDEDEDE);
			sprite.graphics.drawRect(0, 0, TILESIZE, TILESIZE);
			sprite.graphics.endFill();

			if (room) {
				var rect:Sprite = new Sprite();
				rect.graphics.lineStyle(1.0, 0x000000);
				var rectTF:TextField = new TextField(); 
				
				// Δημιουργία εξόδων
				sprite.graphics.lineStyle(2.0, 0xDEDEDE);
				if (room.exitNorth)
					sprite.graphics.drawRect(22, 0, 20, 1);
				if (room.exitSouth)
					sprite.graphics.drawRect(22, TILESIZE, 20, 1);
				if (room.exitWest)
					sprite.graphics.drawRect(0, 22, 1, 20);
				if (room.exitEast)
					sprite.graphics.drawRect(TILESIZE, 22, 1, 20);

				sprite.graphics.lineStyle(2.0, 0x000000);
				
				// Δημιουργία φρουρού
				if (room.guard) {
					var circle:Sprite = new Sprite();
					circle.graphics.lineStyle(1.0, 0x000000);
					circle.graphics.drawCircle(0, 0, 15);
					circle.x = TILESIZE / 2;
					circle.y = circle.x;
					
					if (room.guard.sleeping) {
						var guardTF:TextField = new TextField();
						guardTF.width = circle.width;
						guardTF.height = circle.height;
						guardTF.selectable = false;
						guardTF.x = -circle.width / 2;
						guardTF.y = -circle.height / 2;

						if (game.alert)
							guardTF.text = "Alert";
						else
							guardTF.text = "zzZzZz";

						circle.addChild(guardTF);
					} else {
						
						if (room.guard.faceDirection == Room.NORTH)
							rect.graphics.drawRect(-4, -circle.height / 2 + 4, 8, 4);
						else if (room.guard.faceDirection == Room.SOUTH)
							rect.graphics.drawRect(-4, circle.height / 2 - 8, 8, 4);
						else if (room.guard.faceDirection == Room.WEST)
							rect.graphics.drawRect(-circle.width / 2 + 4, -4, 4, 8);
						else if (room.guard.faceDirection == Room.EAST)
							rect.graphics.drawRect(circle.width / 2 - 8, -4, 4, 8);
						
						circle.addChild(rect);
					}
					
					sprite.addChild(circle);
				} else if (room.type != Room.EMPTY) {
					rect.graphics.drawRect(0, 0, 40, 20);
					rectTF.selectable = false;
					rectTF.width = rect.width;
					rectTF.height = rect.height;
					if (room.type == Room.ENTRANCE)
						rectTF.text = "entrance";
					else if (room.type == Room.BOXES)
						rectTF.text = "boxes";
					else if (room.type == Room.CAMERA)
						rectTF.text = "camera";
					else if (room.type == Room.AIRDUCT)
						rectTF.text = "airduct";
					else if (room.type == Room.CIRCUIT)
						rectTF.text = "circuit";
					else if (room.type == Room.FILES)
						rectTF.text = "files";
					else if (room.type == Room.LASER)
						rectTF.text = "laser";
					else if (room.type == Room.LOCKERS)
						rectTF.text = "lockers";
					else if (room.type == Room.WEAPON)
						rectTF.text = "weapon";
					
					rect.x = (TILESIZE - rect.width) / 2;
					rect.y = (TILESIZE - rect.height) / 2;
					
					rect.addChild(rectTF);
					sprite.addChild(rect);
				}
			}

			tf.width = TILESIZE;
			tf.height = TILESIZE;
			tf.selectable = false;

			sprite.addChild(tf);
			addChild(sprite);
		}

		// Getters and Setters
		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}

		public function get num() : uint {
			return _num;
		}

		public function set num(num : uint) : void {
			this._num = num;
			tf.text = num.toString();
		}
	}
}
