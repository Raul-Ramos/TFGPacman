package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.group.FlxTypedGroup;

import flixel.util.FlxColor;

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
	
	private var scoreTxt:FlxText;
	private var score:Int = 0;
	
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
		
		dots = new FlxTypedGroup<Dot>();
		var zonas:Array<Int> = _map.getIntArrayValues("zonas");
		var x,y:Float;
		for (i in 0...zonas.length) {
			if (zonas[i] == 3) {
				x = i % _mWalls.widthInTiles;
				y = Math.floor(i / _mWalls.widthInTiles);
				var punto:Dot = new Dot((x * 50) + 21, (y * 50) + 21);
				dots.add(punto);
				add(punto);
			}
		}
		
		pacman = new Pacman();
		_map.loadEntities(placeEntities, "entidades");
		add(pacman);
		
		var fantasma:Fantasma = new Fantasma(200, 200);
		add(fantasma);
		fantasma = new Fantasma(250,200,"0xffff9cce");
		add(fantasma);
		fantasma = new Fantasma(300,200,"0xff31ffff");
		add(fantasma);
		fantasma = new Fantasma(350,200,"0xffffce31");
		add(fantasma);
		
		FlxG.camera.setBounds(0, -50, 1050, 1200, true);
		
		var myText = new FlxText((FlxG.width/2) - 50, -40, FlxG.width/2); // x, y, width
		myText.text = "HIGHSCORE:";
		myText.setFormat(20, FlxColor.WHITE, "right");
		add(myText);
		
		scoreTxt = new FlxText(myText.x, -10, FlxG.width/2);
		scoreTxt.text = Std.string(score);
		scoreTxt.setFormat(20, FlxColor.WHITE, "right");
		add(scoreTxt);
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
		FlxG.overlap(pacman, dots, comerPunto);
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
	
	private function comerPunto(pacman:Pacman, dot:Dot):Void {
		dot.kill();
		actualizarPuntos(10);
	}
	
	private function actualizarPuntos(suma:Int):Void {
		score += suma;
		scoreTxt.text = Std.string(score);
	}
}