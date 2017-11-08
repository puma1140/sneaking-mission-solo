package com.puma.classes {
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
	public class Guard extends Sprite {
		private var _game : Game = Game.getInstance();
		
		private var _sleeping : Boolean;
		private var _arrowDirection : uint;
		private var _faceDirection : uint;
		private var _redSquare:uint;
		private var _alert:Boolean;
		private var _status:uint;
		
		// Προσωρινές βοηθητικές μεταβλητές
		private var sprite:Sprite;
		private var tf:TextField;
		private var red:Sprite;
		private var face:Sprite;
		private var arrow:Sprite;
		
		// Γραφικά
		private var fightingBitmapData:BitmapData;
		private var guardBitmapData:BitmapData;
		private var tilesetCols:uint = 0;
		
		// Animation
		private var animationRow:uint;
		private var animationCol:uint;

		public function Guard(isSleeping:Boolean = false, arrowDir:uint = 0, faceDir:uint = 0, redSq:uint = 0) {
			
			// Guard bitmapdata
			guardBitmapData = new BitmapData(Tile.TILESIZE, Tile.TILESIZE, true, 0xFFFFFF);
			
			// Load tileset fighting (and standing)
			var tilesetFighting:Bitmap = new AssetManager.TilesetGuardFighting as Bitmap;
			fightingBitmapData = new BitmapData(tilesetFighting.width, tilesetFighting.height, true, 0xFFFFFF);
			fightingBitmapData.draw(tilesetFighting);
			
			tilesetCols = tilesetFighting.width / Tile.TILESIZE;
			

			var guardBitmap:Bitmap = new Bitmap(guardBitmapData);
			addChild(guardBitmap);
			
			sprite = new Sprite();
			sprite.mouseEnabled = false;
			sprite.mouseChildren = false;
			sprite.graphics.lineStyle(1.0, 0x000000);
			sprite.graphics.drawCircle(20, 20, 20);
			
			tf = new TextField();
			tf.selectable = false;
			tf.width = sprite.width;
			tf.height = sprite.height;
			
			red = new Sprite();
			red.graphics.beginFill(0xFF0000);
			red.graphics.drawRect(0, 0, 5, 5);
			red.graphics.endFill();
			
			face = new Sprite();
			face.graphics.lineStyle(1.0, 0x000000);
			face.graphics.drawRect(0, 0, 14, 10);
			
			arrow = new Sprite();
			arrow.graphics.lineStyle(2.0, 0x0000FF);
			arrow.graphics.lineTo(0, 12);
			arrow.graphics.lineTo(0, -12);
			arrow.graphics.lineTo(-4, -12);
			arrow.graphics.lineTo(4, -12);
			arrow.x = (sprite.width - arrow.width) / 2 + 4;
			arrow.y = (sprite.height - arrow.height) / 2 + 12;
			
			sprite.addChild(red);
			sprite.addChild(face);
			sprite.addChild(arrow);
			sprite.addChild(tf);
			addChild(sprite);
		
			sleeping = isSleeping;
			arrowDirection = arrowDir;
			faceDirection = faceDir;
			redSquare = redSq;
			game.guards.push(this);
		}
		
		private function selectAnimation(sourceBitmapData:BitmapData):void
		{
			guardBitmapData.copyPixels(sourceBitmapData, new Rectangle(animationCol * Tile.TILESIZE, animationRow * Tile.TILESIZE, Tile.TILESIZE, Tile.TILESIZE), new Point());
		}
		
		public function rotate():void {
			if (redSquare > 0)
				redSquare < 4 ? redSquare++: redSquare = 1;
			
			if (faceDirection > 0)
				faceDirection < 4 ? faceDirection++: faceDirection = 1;
				
			if (arrowDirection > 0)
				arrowDirection < 4 ? arrowDirection++: arrowDirection = 1;
		}

		// Getters and Setters
		public function get sleeping() : Boolean {
			return _sleeping;
		}

		public function set sleeping(sleeping : Boolean) : void {
			this._sleeping = sleeping;
			
			if (sleeping)
				tf.text = "zzz...";
			else
				tf.text = "Guard";
		}

		public function get arrowDirection() : uint {
			return _arrowDirection;
		}

		public function set arrowDirection(arrowDirection : uint) : void {
			this._arrowDirection = arrowDirection;
			if (arrowDirection == 0) {
				arrow.visible = false;
				return;
			}
			
			arrow.visible = true;
			switch(arrowDirection) {		
				case Room.NORTH:
					arrow.rotation = 0;
				break;
				
				case Room.SOUTH:
					arrow.rotation = 180;
				break;
				
				case Room.WEST:
					arrow.rotation = 270;
				break;
				
				case Room.EAST:
					arrow.rotation = 90;
				break;
			}
		}

		public function get faceDirection() : uint {
			return _faceDirection;
		}

		public function set faceDirection(faceDirection : uint) : void {
			this._faceDirection = faceDirection;
			if (faceDirection == 0) {
				face.visible = false;
				return;
			}

			face.visible = true;
			switch(faceDirection) {
				case Room.NORTH:
					face.x = (width - face.width ) / 2;
					face.y = 0;
					
					animationRow = 0;
				break;
				
				case Room.SOUTH:
					face.x = (width - face.width ) / 2;
					face.y = height - face.height;
					
					animationRow = 1;
				break;
				
				case Room.WEST:
					face.x = 0;
					face.y = (height - face.height ) / 2;
					
					animationRow = 3;
				break;
				
				case Room.EAST:
					face.x = width - face.width;
					face.y = (height - face.height ) / 2;
					
					animationRow = 2;
				break;
			}
			
			selectAnimation(fightingBitmapData);
		}

		public function get redSquare() : uint {
			return _redSquare;
		}

		public function set redSquare(redSquare : uint) : void {
			_redSquare = redSquare;
			if (redSquare == 0) {
				red.visible = false;
				return;
			}
			
			red.visible = true;
			switch (redSquare) {
				case Room.NORTH:
					red.x = (width - red.width ) / 2;
					red.y = 0;
				break;
				
				case Room.SOUTH:
					red.x = (width - red.width ) / 2;
					red.y = height - red.height;
				break;
				
				case Room.WEST:
					red.x = 0;
					red.y = (height - red.height ) / 2;
				break;
				
				case Room.EAST:
					red.x = width - red.width;
					red.y = (height - red.height ) / 2;
				break;
				
				default:
					red.visible = false;
				break;
			}
		}

		public function get alert() : Boolean {
			return _alert;
		}

		public function set alert(alert : Boolean) : void {
			_alert = alert;
			
			if (alert)
				tf.text = "alert!";
			else {
				if (sleeping)
					tf.text = "zzz...";
				else
					tf.text = "Guard";
			}
		}

		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}

		public function get status():uint
		{
			return _status;
		}

		public function set status(value:uint):void
		{
			_status = value;
		}

	}
}
