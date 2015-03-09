package ;

import flixel.group.FlxTypedSpriteGroup;
import Modulo.TipoIA;

/**
 * ...
 * @author Goldy
 */
class GestorFantasmas extends FlxTypedSpriteGroup<Fantasma>
{
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=4) 
	{
		super(X, Y, MaxSize);
		
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
			case TipoIA.Blinky: modulo = new ModuloBlinky();
		}
		
		fantasma = new Fantasma(xf, yf, modulo);
		add(fantasma);
	}
	
}