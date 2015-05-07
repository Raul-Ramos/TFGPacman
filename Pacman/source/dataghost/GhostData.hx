package dataghost;

import TipoIA;

/**
 * ...
 * @author Goldy
 */
class GhostData
{
	public static function getName(tipoIa:TipoIA) 
	{
		switch (tipoIa) {
			case TipoIA.Blinky: return "Blinky";
			case TipoIA.Pinky: return "Pinky";
			case TipoIA.Inky: return "Inky";
			case TipoIA.Clyde: return "Clyde";
			case TipoIA.Kiry: return "Kiry";
			default: return "NONE";
		}
	}
	
	public static function getColor(tipoIa:TipoIA) 
	{
		switch (tipoIa) {
			case TipoIA.Blinky: return "0xffff0000";
			case TipoIA.Pinky: return "0xffff9cce";
			case TipoIA.Inky: return "0xff31ffff";
			case TipoIA.Clyde: return "0xffffce31";
			case TipoIA.Kiry: return "0xff9142ad";
			default: return "NONE";
		}
	}
}