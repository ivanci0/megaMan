package assets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class OctoBattery extends FlxSprite 
{
	var izq:Bool;
	var arriba:Bool;
	var moverse:Bool = true;
	var timer:FlxTimer;
	var tipo:Tipo;
	var velocidad:Int;
	public function new(?X:Float=0, ?Y:Float=0, _tipo:Tipo) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.PURPLE);
		timer = new FlxTimer();
		tipo = _tipo;
		velocidad = 100;
	}
	override public function update(elapsed:Float):Void 
	{
		Moverse();
		patronOcto();
		super.update(elapsed);
	}
	public function Moverse():Void{
		if (moverse && tipo == Tipo.Horizontal) 
		{
			if (izq) 
			{
				velocity.x = -velocidad;
			}
			else 
			{
				velocity.x = velocidad;
			}
		}
		else if (moverse && tipo == Tipo.Vertical) 
		{
			if (arriba) 
			{
				velocity.y = -velocidad;
			}
			else 
			{
				velocity.y = velocidad;
			}
		}
		else 
		{
			velocity.x = 0;
			velocity.y = 0;
		}
	}
	public function patronOcto():Void{
		if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT) || isTouching(FlxObject.UP) || isTouching(FlxObject.DOWN)) 
		{
			moverse = false;
			timer.start(2, cambiarDireccion);
		}
	}
	public function cambiarDireccion(timer:FlxTimer):Void{
		moverse = true;
		if (izq) 
		{
			izq = false;
		}
		else 
		{
			izq = true;
		}
		
		if (arriba) 
		{
			arriba = false;
		}
		else 
		{
			arriba = true;
		}
	}
}
enum Tipo{
	Horizontal;
	Vertical;
}