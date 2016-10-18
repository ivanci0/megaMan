package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ivan Baigorria
 */
class Enemigo extends FlxSprite
{
	public var bala:Bala;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		bala = new Bala();
		bala.kill();
		makeGraphic(16, 16, FlxColor.PINK);
		acceleration.y = 1000;
	}
	override public function update(elapsed:Float):Void 
	{
		Disparar();
		super.update(elapsed);
	}
	public function Disparar():Void {
		if (!bala.alive) 
		{
			bala.setPosition(x, y);
			bala.revive();
			bala.salirDisparada(180);
		}
	}
}