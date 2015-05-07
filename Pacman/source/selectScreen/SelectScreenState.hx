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

import GestorFantasmas;

/**
 * ...
 * @author Goldy
 */
class SelectScreenState extends FlxUIState
{

	override public function create():Void
	{
		super.create();
		
		var nombresFant:Array<String> = new Array<String>();
		var coloresFant:Array<String> = new Array<String>();
		
		conseguirDatos(nombresFant, coloresFant);
		
		var h:Float = FlxG.height / 100;
		var w:Float = FlxG.width;
		
		var myText:FlxText = new FlxText(0, h * 10, w); // x, y, width
		myText.text = "Escribe tu nombre aquí:";
		myText.setFormat(25, FlxColor.WHITE, "center");
		myText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.RED, 1);
		add(myText);
		
		var nombreI:FlxInputText = new FlxInputText(0, (myText.y + myText.size * 2), Std.int(w) , 'Jugador', 20, FlxColor.WHITE, FlxColor.BLACK);
		nombreI.setFormat(20, FlxColor.WHITE, "center");
		add(nombreI);
		
		for (i in 0...4) {
			var fantasma:FlxSprite = new FlxSprite();
			var ojos:FlxSprite = new FlxSprite();
			
			//Fantasma
			fantasma.loadGraphic(AssetPaths.fantasma__png, false, 50, 50, true);
			ojos.loadGraphic(AssetPaths.ojos__png, true, 50, 50);
			
			fantasma.scale.x = fantasma.scale.y = ojos.scale.x = ojos.scale.y = 2;
			fantasma.updateHitbox();
			ojos.updateHitbox();
			
			fantasma.x = ojos.x = ((w / 4) * i) + ((w / 4) * 0.5) - (fantasma.width * 0.5);
			fantasma.y = ojos.y = h * 35;
			
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
			var boton = new FlxUIButton(0, 0, '', cambiarFantasma);
			boton.scale.x = boton.scale.y = 1.5;
			boton.updateHitbox();
			boton.label = new FlxUIText(0, 4, boton.width, "Siguiente");
			boton.label.setFormat(null, 18, 0x333333, "center");
			boton.x = fantasma.x + (fantasma.width * 0.5) - (boton.width * 0.5);
			boton.y = texto.y + 40;
			add(boton);
		}
	}
	
	private function cambiarFantasma() {
		trace("yeh");
	}
	
	private function conseguirDatos(nombresFant:Array<String>, coloresFant:Array<String>):Void {
		datosFantasma(nombresFant, coloresFant, TipoIA.Blinky);
		datosFantasma(nombresFant, coloresFant, TipoIA.Pinky);
		datosFantasma(nombresFant, coloresFant, TipoIA.Inky);
		datosFantasma(nombresFant, coloresFant, TipoIA.Clyde);
		datosFantasma(nombresFant, coloresFant, TipoIA.Kiry);
	}
	
	private function datosFantasma(nombresFant:Array<String>,coloresFant:Array<String>,fantasma:TipoIA):Void {
		nombresFant.push(GhostData.getName(fantasma));
		coloresFant.push(GhostData.getColor(fantasma));
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