package selectScreen;

import dataghost.GhostData;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import openfl.display.Sprite;

import flixel.text.FlxText;
import flixel.util.FlxColor;

import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIText;

/**
 * ...
 * @author Goldy
 */
class SelectScreenState extends FlxUIState
{
	private var nombreJugador:String = null;
	private var fantasmas:Array<TipoIA>;
	private var showing:Array<Int>;
	private var nombreI:FlxInputText;
	private var punt:Int;
	
	override public function new(nombreJugador:String, punt:Int = -1):Void {
		super();
		this.nombreJugador = nombreJugador;
		this.punt = punt;
	}
	
	override public function create():Void
	{
		super.create();
		
		var nombresFant:Array<String> = new Array<String>();
		var coloresFant:Array<String> = new Array<String>();
		fantasmas = new Array<TipoIA>();
		showing = new Array<Int>();
		
		conseguirDatos(fantasmas, nombresFant, coloresFant);
		
		var h:Float = FlxG.height / 100;
		var w:Float = FlxG.width;
		
		//Tag de nombre
		var myText:FlxText = new FlxText(0, h * 10, w); // x, y, width
		myText.text = "Escribe tu nombre aquí:";
		myText.setFormat(25, FlxColor.WHITE, "center");
		myText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.RED, 1);
		add(myText);
		
		//Input de nombre
		nombreI = new FlxInputText(0, (myText.y + myText.size * 2), Std.int(w) , 'Jugador', 20, FlxColor.WHITE, FlxColor.BLACK);
		nombreI.setFormat(20, FlxColor.WHITE, "center");
		if (nombreJugador != null) {
			nombreI.text = nombreJugador;
		}
		add(nombreI);
		
		//Puntuación
		if (punt != -1) {
			myText = new FlxText(0, h * 25, w); // x, y, width
			myText.text = "Puntuación: " + punt;
			myText.setFormat(30, FlxColor.WHITE, "center");
			myText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.FOREST_GREEN, 1);
			add(myText);
		}
		
		//Mostrarios
		var boton:FlxUIButton;
		for (i in 0...4) {
			showing[i] = i;
			
			//Fantasma
			var fantasma:FlxSprite = new FlxSprite();
			var ojos:FlxSprite = new FlxSprite();
			fantasma.loadGraphic(AssetPaths.fantasma__png, false, 50, 50, true);
			ojos.loadGraphic(AssetPaths.ojos__png, true, 50, 50);
			
			fantasma.scale.x = fantasma.scale.y = ojos.scale.x = ojos.scale.y = 2;
			fantasma.updateHitbox();
			ojos.updateHitbox();
			
			fantasma.x = ojos.x = ((w / 4) * i) + ((w / 4) * 0.5) - (fantasma.width * 0.5);
			fantasma.y = ojos.y = h * 35;
			
			fantasma.replaceColor(Std.parseInt(coloresFant[0]), Std.parseInt(coloresFant[i]));
			
			add(fantasma);
			add(ojos);
			
			//Nombre
			var texto:FlxText = new FlxText(0, 0, w/4);
			texto.text = nombresFant[i];
			texto.setFormat(20, FlxColor.WHITE, "center");
			texto.x = fantasma.x + (fantasma.width * 0.5) - (texto.width * 0.5);
			texto.y = fantasma.y + fantasma.height;
			add(texto);
			
			//Boton
			boton = new FlxUIButton(0, 0, '', function cambiarFantasma() {
				var ant = showing[i];
				showing[i] = ant + 1;
				if (showing[i] > showing.length) {
					showing[i] = 0;
				}
				texto.text = nombresFant[showing[i]];
				fantasma.replaceColor(Std.parseInt(coloresFant[ant]), Std.parseInt(coloresFant[showing[i]]), true);
			}
			);
			boton.scale.x = boton.scale.y = 1.5;
			boton.updateHitbox();
			boton.label = new FlxUIText(0, 4, boton.width, "Siguiente");
			boton.label.setFormat(null, 18, 0x333333, "center");
			boton.x = fantasma.x + (fantasma.width * 0.5) - (boton.width * 0.5);
			boton.y = texto.y + 40;
			add(boton);
		}
		
		//Boton de empezar
		boton = new FlxUIButton(0, 0, '', finalizar);
		boton.scale.x = boton.scale.y = 1.5;
		boton.updateHitbox();
		boton.label = new FlxUIText(0, 4, boton.width, "¡Empezar!");
		boton.label.setFormat(null, 18, 0x333333, "center");
		boton.x = (w / 2) - (boton.width/2);
		boton.y = h * 75;
		add(boton);
	}
	
	private function conseguirDatos(fantasmas:Array<TipoIA>, nombresFant:Array<String>, coloresFant:Array<String>):Void {
		datosFantasma(fantasmas, nombresFant, coloresFant, TipoIA.Blinky);
		datosFantasma(fantasmas, nombresFant, coloresFant, TipoIA.Pinky);
		datosFantasma(fantasmas, nombresFant, coloresFant, TipoIA.Inky);
		datosFantasma(fantasmas, nombresFant, coloresFant, TipoIA.Clyde);
		datosFantasma(fantasmas, nombresFant, coloresFant, TipoIA.Kiry);
	}
	
	private function datosFantasma(fantasmas:Array<TipoIA>, nombresFant:Array<String>, coloresFant:Array<String>, fantasma:TipoIA):Void {
		fantasmas.push(fantasma);
		nombresFant.push(GhostData.getName(fantasma));
		coloresFant.push(GhostData.getColor(fantasma));
	}
	
	private function finalizar():Void {
		var fantasmasSeleccionados:Array<TipoIA> = new Array<TipoIA>();
		for (i in 0...4) {
			fantasmasSeleccionados.push(fantasmas[showing[i]]);
		}
		
		FlxG.switchState(new PlayState(nombreI.text,fantasmasSeleccionados));
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
	}
	
}