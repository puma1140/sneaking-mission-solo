package com.puma.classes {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @author puma
	 */
	public class Tile extends Sprite
	{
		public static const TILESIZE:int = 64;
		public static const FLOOR:uint = 0;
		public static const WALL:uint = 1;
		public static const EXIT:uint = 2;

		private var _type:uint; // Το είδος του tile
		
		private var _row:uint;
		private var _col:uint;
		private var _num:uint;
		private var _room:Room; // Σε ποιο δωμάτιο βρίσκεται το tile
		
		private var _item:Item; // Αν υπάρχει αντικείμενο πάνω στο tile
		private var _guard:Guard; // Αν υπάρχει φρουρός στο tile
		private var _player:Player; // Αν είναι ο παίκτης πάνω στο tile
		private var _lineOfSight:Boolean; // Αν είναι στο οπτικό πεδίο του φρουρού
		
		private var tf:TextField;
		private var spriteLineOfSight:Sprite;
		
		// Μεταβλητές για το pathfinding
		private var _scoreG:int;
		private var _scoreF:int;
		private var _cameFrom:Tile;
		
		public function Tile()
		{
			tf = new TextField();
			tf.width = TILESIZE;
			tf.height = TILESIZE;
			tf.selectable = false;
			tf.mouseEnabled = false;
		}
		
		public function placePlayer():void
		{
			if (player)
			{
				// player.x = x + TILESIZE / 2;
				// player.y = y + TILESIZE / 2;
				player.x = x;
				player.y = y;
			}
		}
		
		// Getters and Setters
		public function get type():uint
		{
			return _type;
		}
		
		public function set type(type:uint):void
		{
			this._type = type;
			
			var color:uint = 0xFFFFFF;
			switch (type)
			{
				case WALL: 
					color = 0x999999;
					break;
				case EXIT: 
					color = 0xDEDEDE;
					break;
			}
			
			/*
			var sprite:Sprite = new Sprite();
			sprite.mouseEnabled = false;
			sprite.graphics.lineStyle(1.0, 0x000000);
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRect(0, 0, TILESIZE, TILESIZE);
			sprite.graphics.endFill();
			
			sprite.addChild(tf);
			sprite.visible = false; // to do, check it!
			addChild(sprite);
			*/
		}
		
		public function get row():uint
		{
			return _row;
		}
		
		public function set row(row:uint):void
		{
			this._row = row;
		}
		
		public function get col():uint
		{
			return _col;
		}
		
		public function set col(col:uint):void
		{
			this._col = col;
		}
		
		public function get num():uint
		{
			return _num;
		}
		
		public function set num(num:uint):void
		{
			this._num = num;
			tf.text = num.toString();
			// tf.text = row.toString() + ", " + col.toString();
		}
		
		public function get item():Item
		{
			return _item;
		}
		
		public function set item(item:Item):void
		{
			if (this._item != null)
				removeChild(this._item);
			
			this._item = item;
			
			if (item != null)
			{
				item.x = (TILESIZE - item.width) / 2;
				item.y = (TILESIZE - item.height) / 2;
				addChild(item);
			}
		}
		
		public function get guard():Guard
		{
			return _guard;
		}
		
		public function set guard(guard:Guard):void
		{
			if (this._guard != null)
				removeChild(this._guard);
			
			this._guard = guard;
			
			if (guard != null)
			{
				room.setLineOfSight(num, guard.faceDirection);
				
				guard.x = (TILESIZE - guard.width) / 2;
				guard.y = (TILESIZE - guard.height) / 2;
				addChild(guard);
			}
		}
		
		public function get player():Player
		{
			return _player;
		}
		
		// Setter only by player!
		public function set player(player:Player):void
		{
			this._player = player;
			// if (player)
			// placePlayer();
		}
		
		public function get room():Room
		{
			return _room;
		}
		
		public function set room(room:Room):void
		{
			this._room = room;
		}
		
		public function get lineOfSight():Boolean
		{
			return _lineOfSight;
		}
		
		public function set lineOfSight(lineOfSight:Boolean):void
		{
			this._lineOfSight = lineOfSight;
			
			if (lineOfSight)
			{
				spriteLineOfSight = new Sprite();
				spriteLineOfSight.graphics.beginFill(0xFFFF00);
				spriteLineOfSight.graphics.drawRect(0, 0, width, height);
				spriteLineOfSight.graphics.endFill();
				spriteLineOfSight.alpha = 0.2;
				addChild(spriteLineOfSight);
			}
			else if (spriteLineOfSight)
			{
				removeChild(spriteLineOfSight);
				spriteLineOfSight = null;
			}
		}
		
		public function get scoreG():int
		{
			return _scoreG;
		}
		
		public function set scoreG(scoreG:int):void
		{
			this._scoreG = scoreG;
		}
		
		public function get scoreF():int
		{
			return _scoreF;
		}
		
		public function set scoreF(scoreF:int):void
		{
			_scoreF = scoreF;
		}
		
		public function get cameFrom():Tile
		{
			return _cameFrom;
		}
		
		public function set cameFrom(cameFrom:Tile):void
		{
			_cameFrom = cameFrom;
		}
	}
}