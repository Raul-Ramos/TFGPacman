package ;

/**
 * @author Goldy
 */

interface Modulo
{
	private var fantasma:Fantasma;
	public function setFantasma(fantasma:Fantasma):Void;
	public function getColor():String;
	public function movimientoRegular():Int;
	public function movimientoPanico():Void;
}

enum TipoIA {
	Blinky;
}