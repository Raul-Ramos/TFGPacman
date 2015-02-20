package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_map = new FlxOgmoLoader(AssetPaths.n1__oel);
		trace(_map);
		
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 50, 50, "paredes");
		trace(_mWalls.getData());
		_mWalls.loadMap(_mWalls.getData(), AssetPaths.tileset__png, 50, 50, FlxTilemap.AUTO);
		trace(_mWalls.getData());
		//_mWalls.loadMap(_map, AssetPaths.tileset__png, 50, 50, FlxTilemap.AUTO);
		//_mWalls.setTileProperties(1, FlxObject.NONE);
		//_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}