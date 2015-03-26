package ;

import Modulo.TipoIA;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

import flixel.FlxG;

/**
 * ...
 * @author Goldy
 */
class GestorFantasmas extends FlxTypedGroup<Fantasma>
{
	//Variables de uso
	private var mapa:Array<Array<Int>>;
	private var pacman:Pacman;
	private var blinkyPerseguible:Fantasma = null;
	
	//Posicionamiento y casa
	private var espaciosDisponibles:Array<FlxPoint>;
	private var espaciosUsados:Int = 0;
	private var fantasmasCautivos:Array<Fantasma>;
	private var puerta:FlxPoint = null;
	private var salida:FlxPoint = null;
	
	//Frightened
	private var restanteFright:Int = 0;
	
	//Variables del ciclo scatter-chase
	//TODO: Solo está para el nivel 1
	private var duracionCiclos:Array<Int> = [7, 20, 7, 20, 5, 20, 5];
	private var fase:Int = -1;
	private var restanteFase:Int;
	
	//Dots
	private var dots:FlxTypedGroup<Dot>;
	
	private var gestorValores:GestorValoresJuego;
	
	public function new(mapa:Array<Array<Int>>, gestorValores:GestorValoresJuego, dots:FlxTypedGroup<Dot>, pacman:Pacman) 
	{
		super(4);
		
		this.mapa = mapa;
		this.dots = dots;
		this.pacman = pacman;
		fantasmasCautivos = new Array<Fantasma>();
		
		this.gestorValores = gestorValores;
		
		//Busca los espacios disponibles de spawn para los fantasmas
		espaciosDisponibles = new Array<FlxPoint>();
		for (py in 0...mapa.length) {
			for (px in 0...mapa[py].length) {
				if (mapa[py][px] == 2) {
					
					//Mira si vale como puerta si no se ha encontrado ninguna
					if (puerta == null) {
						if (py - 1 > 0 && mapa[py - 1][px] < 1) {
							salida = new FlxPoint(px, py - 1);
						} else if (py + 1 < mapa.length && mapa[py + 1][px] < 1) {
							salida = new FlxPoint(px, py + 1);
						} else if (px + 1 < mapa[0].length && mapa[py][px + 1] < 1) {
							salida = new FlxPoint(px + 1, py);
						} else if (px - 1 > 0 && mapa[py][px - 1] < 1) {
							salida = new FlxPoint(px - 1, py);
						}
						
						if (salida != null) {
							puerta = new FlxPoint(px, py);
							espaciosDisponibles.insert(0, salida);
							continue;
						}
						
					}
					
					espaciosDisponibles.push(new FlxPoint(px,py));
					
				}
			}
		}
	}
	
	public function empezarCicloSC():Void
	{
		fase = 0;
		restanteFase = duracionCiclos[fase] * FlxG.updateFramerate;
		for (i in members) {
			i.getIA().alternarSC();
		}
	}
	
	public function nuevoFantasma(tipo:TipoIA):Fantasma
	{
		//Se calcula la posicion de salida
		var posicion:FlxPoint = null;
		if (espaciosUsados < espaciosDisponibles.length) {
			posicion = espaciosDisponibles[espaciosUsados];
		} else {
			//TODO: Errores sólo en debug
			trace("ERROR: Sin posiciones de spawn disponibles");
			return null;
		}
		
		//Se mira qué tipo de módulo es
		var modulo:Modulo = null;
		
		switch(tipo) {
			case TipoIA.Blinky: modulo = new ModuloBlinky(mapa, pacman, gestorValores, dots);
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
		
		if (modulo == null) {
			return null;
		}
		
		//Se crea el fantasma
		var fantasma:Fantasma = new Fantasma(posicion.x * 50, posicion.y * 50, gestorValores.getGhostSpeed(), modulo);
		
		//Se asigna la esquina hogar
		var vEsquina:Int = length % 4;
		var pointEsquina:FlxPoint = new FlxPoint();	
		switch(vEsquina) {
			case 0: pointEsquina.set(mapa[0].length - 1, 0);
			case 1: pointEsquina.set(0, 0);
			case 2: pointEsquina.set(mapa[0].length - 1, mapa.length - 1);
			case 3: pointEsquina.set(0, mapa.length - 1);
		}
		modulo.setEsquina(pointEsquina);
		
		//Se añade el fantasma
		add(fantasma);
			
		if (tipo == TipoIA.Blinky) {
			blinkyPerseguible = fantasma;
		}
		
		if (espaciosUsados != 0) {
			fantasmasCautivos.push(fantasma);
		}
		
		espaciosUsados++;
		return fantasma;
	}
	
	public function iniciarFright() {
		restanteFright = FlxG.updateFramerate * gestorValores.getFrightTime();
		
		for (i in members) {
			if (fantasmasCautivos.indexOf(i) == -1) {
				i.maxVelocity.x = gestorValores.getFrightGhostSpeed();
				if (i.getCurrentVelocity() > i.maxVelocity.x) {
					i.setCurrentVelocity(i.maxVelocity.x);
				}
				i.iniciarFrightMode();
			}
		}
		pacman.iniciarFright();
	}
	
	override public function update():Void
	{
		super.update();
		
		//Liberacion de fantasmas
		if (fantasmasCautivos.length > 0) {
			if (fantasmasCautivos.length == 1) {
				if (dots.countDead() >= Math.floor(dots.length/3)) {
					fantasmasCautivos[0].liberar(puerta, Std.int(salida.x - puerta.x), Std.int(salida.y - puerta.y));
					fantasmasCautivos.remove(fantasmasCautivos[0]);
				}
			} else if (fantasmasCautivos.length == 2) {
				if (dots.countDead() >= 30) {
					fantasmasCautivos[0].liberar(puerta, Std.int(salida.x - puerta.x), Std.int(salida.y - puerta.y));
					fantasmasCautivos.remove(fantasmasCautivos[0]);
				}
			} else {
				fantasmasCautivos[0].liberar(puerta, Std.int(salida.x - puerta.x), Std.int(salida.y - puerta.y));
				fantasmasCautivos.remove(fantasmasCautivos[0]);
			}
		}
		
		//Fright
		if (restanteFright > 0) {
			restanteFright--;
			if (restanteFright == 0) {
				for (i in members) {
					//Lo pongo antes del acabarFrightMode porque Blinky
					//cambia su max velocity si esta en elroy
					i.maxVelocity.x = gestorValores.getGhostSpeed();
					if (i.getCurrentVelocity() == i.maxVelocity.x) {
						i.setCurrentVelocity(i.maxVelocity.x);
					}
					i.acabarFrightMode();
				}
				pacman.acabarFright();
			} else {
				if (restanteFright < FlxG.drawFramerate * 2 && restanteFright % 10 == 0) {
					for (i in members) {
						i.alternarBW();
					}
				}
			}
		}
		
		//Cambio de fase de seguimiento
		if (fase != -1) {
			if ( restanteFase == 0 ) {
				if (fase + 1 > duracionCiclos.length) {
					fase = -1;
				} else {
					fase++;
					restanteFase = duracionCiclos[fase] * FlxG.updateFramerate;
					for (i in members) {
						i.getIA().alternarSC();
					}
				}
			} else {
				restanteFase--;
			}
		}
	}
}