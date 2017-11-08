package com.puma.general
{
	
	/**
	 * ...
	 * @author Spyros Papadimitriou
	 */
	public class AssetManager
	{
		private static var instance:AssetManager = null;
		
		[Embed(source="/assets/tileset_room.png")]
		public static var TilesetRoom:Class;
		
		[Embed(source="/assets/tileset_hero_walking.png")]
		public static var TilesetHeroWalking:Class;
		
		[Embed(source="/assets/tileset_hero_shooting.png")]
		public static var TilesetHeroShooting:Class;
		
		[Embed(source="/assets/tileset_guard_fighting.png")]
		public static var TilesetGuardFighting:Class;
		
		public static function getInstance():AssetManager
		{
			if (instance == null)
				instance = new AssetManager();
			
			return instance;
		}
	
	}

}