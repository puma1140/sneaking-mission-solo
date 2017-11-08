package com.puma.sms
{
	import com.puma.general.AssetManager;
	import com.puma.general.Language;
	import com.puma.screens.RoomScreen;
	import com.puma.general.Game;
	
	import flash.events.Event;
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="768", height="640")]
	public class SneakingMissionSolo extends Sprite
	{
		public function SneakingMissionSolo()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var game:Game = Game.getInstance();
			var assetManager:AssetManager = AssetManager.getInstance();

			// stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			// stage.scaleMode = StageScaleMode.SHOW_ALL;
			// stage.align = StageAlign.TOP_LEFT;
			// stage.fullScreenSourceRect = new Rectangle(0, 0, 768, 640);
			
			game.stage = stage;
			game.root = this;
			game.language = new Language(Language.ENGLISH);
			game.language.load();
			game.init();
			
			var screen:RoomScreen = new RoomScreen();
			screen.addToStage();
		}
	}
}
