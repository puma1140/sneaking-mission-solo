package com.puma.classes {
	import flash.display.Sprite;

	/**
	 * @author puma
	 */
	public class Actionbox extends Sprite {
		private var _actions : Vector.<Action>;
		private var bg : Sprite;
		private var _tile : Tile;
		private var _currentAction : Action;

		public function Actionbox() {
			actions = new Vector.<Action>();
			bg = new Sprite();
		}
		
		public function create():void {			
			if (actions.length) {
				for (var i:uint = 0; i < actions.length; i++) {
					actions[i].x = 0;
					actions[i].y = i * actions[i].height;
					
					bg.addChild(actions[i]);
				}
				
				bg.graphics.beginFill(0x0000FF);
				bg.graphics.drawRect(0, 0, actions[0].width, actions.length * actions[0].height);
				bg.graphics.endFill();
				addChild(bg);
			}
		}
		
		public function clearActions():void {
			while (numChildren)
				removeChildAt(0);
			
			actions = new Vector.<Action>();
		}

		// Getters and Setters
		public function get actions() : Vector.<Action> {
			return _actions;
		}

		public function set actions(actions : Vector.<Action>) : void {
			this._actions = actions;
		}

		public function get tile() : Tile {
			return _tile;
		}

		public function set tile(tile : Tile) : void {
			this._tile = tile;
		}

		public function get currentAction() : Action {
			return _currentAction;
		}

		public function set currentAction(currentAction : Action) : void {
			this._currentAction = currentAction;
		}
	}
}
