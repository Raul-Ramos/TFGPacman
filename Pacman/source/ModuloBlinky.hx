package ;

/**
 * ...
 * @author Goldy
 */
class ModuloBlinky implements Modulo
{
	private var fantasma:Fantasma = null;
	private var mapa:Array<Int>;
	
	public function new(mapa:Array<Int>) 
	{
		this.mapa = mapa;
	}
	
	/* INTERFACE Modulo */
	
	public function setFantasma(fantasma:Fantasma):Void 
	{
		this.fantasma = fantasma;
	}
	
	public function getColor():String 
	{
		return null;
	}
	
	public function movimientoRegular():Void 
	{
		if (fantasma == null) {
			//TODO: return null
		}
		
		//Casillas
		var fy:Int = Math.floor(fantasma.getMidpoint().y/50); 
		var fx:Int = Math.floor(fantasma.getMidpoint().x/50);
		var caminosLibres:Int = 0;
		
		if (mapa[(fy * 21) + 1 + fx] == 0) caminosLibres += 1;
		if (mapa[(fy * 21) - 1 + fx] == 0) caminosLibres += 1;
		if (mapa[((fy + 1) * 21) + fx] == 0) caminosLibres += 1;
		if (mapa[((fy - 1) * 21) + fx] == 0) caminosLibres += 1;
		
		trace(caminosLibres); //TODO: Mejor que 21 directamente
		
	}
	
	public function movimientoPanico():Void 
	{
		if (fantasma == null) {
			//TODO: return null
		}
	}
	
}