package;
import assets.ShadowBullet;
import flixel.system.FlxSound;

/**
 * ...
 * @author Ivan Baigorria y yo y zaboomafooooo
 */
class Reg
{
	public static inline var atkcd:Float = 0.6;
	public static inline var hSpeed:Float = 300;
	public static inline var vSpeed:Float = -500;
	public static inline var PlayerSpeedX = 200;
	public static var airanim:Bool = false;
	public static var runsound:FlxSound;
	public static var animfinish:Float = 0;
	public static var jumpsound:FlxSound;
	public static var shadowbullet:ShadowBullet;
	public static var devmode:Bool = false;
	public static var checkpointX:Int = 0;
	public static var checkpointY:Int = 0;
	public static var faceleft:Bool = false;
	public static inline var canchalenght:Int = 4500;
}