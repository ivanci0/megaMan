package source.assets;

import assets.Bala;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Blaster extends FlxSprite 
{
	var balas:FlxTypedGroup<Bala> = new FlxTypedGroup<Bala>();
	var cantBalas:Int = 4;
	var contBalas:Int = 0;
	var angulo:Float = 0;
	var timer:FlxTimer;
	var otroTimer:FlxTimer;
	var escudo:Bool = true;
	var tipo:Int;
	public function new(?X:Float = 0, ?Y:Float = 0, _tipo:Int) 
	{
		super(X, Y);
		for (i in 0...cantBalas) 
		{
			balas.members[i] = new Bala();
			balas.members[i].kill();
		}
		timer = new FlxTimer();
		otroTimer = new FlxTimer();
		otroTimer.start(5, patronBlaster, 0);
		makeGraphic(16, 16, FlxColor.BROWN);
		tipo = _tipo;
	}
	public function patronBlaster(otroTimer:FlxTimer):Void{
		if (isOnScreen(FlxG.camera)) 
		{
			escudo = false;
			timer.start(.75, Disparar, cantBalas + 1);
		}
	}
	public function Disparar(timer:FlxTimer):Void{
		if (contBalas < cantBalas && alive) 
		{
			if (tipo == FlxObject.LEFT) 
			{
				switch (contBalas) 
				{
					case 0:
						angulo = -160;
					case 1:
						angulo = 180;
					case 2:
						angulo = 160;
					case 3:
						angulo = 140;
				}
			}
			else 
			{
				switch (contBalas) 
				{
					case 0:
						angulo = -20;
					case 1:
						angulo = 0;
					case 2:
						angulo = 20;
					case 3:
						angulo = 40;
				}
			}
			if (!balas.members[contBalas].alive && isOnScreen(FlxG.camera)) 
			{
				balas.members[contBalas].setPosition(x, y + height / 2);
				balas.members[contBalas].revive();
				balas.members[contBalas].salirDisparada(angulo);
			}
			contBalas++;
		}
		else 
		{
			contBalas = 0;
			escudo = true;
		}
	}
	public function getBalas():FlxTypedGroup<Bala>{
		return balas;
	}
	public function getEscudo():Bool{
		return escudo;
	}
}