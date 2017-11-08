package com.puma.screens {
	import flash.utils.getTimer;
	import flash.display.Sprite;

	import com.puma.classes.Bubble;
	import com.puma.classes.infobar.MapIcon;
	import com.puma.classes.InfoBar;
	import com.puma.classes.Item;
	import com.puma.classes.MapTile;

	import flash.events.MouseEvent;

	import com.puma.classes.Room;
	import com.puma.classes.Map;

	import flash.events.KeyboardEvent;
	import flash.events.Event;

	import com.puma.general.Screen;

	/**
	 * @author puma
	 */
	public class MapScreen extends Screen {
		private var map : Map;
		private var infoBar : InfoBar;
		private var mapHolder : Sprite;
		private var bubble : Bubble;
		private var clickedTime : uint;

		public function MapScreen() {
			super();

			alpha = 0.0;
			map = new Map();
			map.build();
			infoBar = game.infoBar;
			infoBar.update();
			mapHolder = new Sprite();
			bubble = game.bubble;
			if (game.currentRoom.type == Room.AIRDUCT && game.airducts > 1)
				bubble.setText("You may move to another room through airduct.", Bubble.DESCRIPTION);
			else
				bubble.setText("");

			mapHolder.addChild(map);
			addChild(mapHolder);
			addChild(infoBar);
			addChild(bubble);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e : Event) : void {
			alpha += 0.1;
			if (alpha >= 1.0)
				enableListeners();
		}

		// Listeners
		/******************************************************************************/
		private function enableListeners() : void {
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (!stage.hasEventListener(KeyboardEvent.KEY_UP))
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			if (!stage.hasEventListener(MouseEvent.CLICK))
				stage.addEventListener(MouseEvent.CLICK, onClick);

			if (!stage.hasEventListener(MouseEvent.MOUSE_DOWN))
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function disableListeners() : void {
			if (stage.hasEventListener(KeyboardEvent.KEY_UP))
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

			if (stage.hasEventListener(MouseEvent.CLICK))
				stage.removeEventListener(MouseEvent.CLICK, onClick);

			if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onKeyUp(e : KeyboardEvent) : void {
			switch (e.keyCode) {
				default:
					return;
				// Πλήκτρο m (λατινικό)
				case 77:
					disableListeners();
					new RoomScreen().addToStage();
					break;
			}
		}

		private function onClick(e : MouseEvent) : void {
			mapHolder.stopDrag();

			var interval : uint = getTimer() - clickedTime;
			// trace("onClick interval: " + interval);
			if (interval > 150)
				return;

			var target : Object = e.target;
			if (target is MapTile) {
				var mapTile : MapTile = MapTile(target);
				if (mapTile.room.type == Room.AIRDUCT) {
					game.currentRoom = mapTile.room;
					game.player.tile = mapTile.room.searchByItemType(Item.AIR_DUCT);
					if (game.player.tile == null)
						game.player.tile = mapTile.room.tiles[54];

					disableListeners();
					new RoomScreen().addToStage();
				}
			} else if (target is MapIcon) {
				switch (MapIcon(target).type) {
					case MapIcon.CLOSE:
						disableListeners();
						new RoomScreen().addToStage();
						break;
					case MapIcon.CENTER:
						mapHolder.x = 0;
						mapHolder.y = 0;
						break;
				}
			}
		}

		private function onMouseDown(e : MouseEvent) : void {
			clickedTime = getTimer();
			mapHolder.startDrag();
		}
	}
}