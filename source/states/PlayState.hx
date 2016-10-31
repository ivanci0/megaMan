package states;

import assets.Bala;
import assets.Blaster;
import assets.OctoBattery;
import assets.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var pastito:FlxSprite;
	var player:Player;
	
	// todas las balas enemigas van aca...
	var balasEnemigas:FlxTypedGroup<Bala> = new FlxTypedGroup<Bala>();
	
	//octos
	var grupoOcto:FlxTypedGroup<OctoBattery> = new FlxTypedGroup<OctoBattery>();
	var canOctos:Int = 2;
	var contOctos:Int = 0;
	
	//blasters
	var grupoBlaster:FlxTypedGroup<Blaster> = new FlxTypedGroup<Blaster>();
	var canBlaster:Int = 2;
	var contBlaster:Int = 0;
	
	//variables para el lvl
	var ogmoLoader:FlxOgmoLoader;
	var tileMap:FlxTilemap;
	
	override public function create():Void
	{
		super.create();
		
		//Pastito try
		pastito = new FlxSprite(0, 0);
		pastito.loadGraphic(AssetPaths.pastito__png, false);
		
		//carga del lvl
		ogmoLoader = new FlxOgmoLoader(AssetPaths.lvlPrueba__oel);
		tileMap = ogmoLoader.loadTilemap(AssetPaths.tiles__png, 16, 16, "tiles");
		
		FlxG.worldBounds.set(0, 0, tileMap.width, tileMap.height);
		FlxG.camera.setScrollBounds(0, tileMap.width, 0, tileMap.height);
		tileMap.setTileProperties(0, FlxObject.NONE);
		tileMap.setTileProperties(1, FlxObject.NONE);
		tileMap.setTileProperties(2, FlxObject.ANY);
		ogmoLoader.loadEntities(funcionPosicionar, "entities");
		
		FlxG.camera.follow(player);
		
		add(tileMap);
		add(player);
		add(pastito);
		//add de octopussy
		for (octo in grupoOcto) 
		{
			add(octo);
		}
		// add de blaster y sus balas
		for (blaster in grupoBlaster) 
		{
			add(blaster);
			for (bala in blaster.getBalas()) 
			{
				balasEnemigas.add(bala);
			}
		}
		// add de todas las balas enemigas
		for (bala in balasEnemigas) 
		{
			add(bala);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(tileMap, player);
		coliOctoFondo(grupoOcto);
		coliOctoJugador(grupoOcto, player);
		coliBlasterJugador(grupoBlaster, player);
		colisionJugadorBalas(balasEnemigas, player);
		Movimiento();
	}
	
	private function Movimiento():Void{
		player.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT && player.x<1024-player.width) 
		{
			player.MoveRight();
			pastito.x--;
		}
		if (FlxG.keys.pressed.LEFT && player.x > 0) 
		{
			player.MoveLeft();
			pastito.x++;
		}
		if (FlxG.keys.justPressed.UP && player.isTouching(FlxObject.FLOOR)) 
		{
			player.Jump();
		}
	}
	private function funcionPosicionar(entityName:String, entityData:Xml):Void{
		var _x:Int = Std.parseInt(entityData.get("x"));
		var _y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player") 
		{
			player = new Player(0, 0);
		}
		if (entityName == "OctoHor") 
		{
			grupoOcto.members[contOctos] = new OctoBattery(_x, _y, Tipo.Horizontal);
			contOctos++;
		}
		if (entityName == "OctoVer") 
		{
			grupoOcto.members[contOctos] = new OctoBattery(_x, _y, Tipo.Vertical);
			contOctos++;
		}
		if (entityName == "BlasterDer") 
		{
			grupoBlaster.members[contBlaster] = new Blaster(_x, _y, FlxObject.RIGHT);
			contBlaster++;
		}
		if (entityName == "BlasterIzq") 
		{
			grupoBlaster.members[contBlaster] = new Blaster(_x, _y, FlxObject.LEFT);
			contBlaster++;
		}
	}
	//colisiones
	private function coliOctoFondo(Octos:FlxTypedGroup<OctoBattery>):Void{
		for (member in Octos) 
		{
			FlxG.collide(member, tileMap);
		}
	}
	private function coliOctoJugador(octos:FlxTypedGroup<OctoBattery>,player:Player):Void{
		for (member in octos) 
		{
			if (FlxG.overlap(member,player)) 
			{
				player.hurt(10);
				trace(player.health);
			}
		}
	}
	private function coliBlasterJugador(blasters:FlxTypedGroup<Blaster>,player:Player):Void{
		for (blaster in blasters) 
		{
			if (FlxG.overlap(blaster, player)) 
			{
				player.hurt(10);
				trace(player.health);
			}
		}
	}
	private function colisionJugadorBalas(balas:FlxTypedGroup<Bala>,player:Player):Void{
		for (bala in balas) 
		{
			if (FlxG.overlap(bala,player)) 
			{
				player.hurt(5);
				trace(player.health);
				bala.kill();
			}
		}
	}
}