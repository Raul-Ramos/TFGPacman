package ;

/**
 * @author Goldy
 */

interface Modulo 
{
	public function getColor():String;
	public function movimientoRegular():Void;
	public function movimientoPanico():Void;
}

enum TipoIA {
	Blinky;
}