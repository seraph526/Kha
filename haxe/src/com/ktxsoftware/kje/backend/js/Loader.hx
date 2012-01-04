package com.ktxsoftware.kje.backend.js;

import haxe.io.Bytes;
import haxe.io.BytesData;
import js.Dom;
import js.Lib;

class Loader extends com.ktxsoftware.kje.Loader {
	var numberOfFiles : Int;
	
	public function new() {
		super();
	}
	
	private override function loadStarted(numberOfFiles : Int) {
		this.numberOfFiles = numberOfFiles;
	}
	
	public override function loadDataDefinition() {
		var r = new haxe.Http("data.xml");
		r.onError = Lib.alert;
		r.onData = function(data : String) {
			xmls.set("data.xml", Xml.parse(data));
			loadFiles();
		};
		r.request(false);
	}
	
	override function loadXml(filename : String) {
		var r = new haxe.Http(filename);
		r.onError = Lib.alert;
		r.onData = function(data : String) {
			xmls.set(filename, Xml.parse(data));
			--numberOfFiles;
			checkComplete();
		};
		r.request(false);
	}
	
	override function loadMusic(filename : String) {
		musics.set(filename, new Music());
		--numberOfFiles;
		checkComplete();
	}
	
	override function loadSound(filename : String) {
		sounds.set(filename, new Sound());
		--numberOfFiles;
		checkComplete();
	}
	
	override function loadImage(filename : String) {
		var img : js.Image = cast Lib.document.createElement("img");
		img.src = filename;
		img.onload = function(event : Event) {
			images.set(filename, new com.ktxsoftware.kje.backend.js.Image(img));
			--numberOfFiles;
			checkComplete();
		};
	}
	
	var bytePosition : Int;
	
	function readInt(bytes : Bytes) : Int {
		var fourth = bytes.get(bytePosition + 0);
		var third  = bytes.get(bytePosition + 1);
		var second = bytes.get(bytePosition + 2);
		var first  = bytes.get(bytePosition + 3);
		bytePosition += 4;
		return first + second * 256 + third * 256 * 256 + fourth * 256 * 256 * 256;
	}
	
	override function loadMap(name : String) {
		var r = new haxe.Http(name);
		r.onError = Lib.alert;
		r.onData = function(data : String) {
			bytePosition = 0;
			var bytes : Bytes = Bytes.ofString(data);
			var levelWidth : Int = readInt(bytes);
			var levelHeight : Int = readInt(bytes);
			var map : Array<Array<Int>> = new Array<Array<Int>>();
			for (x in 0...levelWidth) {
				map.push(new Array<Int>());
				for (y in 0...levelHeight) {
					map[x].push(readInt(bytes));
				}
			}
			maps.set(name, map);
			--numberOfFiles;
			checkComplete();
		};
		r.request(false);
	}
	
	function checkComplete() {
		if (numberOfFiles <= 0) {
			//Lib.alert("Complete");
			Main.start();
		}
	}
}