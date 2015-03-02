package ;

import flixel.FlxG;
import haxe.xml.Fast;
import haxe.xml.Parser;
import openfl.Assets;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Goldy
 */
class CustomOgmoLoader
{
	private var _xml:Xml;
	private var _fastXml:Fast;
	
	public function new(LevelData:Dynamic)
	{
		// Load xml file
		var str:String = "";
		// Passed embedded resource?
		if (Std.is(LevelData, Class))
		{
			str = Type.createInstance(LevelData, []);
		}
		// Passed path to resource?
		else if (Std.is(LevelData, String))
		{
			str = Assets.getText(LevelData);
		}
		_xml = Parser.parse(str);
		_fastXml = new Fast(_xml.firstElement());
	}	
	
	public function loadTilemap(TileGraphic:Dynamic, TileWidth:Int = 16, TileHeight:Int = 16, TileLayer:String = "tiles"):FlxTilemap
	{
	var tileMap:FlxTilemap = new FlxTilemap();
	tileMap.loadMap(_fastXml.node.resolve(TileLayer).innerData, TileGraphic, TileWidth, TileHeight);
	return tileMap;
	}
	
	public function loadEntities(EntityLoadCallback:String->Xml->Void, EntityLayer:String = "entities"):Void
	{
	var actors = _fastXml.node.resolve(EntityLayer);
	// Iterate over actors
	for (a in actors.elements)
	{
	EntityLoadCallback(a.name, a.x);
	}
	}
	
	private function interpretarCSV(csv:String):Array<Int> {
		// Figure out the map dimensions based on the data string
		var _data:Array<Int> = new Array<Int>();
		var columns:Array<String>;
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var lines:Array<String> = regex.split(csv);
		var rows:Array<String> = [];
		
		for (s in lines)
		{
			if (s != "") rows.push(s);
		}
		
		var heightInTiles:Int = rows.length;
		var widthInTiles:Int = 0;
		var row:Int = 0;
		var column:Int;
		
		while (row < heightInTiles)
		{
			columns = rows[row++].split(",");
			if (columns.length < 1)
			{
				heightInTiles = heightInTiles - 1;
				continue;
			}
			if (widthInTiles == 0)
			{
				widthInTiles = columns.length;
			}
			column = 0;
			while (column < widthInTiles)
			{
				//the current tile to be added:
				var curTile:Int = Std.parseInt(columns[column]);
				if (curTile < 0)
				{
					// anything < 0 should be treated as 0 for compatibility with certain map formats (ogmo)
					curTile = 0;
				}
				//if neko, make sure the value was not null, and if it is null,
				//make sure it is the last in the row (used to ignore commas)
				#if neko
					if (curTile != null)
					{
						_data.push(curTile);
						column++;
					}
					else if (column == columns.length - 1)
					{
						//if value was a comma, decrease the width by one
						widthInTiles--;
					}
					else
					{
						//if a non-int value was passed not at the end, warn the user
						throw "Value passed wan NaN";
					}
				#else
				//if not neko, dont worry about the comma
				_data.push(curTile);
				column++;
				#end
			}
		}
		
		return _data;
	}
	
	public function getIntArrayValues(EntityLayer:String = "entities"):Array<Int>
	{
		var casillas = _fastXml.node.resolve(EntityLayer).innerData;
		return interpretarCSV(casillas);
	}
	
}