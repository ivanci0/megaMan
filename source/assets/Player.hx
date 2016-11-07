package assets;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Yo xD!!1!11!!!!
 */
class Player extends FlxSprite
{
	var timerHurt:FlxTimer;
	var intocable:Bool;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.ShadowSheet__png, true, 63, 87);
		setSize(30, 86);
		centerOffsets();
		animation.add("Idle", [30,31,32, 33, 34], 12, true);
		animation.add("RunR", [22, 23, 24, 25], 12, true);	
		animation.add("RunL", [26, 27, 28, 29], 12, true);
		animation.add("Jump", [12, 13, 14, 15, 16, 17], 12, false);
		animation.add("Air", [18, 19, 20, 21], 12, true);
		animation.add("Attack", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 17, false);
		Reg.runsound = new FlxSound();
		Reg.runsound.loadEmbedded(AssetPaths.run__wav, true);
		Reg.jumpsound = new FlxSound();
		Reg.jumpsound.loadEmbedded(AssetPaths.Jump__wav,false);
		acceleration.y = 1000;
		maxVelocity.y -= Reg.vSpeed;
		health = 100;
		timerHurt = new FlxTimer();
		
	}
	public function MoveRight():Void{
		if (FlxG.keys.pressed.RIGHT){
			flipX = false;
			velocity.x = Reg.hSpeed;
			animation.play("RunR");
			Reg.faceleft = false;
		}

	}
	
	public function MoveLeft():Void{
		if (FlxG.keys.pressed.LEFT){
			flipX = true;
			velocity.x = -1 * Reg.hSpeed;
			animation.play("RunR");
			Reg.faceleft = true;
		}
	}
	public function SoundRun():Void{
		if (FlxG.keys.pressed.LEFT||FlxG.keys.pressed.RIGHT){
		Reg.runsound.play();
		}
		else{
			Reg.runsound.stop();
		}
	}
	public function Jump():Void{
			velocity.y = Reg.vSpeed;
			animation.play("Jump");
			Reg.jumpsound.play();
	}
	public function Idle():Void{
		if(!FlxG.keys.anyPressed([LEFT,RIGHT,SPACE])){
		animation.play("Idle");
		scale.x = 1;
		}
	}
	public function Attack():Void{
			animation.play("Attack");
			Reg.animfinish = 0;
			FlxG.state.add(Reg.shadowbullet);
	}
	public function Air():Void{
		animation.play("Air");
	}
	override public function hurt(Damage:Float):Void 
	{
		if (!intocable) 
		{
			esHerido();
			super.hurt(Damage);
		}
	}
	public function esHerido():Void {
		if (Reg.faceleft) 
		{
			velocity.x = 50;
			velocity.y = -100;
			animation.play("Jump");
			Reg.jumpsound.play();
		}
		else 
		{
			velocity.x = -1 * 50;
			velocity.y = -100;
			animation.play("Jump");
			Reg.jumpsound.play();
		}
		intocable = true;
		timerHurt.start(1.5, setIntocable);
	}
	public function setIntocable(timerHurt:FlxTimer):Void{
		intocable = false;
	}
}