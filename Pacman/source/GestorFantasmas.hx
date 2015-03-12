package ;

import flixel.group.FlxTypedSpriteGroup;
import Modulo.TipoIA;

/**
 * ...
 * @author Goldy
 */
class GestorFantasmas extends FlxTypedSpriteGroup<Fantasma>
{
	private var mapa:Array<Array<Int>>;
	private var pacman:Pacman;
	private var blinkyPerseguible:Fantasma = null;
	
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
			add(fantasma);
			
			if (tipo == TipoIA.Blinky) {
				blinkyPerseguible = fantasma;
			}
		}
	}
	
}