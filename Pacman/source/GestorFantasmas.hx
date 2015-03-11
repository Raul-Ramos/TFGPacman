package ;

import flixel.group.FlxTypedSpriteGroup;
import Modulo.TipoIA;

/**
 * ...
 * @author Goldy
 */
class GestorFantasmas extends FlxTypedSpriteGroup<Fantasma>
{
	private var mapa:Array<Int>;
	private var pacman:Pacman;
	
	public function new(mapa:Array<Int>, pacman:Pacman, MaxSize:Int=4) 
	{
		super(0, 0, MaxSize);
		
		this.mapa = mapa;
		this.pacman = pacman;
		
		/*add(fantasma);
		fantasma = new Fantasma(250,200, TipoIA.Blinky, "0xffff9cce");
		add(fantasma);
		fantasma = new Fantasma(300,200, TipoIA.Blinky,"0xff31ffff");
		add(fantasma);
		fantasma = new Fantasma(350,200, TipoIA.Blinky, "0xffffce31");
		add(fantasma);*/
	}
	
	public function nuevoFantasma(xf:Float = 0, yf:Float = 0, tipo:TipoIA)
	{
		var fantasma:Fantasma;
		var modulo:Modulo;
		
		switch(tipo) {
			case TipoIA.Blinky: modulo = new ModuloBlinky(mapa,pacman);
		}
		
		fantasma = new Fantasma(xf, yf, modulo);
		add(fantasma);
	}
	
}