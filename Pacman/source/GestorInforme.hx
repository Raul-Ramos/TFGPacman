
package ;

import TipoIA;
#if !flash
import sys.io.File;
import sys.FileSystem;
#else
import flash.net.FileReference;
import flash.events.Event;
import flash.events.ProgressEvent;
#end

/**
 * ...
 * @author Goldy
 */
class GestorInforme
{
	#if flash
	var fileRef:FileReference;
	#end
	var root:Xml;
	var tInicio:Int;

	public function new(nombreNivel:String,nombreJugador:String,nombresFant:Array<String>) 
	{
		root = Xml.createElement('game');
		
		var puntero:Xml = Xml.createElement('map');
		puntero.addChild(Xml.createPCData(nombreNivel));
		root.addChild(puntero);
		
		puntero = Xml.createElement('player');
		puntero.addChild(Xml.createPCData(nombreJugador));
		root.addChild(puntero);
		
		puntero = Xml.createElement('date');
		var fecha:Date = Date.now();
		puntero.addChild(Xml.createPCData(fecha.toString()));
		root.addChild(puntero);
		
		puntero = Xml.createElement('version');
		puntero.addChild(Xml.createPCData(getVersion()));
		root.addChild(puntero);
		
		var tagFantasmas:Xml = Xml.createElement('ghosts');
		for (fantasma in nombresFant) {
			puntero = Xml.createElement('ghost');
			puntero.set('ID', fantasma);
			tagFantasmas.addChild(puntero);
		}
		root.addChild(tagFantasmas);
		
		tInicio = flash.Lib.getTimer();
	}
	
	public function muerte(fantasma:String, dots:Int, pp:Int, score:Int) {
		var end:Xml = Xml.createElement('end');
		
		//Causa de la muerte
		var puntero:Xml = Xml.createElement('data');
		puntero.set('reason', 'killed');
		puntero.addChild(Xml.createPCData(fantasma));
		end.addChild(puntero);
		
		//Puntos
		var puntero:Xml = Xml.createElement('score');
		puntero.addChild(Xml.createPCData(Std.string(score)));
		end.addChild(puntero);
		
		//Dots
		var puntero:Xml = Xml.createElement('dots');
		puntero.addChild(Xml.createPCData(Std.string(dots)));
		end.addChild(puntero);
		
		//Power Pellet
		var puntero:Xml = Xml.createElement('powerpellet');
		puntero.addChild(Xml.createPCData(Std.string(pp)));
		end.addChild(puntero);
		
		//Tiempo
		var puntero:Xml = Xml.createElement('time');
		puntero.addChild(Xml.createPCData(Std.string(flash.Lib.getTimer() - tInicio)));
		end.addChild(puntero);
		
		root.addChild(end);
		
		
		#if !flash
		var filename:String = "gamedata";
		//NO-FLASH
		if (!FileSystem.exists("data"))
		{
			FileSystem.createDirectory("data");
		}
		var number:Int = 1;
		if (FileSystem.exists("data/" + filename + ".xml"))
		{
			while(FileSystem.exists("data/" + filename + number +".xml"))
			{
				number++;
			}
			filename = filename + number;
		}
		
		File.write("data/" + filename + ".xml", false);
		File.saveContent("data/" + filename + ".xml", root.toString());
		#else
		//FLASH
		fileRef = new FileReference();
		saveFile();
		#end
	}
	
	private function getVersion() {
		var version:String = "Unknown";
		#if windows
		version = 'windows';
		#end
		#if flash
		version = 'flash';
		#end
		return version;
	}
	
	
	#if flash
	private function saveFile()
	{
		fileRef.addEventListener(Event.SELECT, onSaveFileSelected); 
		fileRef.save(root.toString(),"gamedata.xml"); 
	}
	
	private function onSaveFileSelected(evt:Event)
	{ 
		fileRef.addEventListener(ProgressEvent.PROGRESS, onSaveProgress); 
		fileRef.addEventListener(Event.COMPLETE, onSaveComplete); 
		fileRef.addEventListener(Event.CANCEL, onSaveCancel); 
	} 

	private function onSaveProgress(evt:ProgressEvent)
	{ 
		trace("Saved " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes."); 
	} 
	 
	private function onSaveComplete(evt:Event)
	{ 
		trace("File saved."); 
		fileRef.removeEventListener(Event.SELECT, onSaveFileSelected); 
		fileRef.removeEventListener(ProgressEvent.PROGRESS, onSaveProgress); 
		fileRef.removeEventListener(Event.COMPLETE, onSaveComplete); 
		fileRef.removeEventListener(Event.CANCEL, onSaveCancel); 
	} 

	private function onSaveCancel(evt:Event)
	{ 
		trace("The save request was canceled by the user."); 
	}
	#end
}