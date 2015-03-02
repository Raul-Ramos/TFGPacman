package ;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

/**
 * ...
 * @author Goldy
 */
class CustomOgmoLoader extends FlxOgmoLoader
{
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