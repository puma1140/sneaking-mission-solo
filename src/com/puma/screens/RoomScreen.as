package com.puma.screens {
	import com.puma.classes.Action;
	import com.puma.classes.Actionbox;
	import com.puma.classes.Bubble;
	import com.puma.classes.Bullet;
	import com.puma.classes.InfoBar;
	import com.puma.classes.Item;
	import com.puma.classes.Pathfinder;
	import com.puma.classes.Player;
	import com.puma.classes.Room;
	import com.puma.classes.Tile;
	import com.puma.classes.infobar.MapIcon;
	import com.puma.general.Language;
	import com.puma.general.Screen;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * @author puma
	 */
	public class RoomScreen extends Screen
	{
		private var room:Room;
		private var player:Player;
		private var bullet:Bullet;
		private var initialTile:Tile;
		private var actionbox:Actionbox;
		private var infoBar:InfoBar;
		private var bubble:Bubble;
		private var language:Language;
		
		// Χρόνοι για το game loop
		private var startTime:Number;
		private var deltaTime:Number;
		private var path:Vector.<Tile>;
		private var pathfinder:Pathfinder;
		
		// Προσωρινές μεταβλητές
		private var restart:Sprite;
		private var restartText:TextField;
		
		public function RoomScreen()
		{
			super();
			
			alpha = 0.0;
			language = game.language;
			player = game.player;
			player.tile.placePlayer();
			bullet = new Bullet();
			room = game.currentRoom;
			actionbox = new Actionbox();
			actionbox.visible = false;
			infoBar = game.infoBar;
			infoBar.update();
			bubble = game.bubble;
			bubble.x = (room.width - bubble.width) / 2;
			bubble.y = 100;
			bubble.setText("");
			path = new Vector.<Tile>();
			pathfinder = new Pathfinder(room);
			/*****************/
			restart = new Sprite();
			restart.graphics.beginFill(0x0000FF);
			restart.graphics.drawRect(0, 0, 40, 40);
			restart.graphics.endFill();
			restart.x = 12;
			restart.y = game.stage.stageHeight - restart.height - 12;
			restart.name = "restart";
			restart.mouseChildren = false;
			
			restartText = new TextField();
			restartText.width = restart.width;
			restartText.height = restart.height;
			restartText.selectable = false;
			restartText.text = "Restart";
			restart.addChild(restartText);
			/*****************/
			
			addChild(room);
			addChild(player);
			addChild(bullet);
			addChild(actionbox);
			addChild(restart);
			addChild(infoBar);
			addChild(bubble);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			initialTile = player.tile;
			
			if (!(game.previousScreen is RoomScreen))
				return;
			
			player.spotted = false;
			player.mayLeave = true;
			
			// Αν βρεθούμε σε tile που παρακολουθείται από φρουρό
			if (room.type == Room.GUARD)
			{
				if (!room.guard.sleeping)
					player.mayLeave = false;
				
				if (player.tile.lineOfSight || (room.guard.sleeping && game.alert))
				{
					player.mayLeave = false;
					player.spotted = true;
					bubble.setText(language.getValue("still"), Bubble.ENEMY);
					
					if (game.alert)
						game.alertTokens++;
				}
			}
			else if (room.type != Room.CAMERA && room.type != Room.LASER && room.type != Room.ENTRANCE && room.type != Room.BOXES && room.type != Room.LOCKERS && room.type != Room.AIRDUCT)
			{
				if (game.alert)
					game.alertTokens++;
			}
			
			infoBar.update();
		}
		
		private function onEnterFrame(e:Event):void
		{
			alpha += 0.1;
			if (alpha >= 1.0)
				enableListeners();
		}
		
		// Υλοποίηση με κίνηση
		/**********************************************************************/
		private function onClick(e:MouseEvent):void
		{
			var target:Object = e.target;
			bubble.setText("");

			var num:int = -1;
			var tile:Tile;
			if (mouseX > 0 && mouseY > 0)
				num = Room.getNum(mouseY / Tile.TILESIZE, mouseX / Tile.TILESIZE);
			
			if (num == -1)
				return;
			// Αν το actionbox είναι ανοιχτό, κλείστο και κάνε return
			if (actionbox.visible)
			{
				actionbox.visible = false;
				if (target is Action)
					interactWithActionBox(Action(target));
				return;
			}

			// Αν ο παίκτης είναι σε κίνηση, δεν υπολογίζεται το κλικ
			if (path && path.length)
				return;
			
			// Αν κάνουμε κλικ στο restart
			if (target is Sprite && Sprite(target).name == "restart")
			{
				disableListeners();
				game.init();
				new RoomScreen().addToStage();
			}
			
			// Αν κάνουμε κλικ στο χάρτη
			if (target is MapIcon)
			{
				showMap();
				return;
			}
			
			tile = room.tiles[num];
			
			// Αν πρέπει να κρυφτούμε, δεν μπορούμε να φύγουμε
			if (tile.type == Tile.EXIT)
				if (game.alert && (room.type == Room.ENTRANCE || room.type == Room.BOXES || room.type == Room.AIRDUCT || room.type == Room.LOCKERS))
				{
					bubble.setText(language.getValue("betterHide"));
					return;
				}
			
			// Επιστρέφουμε στο προηγούμενο δωμάτιο όταν μας επιτρέπεται
			if (player.tile.type == Tile.EXIT && !player.spotted && tile.type == Tile.EXIT && ((player.tile.row == tile.row && Math.abs(player.tile.col - tile.col) <= 1) || (player.tile.col == tile.col && Math.abs(player.tile.row - tile.row) <= 1)))
			{
				changeRoom();
				return;
			}
			
			// path = pathfinder.run(player.tile, tile);
			if (tile.guard)
				if (player.ammoBlips > 0)
				{
					actionbox.clearActions();
					actionbox.actions.push(new Action(Action.FIGHT), new Action(Action.USE_GUN));
					createActionbox(tile);
				}
				else
				{
					if (player.tile == tile)
						player.fight();
					else
						walkTo(tile);
				}
			else
				checkMovement(tile);
		}
		
		private function checkMovement(tile:Tile):void
		{
			if (player.mayLeave)
			{
				if (tile.item && tile.item.name == Item.AIR_DUCT)
				{
					if (game.airducts > 1)
					{
						actionbox.clearActions();
						actionbox.actions.push(new Action(Action.HIDE), new Action(Action.CHANGE_ROOM));
						createActionbox(tile);
					}
					else
					{
						walkTo(tile);
					}
				}
				else
				{
					walkTo(tile);
				}
				return;
			}
			
			// Αν μας είδε ο φρουρός
			if (player.spotted)
			{
				bubble.setText(language.getValue("mustAttack"));
				return;
			}
			else
			{
				bubble.setText(language.getValue("attackOrLeave"));
				return;
			}
		}
		
		private function interactWithActionBox(action:Action):void
		{
			actionbox.currentAction = action;
			
			switch (action.type)
			{
				case Action.HIDE: 
					if (player.tile == actionbox.tile)
						interactWithTile();
					else
						walkTo(actionbox.tile);
					break;
				case Action.CHANGE_ROOM: 
					if (player.tile == actionbox.tile)
						interactWithTile();
					else
						walkTo(actionbox.tile);
					break;
				case Action.FIGHT: 
					if (player.tile == actionbox.tile)
						interactWithTile();
					else
						walkTo(actionbox.tile);
					break;
				case Action.USE_GUN: 
					// player.useGun(actionbox.tile);
					useGun(actionbox.tile);
					break;
			}
			
			actionbox.visible = false;
		}
		
		/**********************/
		private function walkTo(tile:Tile):void
		{
			if (path && path.length)
				return;
			
			path = pathfinder.run(player.tile, tile);
		}
		
		private function interactWithTile():void
		{
			var tile:Tile = player.tile;
			// Αν είναι έξοδος
			if (tile.type == Tile.EXIT && path.length == 0)
			{
				changeRoom();
				return;
			}
			
			// Αν είναι φρουρός
			if (tile.guard)
				player.fight();
			
			// Αλληλεπίδραση με αντικείμενα
			if (tile.item)
			{
				switch (tile.item.name)
				{
					case Item.LASER: 
						room.clearItems();
						if (!game.alert)
							bubble.setText(language.getValue("laserAlert"), Bubble.DESCRIPTION);
						else
						{
							bubble.setText(language.getValue("laserAlreadyAlert"), Bubble.DESCRIPTION);
							game.alertTokens += 2;
							infoBar.update();
						}
						game.securitySystems--;
						stopPlayer();
						player.enableAlertMode();
						break;
					case Item.CAMERA_LINEOFSIGHT: 
						room.clearItems();
						if (!game.alert)
							bubble.setText(language.getValue("cameraAlert"), Bubble.DESCRIPTION);
						else
						{
							bubble.setText(language.getValue("cameraAlreadyAlert"), Bubble.DESCRIPTION);
							game.alertTokens += 2;
							infoBar.update();
						}
						game.securitySystems--;
						stopPlayer();
						player.enableAlertMode();
						break;
					case Item.BOX: 
						player.hide();
						break;
					case Item.LOCKER: 
						player.hide();
						break;
					case Item.CIRCUIT: 
						player.disableSecuritySystems();
						break;
					case Item.AIR_DUCT: 
						player.hide();
						if (actionbox.currentAction && actionbox.currentAction.type == Action.CHANGE_ROOM)
						{
							disableListeners();
							new MapScreen().addToStage();
						}
						break;
					case Item.ENTRANCE: 
						player.hide();
						break;
					case Item.WEAPON: 
						player.loadAmmo();
						break;
					case Item.FILES: 
						player.getFiles();
						break;
				}
			}
		}
		
		// Υλοποίηση χωρίς κίνηση
		/*********************************************************************************/
		private function onClickOld(e:MouseEvent):void
		{
			var target:Object = e.target;
			// trace(target);
			var row:int = mouseY / Tile.TILESIZE;
			var col:int = mouseX / Tile.TILESIZE;
			var num:int = Room.getNum(row, col);
			var tile:Tile;
			if (num >= 0 && num < room.tiles.length)
				tile = room.tiles[num];
			
			bubble.setText("");
			/**********************************************************/
			
			if (target is MapIcon)
			{
				showMap();
				return;
			}
			
			/**********************************************************/
			
			if (actionbox.visible == true)
			{
				if (target is Action)
				{
					var action:Action = target as Action;
					
					switch (action.type)
					{
						case Action.FIGHT: 
							if (actionbox.tile.guard)
							{
								player.tile = actionbox.tile;
								player.fight();
							}
							break;
						case Action.USE_GUN: 
							if (actionbox.tile.guard)
								player.useGun(actionbox.tile);
							break;
						case Action.HIDE: 
							player.hide();
							break;
						case Action.CHANGE_ROOM: 
							player.hide();
							disableListeners();
							new MapScreen().addToStage();
							break;
					}
				}
				
				actionbox.visible = false;
				return;
			}
			
			/**********************************************************/
			if (tile == null)
				return;
			
			if (room.type == Room.GUARD && room.guard)
				if ((room.guard.sleeping && game.alert) || !room.guard.sleeping)
					checkGuardCase(tile);
				else
					checkOthersCase(tile);
			else
				checkOthersCase(tile);
		}
		
		private function checkGuardCase(tile:Tile):void
		{
			if (tile.type == Tile.WALL)
				return;
			
			// Έξοδος - Έλεγχος για αλλαγή δωματίου
			if (tile.type == Tile.EXIT)
			{
				if (player.mayLeave)
				{
					player.tile = tile;
					changeRoom();
						// trace("Ο παίκτης μπορεί να φύγει από οποιαδήποτε έξοδο.");
				}
				else if (player.spotted)
				{
					bubble.setText("'Ο φρουρός με είδε. Καλύτερα να του επιτεθώ άμεσα!'");
				}
				else if ((initialTile.row == tile.row && Math.abs(initialTile.col - tile.col) <= 1) || (initialTile.col == tile.col && Math.abs(initialTile.row - tile.row) <= 1))
				{
					player.tile = tile;
					changeRoom();
						// trace("Ο παίκτης μπορεί να φύγει μόνο από την έξοδο από την οποία ήρθε εκτός αν επιτεθεί.");
				}
				else
				{
					bubble.setText("'Ο φρουρός δε με έχει δει. Καλύτερα είτε να επιστρέψω στο προηγούμενο δωμάτιο είτε να του επιτεθώ άμεσα!'");
				}
			}
			else if (tile.guard)
			{
				if (player.ammoBlips)
				{
					actionbox.clearActions();
					actionbox.actions.push(new Action(Action.FIGHT), new Action(Action.USE_GUN));
					createActionbox(tile);
				}
				else
				{
					player.tile = tile;
					player.fight();
				}
			}
			else
			{
				if (!player.mayLeave)
					if (player.spotted)
						bubble.setText("'Ο φρουρός με είδε. Καλύτερα να του επιτεθώ άμεσα!'");
					else
						bubble.setText("'Ο φρουρός δε με έχει δει. Καλύτερα είτε να επιστρέψω στο προηγούμενο δωμάτιο είτε να του επιτεθώ άμεσα!'");
				else
					player.tile = tile;
			}
		}
		
		private function checkOthersCase(tile:Tile):void
		{
			if (tile.type == Tile.WALL)
				return;
			
			// Αλληλεπίδραση με φρουρό
			if (tile.guard)
			{
				if (player.ammoBlips)
				{
					actionbox.clearActions();
					actionbox.actions.push(new Action(Action.FIGHT), new Action(Action.USE_GUN));
					createActionbox(tile);
				}
				else
				{
					player.tile = tile;
					player.fight();
				}
				return;
			}
			
			player.tile = tile;
			
			// Αλληλεπίδραση με αντικείμενα
			if (tile.item)
			{
				switch (tile.item.name)
				{
					case Item.LASER: 
						room.clearItems();
						if (!game.alert)
							bubble.setText("Ήρθες σε επαφή με το laser και ενεργοποιήθηκε ο συναγερμός!", Bubble.DESCRIPTION);
						else
						{
							bubble.setText("Ήρθες σε επαφή με το laser και γνωρίζουν πού βρίσκεσαι!", Bubble.DESCRIPTION);
							game.alertTokens += 2;
							infoBar.update();
						}
						player.enableAlertMode();
						break;
					case Item.CAMERA_LINEOFSIGHT: 
						room.clearItems();
						if (!game.alert)
							bubble.setText("Είδαν από την κάμερα πού βρίσκεσαι και ενεργοποίησαν το συναγερμό!", Bubble.DESCRIPTION);
						else
						{
							bubble.setText("Είδαν από την κάμερα πού βρίσκεσαι!", Bubble.DESCRIPTION);
							game.alertTokens += 2;
							infoBar.update();
						}
						player.enableAlertMode();
						break;
					case Item.BOX: 
						player.hide();
						break;
					case Item.LOCKER: 
						player.hide();
						break;
					case Item.CIRCUIT: 
						player.disableSecuritySystems();
						break;
					case Item.AIR_DUCT: 
						if (game.airducts > 1)
						{
							actionbox.clearActions();
							actionbox.actions.push(new Action(Action.HIDE), new Action(Action.CHANGE_ROOM));
							createActionbox(tile);
						}
						else
							player.hide();
						break;
					case Item.ENTRANCE: 
						player.hide();
						break;
					case Item.WEAPON: 
						player.loadAmmo();
						break;
					case Item.FILES: 
						player.getFiles();
						break;
				}
			}
			
			// Έξοδος - Έλεγχος για αλλαγή δωματίου
			if (tile.type == Tile.EXIT)
			{
				if (game.alert && (room.type == Room.ENTRANCE || room.type == Room.BOXES || room.type == Room.AIRDUCT || room.type == Room.LOCKERS))
				{
					bubble.setText("'Καλύτερα να μείνω εδώ. Έχει μέρος να κρυφτώ μέχρι να ηρεμήσουν τα πράγματα.'");
				}
				else
				{
					changeRoom();
				}
			}
		}
		
		private function changeRoom():void
		{
			if (player.changeRoom())
			{
				disableListeners();
				new RoomScreen().addToStage();
			}
		}
		
		private function createActionbox(tile:Tile):void
		{
			actionbox.tile = tile;
			actionbox.create();
			actionbox.x = tile.x + tile.width / 2 - actionbox.width / 2;
			actionbox.y = tile.y - actionbox.height + 20;
			actionbox.visible = true;
		}
		
		private function showMap():void
		{
			disableListeners();
			new MapScreen().addToStage();
		}
		
		private function useGun(tile:Tile):void
		{
			if (player.tile == tile)
			{
				player.useGun(tile);
				return;
			}
			
			bullet.tile = player.tile;
			bullet.target = tile;
			bullet.angle = Math.atan2(bullet.target.y - bullet.tile.y, bullet.target.x - bullet.tile.x);
			bullet.x = player.x + Tile.TILESIZE / 2;
			bullet.y = player.y + Tile.TILESIZE / 2;
			bullet.moving = true;
			player.status = Player.SHOOTING;
		}
		
		// Animations
		/*******************************************************************************/
		private function movePlayer():void
		{
			// Αν υπάρχει μονοπάτι να διανύσει
			if (path && path.length)
			{
				var nextTile:Tile = path[0];

				var direction:uint = room.findDirection(player.tile.num, nextTile.num);

				if (direction)
				{
					// var targetX:Number = nextTile.x + Tile.TILESIZE / 2;
					// var targetY:Number = nextTile.y + Tile.TILESIZE / 2;
					var targetX:Number = nextTile.x;
					var targetY:Number = nextTile.y;
					var percent:Number = 0.40;
					
					if ((Math.abs(player.x - targetX) >= deltaTime * percent) || (Math.abs(player.y - targetY) >= deltaTime * percent))
						player.move(direction, deltaTime, percent);
					else
					{
						player.tile = nextTile;
						player.tile.placePlayer();
						path.splice(0, 1);
						if (path.length == 0 || room.type == Room.CAMERA || room.type == Room.LASER)
							interactWithTile();
					}
				}
			}
		}
		
		private function moveBullet():void
		{
			if (!bullet.moving)
				return;
			
			var dx:Number = bullet.x + bullet.speed * deltaTime * Math.cos(bullet.angle);
			var dy:Number = bullet.y + bullet.speed * deltaTime * Math.sin(bullet.angle);
			var num:Number = Room.getNum(dy / Tile.TILESIZE, dx / Tile.TILESIZE);
			
			bullet.x = dx;
			bullet.y = dy;
			
			if (bullet.target.num == num && Math.abs(bullet.x - (bullet.target.x + Tile.TILESIZE / 2)) <= bullet.speed * deltaTime && Math.abs(bullet.y - (bullet.target.y + Tile.TILESIZE / 2)) <= bullet.speed * deltaTime)
			{
				bullet.moving = false;
				player.useGun(bullet.target);
			}
		}
		
		private function stopPlayer():void
		{
			player.tile.placePlayer();
			path = new Vector.<Tile>();
		}
		
		private function showBubble():void
		{
			if (bubble.alpha < 1.0)
				bubble.alpha += 0.1;
		}
		
		// Listeners
		/*******************************************************************************/
		private function enableListeners():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (!stage.hasEventListener(MouseEvent.CLICK))
				stage.addEventListener(MouseEvent.CLICK, onClick);
			
			if (!stage.hasEventListener(KeyboardEvent.KEY_UP))
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			if (!stage.hasEventListener(Event.ENTER_FRAME))
			{
				startTime = getTimer();
				stage.addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		
		private function disableListeners():void
		{
			if (stage.hasEventListener(MouseEvent.CLICK))
				stage.removeEventListener(MouseEvent.CLICK, onClick);
			
			if (stage.hasEventListener(KeyboardEvent.KEY_UP))
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			if (stage.hasEventListener(Event.ENTER_FRAME))
				stage.removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (path.length)
				return;
			
			switch (e.keyCode)
			{
				default: 
					return;
				// Πλήκτρο m (λατινικό)
				case 77: 
					showMap();
					break;
			}
		}
		
		private function loop(e:Event):void
		{
			deltaTime = getTimer() - startTime;
			startTime = getTimer();

			movePlayer();
			player.animate();
			moveBullet();
			showBubble();
		}
	}
}
