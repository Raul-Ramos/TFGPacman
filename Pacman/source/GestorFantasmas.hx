package ;

import flixel.group.FlxTypedSpriteGroup;
import Modulo.TipoIA;
import flixel.util.FlxPoint;

import flixel.FlxG;

/**
 * ...
 * @author Goldy
 */
class GestorFantasmas extends FlxTypedSpriteGroup<Fantasma>
{
	private var mapa:Array<Array<Int>>;
	private var pacman:Pacman;
	private var blinkyPerseguible:Fantasma = null;
	private var restanteFright:Int = 0;
	
	public function new(mapa:Array<Array<Int>>, pacman:Pacman, MaxSize:Int=4) 
	{
		super(0, 0, MaxSize);
		
		this.mapa = mapa;
		this.pacman = pacman;
		
		/*
		fantasma = new Fantasma(350,200, TipoIA.Blinky, "0xffffce31");
		add(fantasma);*/
	}
	
	public function nuevoFantasma(xf:Float = 0, yf:Float = 0, tipo:TipoIA)
	{
		var fantasma:Fantasma;
		var modulo:Modulo = null;
		
		switch(tipo) {
			case TipoIA.Blinky: modulo = new ModuloBlinky(mapa, pacman);
			case TipoIA.Pinky: modulo = new ModuloPinky(mapa, pacman);
			case TipoIA.Clyde: modulo = new ModuloClyde(mapa, pacman);
			case TipoIA.Inky:
				if (blinkyPerseguible != null) {
					modulo = new ModuloInky(mapa, pacman, blinkyPerseguible);
				} else {
					trace("ERROR: Creación de Inky - "
						+ "No hay ningun blinky disponible para seguir");
				}
		}
		
		if (modulo != null) {
			fantasma = new Fantasma(xf, yf, modulo);
			
			var vEsquina:Int = length % 4;
			var pointEsquina:FlxPoint = new FlxPoint();
			
			switch(vEsquina) {
				case 0: pointEsquina.set(mapa[0].length - 1, 0);
				case 1: pointEsquina.set(0, 0);
				case 2: pointEsquina.set(mapa[0].length - 1, mapa.length - 1);
				case 3: pointEsquina.set(0, mapa.length - 1);
			}
			fantasma.getIA().setEsquina(pointEsquina);
			
			add(fantasma);
			
			if (tipo == TipoIA.Blinky) {
				blinkyPerseguible = fantasma;
			}
		}
	}
	
	public function iniciarFright() {
		restanteFright = FlxG.updateFramerate * 6;
		
		for (i in members) {
			i.iniciarFrightMode();
		}
	}
	
	override public function update():Void
	{
		super.update();
		
		if (restanteFright > 0) {
			restanteFright--;
			if (restanteFright == 0) {
				for (i in members) {
					i.acabarFrightMode();
				}
			}
		}
	}
}