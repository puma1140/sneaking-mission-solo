package com.puma.general {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	/**
	 * @author puma
	 */
	public class Language {
		public static const GREEK : String = "el";
		public static const ENGLISH : String = "en";
		private var _game : Game = Game.getInstance();
		private var _xml : XML;
		private var _xmlList : XMLList;
		private var _loader : URLLoader;
		private var _name : String;
		// Όλα τα κείμενα
		private var _still : String;
		private var _betterHide : String;
		private var _mustAttack : String;
		private var _attackOrLeave : String;
		private var _laserAlert : String;
		private var _laserAlreadyAlert : String;
		private var _cameraAlert : String;
		private var _cameraAlreadyAlert : String;
		private var _deadend : String;
		private var _disableAlertWithFiles : String;
		private var _hide : String;

		public function Language(name : String) : void {
			this._name = name;
		}

		public function load() : void {
			loader = new URLLoader();

			enableListeners();
			loader.load(new URLRequest("languages/" + name + ".xml"));
		}

		public function getValue(name : String) : String {
			var result : String = "";
			if (xmlList && xmlList.length())
				for each (var output : XML in xmlList)
					if (output.child("name") == name) {
						result = output.child("value");
						break;
					}

			return result;
		}

		private function onIOError(e : IOErrorEvent) : void {
			// trace(e);
			trace("Πρόβλημα στη φόρτωση της γλώσσας: " + name);
		}

		private function onComplete(e : Event) : void {
			disableListeners();
			XML.ignoreWhitespace = true;
			xml = new XML(URLLoader(e.target).data);
			xmlList = xml.children();
		}

		private function enableListeners() : void {
			if (!loader.hasEventListener(IOErrorEvent.IO_ERROR))
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

			if (!loader.hasEventListener(Event.COMPLETE))
				loader.addEventListener(Event.COMPLETE, onComplete);
		}

		private function disableListeners() : void {
			if (loader.hasEventListener(IOErrorEvent.IO_ERROR))
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);

			if (loader.hasEventListener(Event.COMPLETE))
				loader.removeEventListener(Event.COMPLETE, onComplete);
		}

		// Getters and Setters
		public function get game() : Game {
			return _game;
		}

		public function set game(game : Game) : void {
			this._game = game;
		}

		public function get still() : String {
			return _still;
		}

		public function set still(still : String) : void {
			this._still = still;
		}

		public function get name() : String {
			return _name;
		}

		public function set name(name : String) : void {
			this._name = name;
		}

		public function get xml() : XML {
			return _xml;
		}

		public function set xml(xml : XML) : void {
			this._xml = xml;
		}

		public function get loader() : URLLoader {
			return _loader;
		}

		public function set loader(loader : URLLoader) : void {
			this._loader = loader;
		}

		public function get betterHide() : String {
			return _betterHide;
		}

		public function set betterHide(betterHide : String) : void {
			this._betterHide = betterHide;
		}

		public function get mustAttack() : String {
			return _mustAttack;
		}

		public function set mustAttack(mustAttack : String) : void {
			this._mustAttack = mustAttack;
		}

		public function get attackOrLeave() : String {
			return _attackOrLeave;
		}

		public function set attackOrLeave(attackOrLeave : String) : void {
			this._attackOrLeave = attackOrLeave;
		}

		public function get laserAlert() : String {
			return _laserAlert;
		}

		public function set laserAlert(laserAlert : String) : void {
			this._laserAlert = laserAlert;
		}

		public function get laserAlreadyAlert() : String {
			return _laserAlreadyAlert;
		}

		public function set laserAlreadyAlert(laserAlreadyAlert : String) : void {
			this._laserAlreadyAlert = laserAlreadyAlert;
		}

		public function get cameraAlert() : String {
			return _cameraAlert;
		}

		public function set cameraAlert(cameraAlert : String) : void {
			this._cameraAlert = cameraAlert;
		}

		public function get cameraAlreadyAlert() : String {
			return _cameraAlreadyAlert;
		}

		public function set cameraAlreadyAlert(cameraAlreadyAlert : String) : void {
			this._cameraAlreadyAlert = cameraAlreadyAlert;
		}

		public function get deadend() : String {
			return _deadend;
		}

		public function set deadend(deadend : String) : void {
			this._deadend = deadend;
		}

		public function get disableAlertWithFiles() : String {
			return _disableAlertWithFiles;
		}

		public function set disableAlertWithFiles(disableAlertWithFiles : String) : void {
			this._disableAlertWithFiles = disableAlertWithFiles;
		}

		public function get hide() : String {
			return _hide;
		}

		public function set hide(hide : String) : void {
			this._hide = hide;
		}

		public function get xmlList() : XMLList {
			return _xmlList;
		}

		public function set xmlList(xmlList : XMLList) : void {
			this._xmlList = xmlList;
		}
	}
}