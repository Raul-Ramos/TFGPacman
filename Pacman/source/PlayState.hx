package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.group.FlxTypedGroup;

import flixel.tile.FlxTilemap;
import flixel.FlxObject;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _map:CustomOgmoLoader;
	public var _mWalls:FlxTilemap; //TODO: toprivate
	
	private var pacman:Pacman;
	private var dots:FlxTypedGroup<Dot>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_map = new CustomOgmoLoader(AssetPaths.n1__oel);
		
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 50, 50, "paredes");
		_mWalls.loadMap(_mWalls.getData(), AssetPaths.tileset__png, 50, 50, FlxTilemap.AUTO);
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		var zonas:Array<Int> = _map.getIntArrayValues("zonas");
		var x, y:Float;
		for (i in 0...zonas.length) {
			if (zonas[i] == 3) {
				x = i % _mWalls.widthInTiles;
				y = Math.floor(i / _mWalls.widthInTiles);
				var punto:Dot = new Dot((x * 50) + 21, (y * 50) + 21);
				//dots.add(punto);
				add(punto);
			}
		}
		
		pacman = new Pacman();
		_map.loadEntities(placeEntities, "entidades");
		add(pacman);
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
		
		FlxG.collide(pacman, _mWalls);
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "pacman")
		{
			pacman.x = x;
			pacman.y = y;
		}
	}
}