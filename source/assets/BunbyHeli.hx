package source.assets;

import assets.Bala;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BunbyHeli extends FlxSprite 
{
	var bala:Bala;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.ORANGE);
		bala = new Bala();
		bala.kill();
	}
	override public function update(elapsed:Float):Void 
	{
		Moverse();
		Disparar();
		super.update(elapsed);
	}
	public function Moverse():Void{
		if (isOnScreen(FlxG.camera)) 
		{
			velocity.x = -100;
		}
	}
	public function Disparar():Void{
		if (!bala.alive && isOnScreen(FlxG.camera)) 
		{
			bala.setPosition(x + width / 2, y + height / 2);
			bala.revive();
			bala.salirDisparada(90);
		}
	}
	public function getBala():Bala{
		return bala;
	}
}