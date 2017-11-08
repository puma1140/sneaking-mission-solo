package com.puma.classes
{
	import com.puma.general.AssetManager;
	import com.puma.general.Game;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * @author puma
	 */
	public class Player extends Sprite
	{
		public static const STANDING:uint = 0;
		public static const WALKING:uint = 1;
		public static const SHOOTING:uint = 2;
		
		private var _game:Game = Game.getInstance();
		private var _tile:Tile;
		private var _files:Boolean;
		private var _ammoBlips:uint;
		private var _spotted:Boolean;
		private var _mayLeave:Boolean = true;
		private var _status:uint;
		private var _direction:uint;
		
		// Προσωρινές βοηθητικές μεταβλητές
		private var sprite:Sprite;
		private var tf:TextField;
		
		// Γραφικά
		private var walkingBitmapData:BitmapData;
		private var shootingBitmapData:BitmapData;
		private var playerBitmapData:BitmapData;
		private var tilesetCols:uint = 0;
		
		// Animation variables
		private var playerAnimationRow:uint;
		private var playerAnimationCol:uint;
		
		public function Player()
		{
			status = STANDING;
			ammoBlips = 5;
			
			// Player bitmapdata
			playerBitmapData = new BitmapData(Tile.TILESIZE, Tile.TILESIZE, true, 0xFFFFFF);

			// Load tileset walking
			var tilesetWalking:Bitmap = new AssetManager.TilesetHeroWalking as Bitmap;
			walkingBitmapData = new BitmapData(tilesetWalking.width, tilesetWalking.height, true, 0xFFFFFF);
			walkingBitmapData.draw(tilesetWalking);
			
			tilesetCols = tilesetWalking.width / Tile.TILESIZE;
			
			// Load tileset shooting
			var tilesetShooting:Bitmap = new AssetManager.TilesetHeroShooting as Bitmap;
			shootingBitmapData = new BitmapData(tilesetShooting.width, tilesetShooting.height, true, 0xFFFFFF);
			shootingBitmapData.draw(tilesetShooting);
			
			playerAnimationCol = 0;
			playerAnimationRow = 0;
			
			selectAnimation(walkingBitmapData);
			var playerBitmap:Bitmap = new Bitmap(playerBitmapData);
			
			addChild(playerBitmap);
		}

		private function selectAnimation(sourceBitmapData:BitmapData):void
		{
			playerBitmapData.copyPixels(sourceBitmapData, new Rectangle(playerAnimationCol * Tile.TILESIZE, playerAnimationRow * Tile.TILESIZE, Tile.TILESIZE, Tile.TILESIZE), new Point());
		}
		
		public function animate():void
		{

			switch (status)
			{
				case STANDING:
					playerAnimationCol = 0;
					selectAnimation(walkingBitmapData);
					break;
				
				case SHOOTING:
					selectAnimation(shootingBitmapData);
					
					if (playerAnimationCol < tilesetCols - 1) {
						playerAnimationCol++;
					}
					break;
				
				case WALKING:
					selectAnimation(walkingBitmapData);
					break;
			}
		}
		
		public function move(targetDirection:uint, deltaTime:Number, percent:Number = 0.1):void
		{
			playerAnimationCol == tilesetCols - 1 ? playerAnimationCol = 0 : playerAnimationCol++;
			direction = targetDirection;
			
			status = WALKING;
			
			switch (direction)
			{
				case Room.NORTH: 
					y -= deltaTime * percent;
					break;
				case Room.SOUTH: 
					y += deltaTime * percent;
					break;
				case Room.WEST: 
					x -= deltaTime * percent;
					break;
				case Room.EAST: 
					x += deltaTime * percent;
					break;
			}

		}
		
		/* Ενέργειες του παίκτη */ /**********************************************************************************************/ /**********************************************************************************************/
		public function changeRoom():Boolean
		{
			// trace("Ο παίκτης αλλάζει δωμάτιο.");

			var newRoom:Room;
			var newPosition:uint;
			
			if (tile.row == 0)
			{
				direction = Room.NORTH;
				newRoom = tile.room.roomNorth;
				newPosition = (Room.rows - 1) * Room.cols + tile.col;
			}
			else if (tile.row == Room.rows - 1)
			{
				direction = Room.SOUTH;
				newRoom = tile.room.roomSouth;
				newPosition = 0 * Room.cols + tile.col;
			}
			else if (tile.col == 0)
			{
				direction = Room.WEST;
				newRoom = tile.room.roomWest;
				newPosition = tile.row * Room.cols + Room.cols - 1;
			}
			else if (tile.col == Room.cols - 1)
			{
				direction = Room.EAST;
				newRoom = tile.room.roomEast;
				newPosition = tile.row * Room.cols + 0;
			}
			
			if (newRoom == null)
			{
				if (game.unexploredRooms.length)
				{
					newRoom = game.unexploredRooms.pop();
					tile.room.connect(newRoom, direction);
					
					game.currentRoom = newRoom;
					tile = newRoom.tiles[newPosition];
					
					// trace("Απομένουν " + game.unexploredRooms.length + " δωμάτια.");
					return true;
				}
				else
				{
					game.bubble.setText(game.language.getValue("deadend"));
					return false;
				}
			}
			else
			{
				game.currentRoom = newRoom;
				tile = newRoom.tiles[newPosition];
				return true;
			}
		}
		
		public function enableAlertMode(value:Boolean = true):Boolean
		{
			if (value && !game.alert)
			{
				// game.bubble.setText(("'Ενεργοποιήθηκε ο συναγερμός! Πρέπει να βρω κάπου να κρυφτώ πριν με πιάσουν!'"));
				
				game.alert = true;
				for (var i:uint = 0; i < game.guards.length; i++)
					game.guards[i].alert = true;
				
				return true;
			}
			else if (game.alert && !value)
			{
				// game.bubble.setText("Ο συναγερμός απενεργοποιήθηκε.");
				
				game.alert = false;
				game.alertTokens = 0;
				game.infoBar.update();
				
				for (i = 0; i < game.guards.length; i++)
					game.guards[i].alert = false;
				if (files)
					game.bubble.setText(game.language.getValue("disableAlertWithFiles"), Bubble.HERO);
				
				return true;
			}
			
			return false;
		}
		
		public function hide():void
		{
			if (enableAlertMode(false))
				game.bubble.setText(game.language.getValue("hide"), Bubble.DESCRIPTION);
		}
		
		public function disableSecuritySystems():void
		{
			if (game.securitySystems)
				game.bubble.setText(game.language.getValue("disableSecuritySystems"), Bubble.DESCRIPTION);
			
			for (var i:uint = 0; i < game.map.length; i++)
				if (game.map[i].type == Room.CAMERA || game.map[i].type == Room.LASER)
				{
					game.map[i].clearItems();
					game.securitySystems--;
				}
		}
		
		public function fight():void
		{
			// trace("Κάνεις επίθεση στον " + tile.guard);
			var rand:uint = game.randomNumbers(0, 1);
			
			if (rand == 0)
			{
				if (game.alert)
					game.bubble.setText(game.language.getValue("fightAndLose"), Bubble.DESCRIPTION);
				else
					game.bubble.setText(game.language.getValue("fightAndLoseEnableAlert"), Bubble.DESCRIPTION);
				
				if (game.alert)
				{
					game.alertTokens++;
					game.infoBar.update();
				}
				enableAlertMode();
			}
			else
			{
				game.bubble.setText(game.language.getValue("fightAndWin"), Bubble.DESCRIPTION);
				tile.guard = null;
				tile.room.guard = null;
				tile.room.type = Room.EMPTY;
				tile.room.clearLineOfSight();
			}
			
			mayLeave = true;
		}
		
		public function useGun(tile:Tile):void
		{
			mayLeave = true;
			if (this._tile == tile)
				game.bubble.setText(game.language.getValue("shootClose"), Bubble.DESCRIPTION);
			else
				game.bubble.setText(game.language.getValue("shootFar"), Bubble.DESCRIPTION);
			tile.guard = null;
			tile.room.guard = null;
			tile.room.type = Room.EMPTY;
			tile.room.clearLineOfSight();
			ammoBlips--;
			game.infoBar.update();
		}
		
		public function getFiles():void
		{
			files = true;
			tile.item = null;
			tile.room.type = Room.EMPTY;
			
			if (!game.alert)
				game.bubble.setText(game.language.getValue("getFilesAndWin"));
			else
				game.bubble.setText(game.language.getValue("getFilesButAlert"));
		}
		
		public function loadAmmo():void
		{
			ammoBlips += 3;
			game.bubble.setText(game.language.getValue("getAmmo"), Bubble.DESCRIPTION);
			tile.item = null;
			tile.room.type = Room.EMPTY;
			game.infoBar.update();
		}
		
		// Getters and Setters
		/**********************************************************************************************/ /**********************************************************************************************/
		public function get game():Game
		{
			return _game;
		}
		
		public function set game(game:Game):void
		{
			this._game = game;
		}
		
		public function get tile():Tile
		{
			return _tile;
		}
		
		public function set tile(tile:Tile):void
		{
			// Αν είναι το ίδιο tile με πριν, κάνουμε return
			if (this._tile == tile)
				return;
			
			// Μηδενίζουμε το προηγούμενο
			if (this._tile != null)
				this._tile.player = null;
			
			this._tile = tile;
			tile.player = this;
		}
		
		public function get files():Boolean
		{
			return _files;
		}
		
		public function set files(files:Boolean):void
		{
			_files = files;
		}
		
		public function get ammoBlips():uint
		{
			return _ammoBlips;
		}
		
		public function set ammoBlips(ammoBlips:uint):void
		{
			this._ammoBlips = ammoBlips;
		}
		
		public function get spotted():Boolean
		{
			return _spotted;
		}
		
		public function set spotted(spotted:Boolean):void
		{
			_spotted = spotted;
		}
		
		public function get mayLeave():Boolean
		{
			return _mayLeave;
		}
		
		public function set mayLeave(mayLeave:Boolean):void
		{
			_mayLeave = mayLeave;
		}
		
		public function get status():uint 
		{
			return _status;
		}
		
		public function set status(value:uint):void 
		{
			_status = value;
		}
		
		public function get direction():uint
		{
			return _direction;
		}
		
		public function set direction(value:uint):void
		{
			_direction = value;

			switch(value)
			{
				case Room.NORTH:
					playerAnimationRow = 0;
					break;
				
				case Room.SOUTH:
					playerAnimationRow = 1;
					break;
				
				case Room.EAST:
					playerAnimationRow = 2;
					break;
				
				case Room.WEST:
					playerAnimationRow = 3;
					break;
			}
			
		}
	}
}
