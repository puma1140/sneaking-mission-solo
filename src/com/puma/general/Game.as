package com.puma.general
{
	import com.puma.classes.Bubble;
	import com.puma.classes.InfoBar;
	import com.puma.classes.Player;
	import com.puma.classes.Guard;
	import com.puma.classes.Room;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * @author puma
	 */
	public class Game
	{
		private static var instance:Game = null;
		public static const MAX_ALERT_TOKENS:uint = 5;
		private var _stage:Stage;
		private var _root:Sprite;
		private var _currentScreen:Screen;
		private var _previousScreen:Screen;
		// Μεταβλητές χρήσιμες κατά τη διάρκεια του παιχνιδιού
		private var _currentRoom:Room;
		private var _unexploredRooms:Vector.<Room>; // Ο χάρτης με τα εξερευνημένα δωμάτια
		
		private var _map:Vector.<Room>;
		private var _player:Player;
		// Όλοι οι φρουροί του παιχνιδιού
		private var _guards:Vector.<Guard>;
		private var _alert:Boolean;
		private var _alertTokens:uint;
		private var _airducts:uint = 0;
		private var _securitySystems:uint = 0;
		private var _infoBar:InfoBar;
		private var _bubble:Bubble;
		// Η γλώσσα του παιχνιδιού
		private var _language:Language;
		
		public static function getInstance():Game
		{
			if (instance == null)
				instance = new Game();
			
			return instance;
		}
		
		public function randomNumbers(min:int, max:int):int
		{
			return Math.round(min + (max - min) * Math.random());
		}
		
		public function init():void
		{
			infoBar = new InfoBar();
			player = new Player();
			unexploredRooms = new Vector.<Room>();
			map = new Vector.<Room>();
			guards = new Vector.<Guard>();
			infoBar.update();
			bubble = new Bubble();
			
			airducts = 0;
			securitySystems = 0;
			alertTokens = 0;
			alert = false;
			
			createEmptyRooms();
			createRoomsWithWeapon();
			createRoomsWithCircuit();
			createRoomsWithLaser();
			createRoomsWithCameras();
			createRoomsWithAirduct();
			createRoomsWithBoxes();
			createRoomsWithLockers();
			createRoomsWithFiles();
			createRoomsWithSleepingGuards();
			createRoomsWithGuardRed();
			createRoomsWithGuardArrow();
			
			shuffleRooms();
		}
		
		// Δημιουργία δωματίων
		/**********************************************************************************/
		private function createEmptyRooms():void
		{
			// Άδεια δωμάτια
			for (var i:uint = 0; i < 12; i++)
				unexploredRooms.push(new Room(Room.EMPTY, true, true, true, true, null));
			for (i = 0; i < 10; i++)
				unexploredRooms.push(new Room(Room.EMPTY, true, false, true, true, null));
			for (i = 0; i < 8; i++)
				unexploredRooms.push(new Room(Room.EMPTY, true, false, true, false, null));
		}
		
		private function createRoomsWithWeapon():void
		{
			// Δωμάτια με όπλο
			for (var i:uint = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.WEAPON, true, false, true, true, null));
			for (i = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.WEAPON, true, true, true, true, null));
		}
		
		private function createRoomsWithCircuit():void
		{
			// Δωμάτια με σύστημα απενεργοποίησης συναγερμού
			for (var i:uint = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.CIRCUIT, false, false, false, true, null));
		}
		
		private function createRoomsWithLaser():void
		{
			// Δωμάτια με laser
			unexploredRooms.push(new Room(Room.LASER, true, false, true, true, null));
			for (var i:uint = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.LASER, true, false, true, false, null));
			for (i = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.LASER, true, true, true, true, null));
		}
		
		private function createRoomsWithCameras():void
		{
			// Δωμάτια με κάμερες
			unexploredRooms.push(new Room(Room.CAMERA, true, false, true, false, null));
			for (var i:uint = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.CAMERA, true, false, true, true, null));
			for (i = 0; i < 2; i++)
				unexploredRooms.push(new Room(Room.CAMERA, true, true, true, true, null));
		}
		
		private function createRoomsWithAirduct():void
		{
			// Δωμάτια με αεραγωγό
			for (var i:uint = 0; i < 3; i++)
				unexploredRooms.push(new Room(Room.AIRDUCT, true, false, true, false, null));
		}
		
		private function createRoomsWithBoxes():void
		{
			// Δωμάτια με κουτιά
			for (var i:uint = 0; i < 3; i++)
				unexploredRooms.push(new Room(Room.BOXES, true, false, true, false, null));
		}
		
		private function createRoomsWithLockers():void
		{
			// Δωμάτια με ντουλάπια
			unexploredRooms.push(new Room(Room.LOCKERS, true, false, true, false, null));
			unexploredRooms.push(new Room(Room.LOCKERS, true, false, true, true, null));
			unexploredRooms.push(new Room(Room.LOCKERS, true, true, true, true, null));
		}
		
		private function createRoomsWithFiles():void
		{
			// Δωμάτιο με τα μυστικά αρχεία
			unexploredRooms.push(new Room(Room.FILES, false, false, false, true, null));
		}
		
		private function createRoomsWithSleepingGuards():void
		{
			// Δωμάτια με κοιμισμένους φρουρούς
			for (var i:uint = 0; i < 4; i++)
				unexploredRooms.push(new Room(Room.GUARD, true, true, true, true, new Guard(true)));
		}
		
		private function createRoomsWithGuardRed():void
		{
			// Δωμάτια με ξύπνιους φρουρούς με κόκκινο κουτάκι
			for (var i:uint = 0; i < 5; i++)
				unexploredRooms.push(new Room(Room.GUARD, true, true, true, true, new Guard(false, 0, Room.SOUTH, Room.SOUTH)));
			for (i = 0; i < 3; i++)
				unexploredRooms.push(new Room(Room.GUARD, true, true, true, true, new Guard(false, 0, Room.NORTH, Room.SOUTH)));
		}
		
		private function createRoomsWithGuardArrow():void
		{
			// Δωμάτια με ξύπνιους φρουρούς με βελάκι
			for (var i:uint = 1; i <= 4; i++)
				unexploredRooms.push(new Room(Room.GUARD, true, false, true, true, new Guard(false, i, Room.SOUTH, 0)));
			for (i = 1; i <= 4; i++)
				unexploredRooms.push(new Room(Room.GUARD, true, false, true, true, new Guard(false, i, Room.WEST, 0)));
			for (i = 1; i <= 4; i++)
				unexploredRooms.push(new Room(Room.GUARD, true, false, true, true, new Guard(false, i, Room.NORTH, 0)));
			for (i = 1; i <= 4; i++)
				for (var j:uint = 1; j <= 4; j++)
					unexploredRooms.push(new Room(Room.GUARD, true, true, true, true, new Guard(false, i, j, 0)));
		}
		
		private function shuffleRooms():void
		{
			var temp:Vector.<Room> = new Vector.<Room>(unexploredRooms.length);
			var randomPos:uint = 0;
			
			for (var i:uint = 0; i < temp.length; i++)
			{
				randomPos = uint(Math.random() * unexploredRooms.length);
				temp[i] = unexploredRooms[randomPos];
				unexploredRooms.splice(randomPos, 1)[0];
			}
			
			unexploredRooms = new Vector.<Room>();
			unexploredRooms = temp;
			
			var entranceRoom:Room = new Room(Room.ENTRANCE, false, false, false, true);
			entranceRoom.setRowCol(0, 0);
			entranceRoom.build();
			player.tile = entranceRoom.tiles[54];
			
			map.push(entranceRoom);
			currentRoom = entranceRoom;
			// for (i = 0; i < unexploredRooms.length; i++)
			// trace(unexploredRooms[i].type);
		}
		
		/**********************************************************************************/
		public function searchMap(row:int, col:int):Room
		{
			for (var i:uint = 0; i < map.length; i++)
			{
				if (map[i].row == row && map[i].col == col)
					return map[i];
			}
			
			return null;
		}
		
		// Getters and Setters
		public function get currentScreen():Screen
		{
			return _currentScreen;
		}
		
		public function set currentScreen(currentScreen:Screen):void
		{
			_currentScreen = currentScreen;
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function set stage(stage:Stage):void
		{
			_stage = stage;
		}
		
		public function get root():Sprite
		{
			return _root;
		}
		
		public function set root(root:Sprite):void
		{
			_root = root;
		}
		
		public function get currentRoom():Room
		{
			return _currentRoom;
		}
		
		public function set currentRoom(currentRoom:Room):void
		{
			this._currentRoom = currentRoom;
		}
		
		public function get unexploredRooms():Vector.<Room>
		{
			return _unexploredRooms;
		}
		
		public function set unexploredRooms(unexploredRooms:Vector.<Room>):void
		{
			this._unexploredRooms = unexploredRooms;
		}
		
		public function get player():Player
		{
			return _player;
		}
		
		public function set player(player:Player):void
		{
			this._player = player;
		}
		
		public function get map():Vector.<Room>
		{
			return _map;
		}
		
		public function set map(map:Vector.<Room>):void
		{
			this._map = map;
		}
		
		public function get alert():Boolean
		{
			return _alert;
		}
		
		public function set alert(alert:Boolean):void
		{
			_alert = alert;
		}
		
		public function get alertTokens():uint
		{
			return _alertTokens;
		}
		
		public function set alertTokens(alertTokens:uint):void
		{
			if (alertTokens > MAX_ALERT_TOKENS)
				alertTokens = MAX_ALERT_TOKENS;
			
			_alertTokens = alertTokens;
			
			if (alertTokens == MAX_ALERT_TOKENS)
				trace('Αποτυχία!');
		}
		
		public function get guards():Vector.<Guard>
		{
			return _guards;
		}
		
		public function set guards(guards:Vector.<Guard>):void
		{
			this._guards = guards;
		}
		
		public function get previousScreen():Screen
		{
			return _previousScreen;
		}
		
		public function set previousScreen(previousScreen:Screen):void
		{
			_previousScreen = previousScreen;
		}
		
		public function get airducts():uint
		{
			return _airducts;
		}
		
		public function set airducts(airducts:uint):void
		{
			this._airducts = airducts;
		}
		
		public function get infoBar():InfoBar
		{
			return _infoBar;
		}
		
		public function set infoBar(infoBar:InfoBar):void
		{
			this._infoBar = infoBar;
		}
		
		public function get bubble():Bubble
		{
			return _bubble;
		}
		
		public function set bubble(bubble:Bubble):void
		{
			this._bubble = bubble;
		}
		
		public function get securitySystems():uint
		{
			return _securitySystems;
		}
		
		public function set securitySystems(securitySystems:uint):void
		{
			this._securitySystems = securitySystems;
		}
		
		public function get language():Language
		{
			return _language;
		}
		
		public function set language(language:Language):void
		{
			this._language = language;
		}
	}
}