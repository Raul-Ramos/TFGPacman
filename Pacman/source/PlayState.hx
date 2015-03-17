package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.group.FlxTypedGroup;

import flixel.util.FlxColor;

import flixel.tile.FlxTilemap;
import flixel.FlxObject;

import Modulo.TipoIA;
import Pathfinding;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _map:CustomOgmoLoader;
	public var _mWalls:FlxTilemap; //TODO: toprivate
	
	private var pacman:Pacman;
	private var dots:FlxTypedGroup<Dot>;
	private var powerPellets:FlxTypedGroup<PowerPellet>;
	private var gFantasmas:GestorFantasmas;
	
	
	private var scoreTxt:FlxText;
	private var score:Int = 0;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		//Lectura del mapa
		_map = new CustomOgmoLoader(AssetPaths.n1__oel);
		
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 50, 50, "paredes");
		_mWalls.loadMap(_mWalls.getData(), AssetPaths.tileset__png, 50, 50, FlxTilemap.AUTO);
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		//Creación de zonas
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
		
		//Crea matriz bidimensional con los datos de las paredes
		var fila:Array<Int>;
		var valorParedes:Array<Array<Int>> = new Array<Array<Int>>();
		var unidimensional:Array<Int> = _mWalls.getData();
		for (f in 0..._mWalls.heightInTiles) {
			fila = new Array<Int>();
			for (c in 0..._mWalls.widthInTiles) {
				fila[c] = unidimensional[(f * _mWalls.widthInTiles) + c];
			}
			valorParedes[f] = fila;
		}
		
		//Lectura de entidades
		pacman = new Pacman(valorParedes);
		powerPellets = new FlxTypedGroup<PowerPellet>();
		
		_map.loadEntities(placeEntities, "entidades");
		
		add(pacman);
		add(powerPellets);

		//Gestor de fantasmas
		gFantasmas = new GestorFantasmas(valorParedes, pacman, 4);
		add(gFantasmas);
		gFantasmas.nuevoFantasma(50, 50, Modulo.TipoIA.Blinky);
		gFantasmas.nuevoFantasma(100, 50, Modulo.TipoIA.Pinky);
		gFantasmas.nuevoFantasma(150, 50, Modulo.TipoIA.Inky);
		gFantasmas.nuevoFantasma(200, 50, Modulo.TipoIA.Clyde);
		
		//Interfaz
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
		
		trace(dots.length);
		
		FlxG.collide(pacman, _mWalls);
		FlxG.overlap(pacman, dots, comerPunto);
		FlxG.overlap(pacman, powerPellets, comerPowerPellet);
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "pacman")
		{
			pacman.x = x;
			pacman.y = y;
			
		} else if (entityName == "puntoGrande") {
			powerPellets.add(new PowerPellet(x + ((50-20)/2), y + ((50-20)/2)));
		}
	}
	
	private function comerPunto(pacman:Pacman, dot:Dot):Void {
		dot.kill();
		actualizarPuntos(10);
	}
	
	private function comerPowerPellet(pacman:Pacman, pp:PowerPellet):Void {
		pp.kill();
		actualizarPuntos(50);
		trace("yuuu");
	}
	
	private function actualizarPuntos(suma:Int):Void {
		score += suma;
		scoreTxt.text = Std.string(score);
	}
}