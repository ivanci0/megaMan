package states;

import assets.Bala;
import assets.Barro;
import assets.Enemigo;
import assets.PlatShadow;
import assets.Player;
import assets.ShadowBullet;
import flash.desktop.Clipboard;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import openfl.display.Tilemap;
import source.assets.Blaster;
import source.assets.BunbyHeli;
import source.assets.OctoBattery;

class PlayState extends FlxState
{
	var bosstheme:FlxSound;
	var bgm:FlxSound;
	var fondo:FlxSprite;
	var pastito:FlxSprite;
	var player:Player;
	
	//todas las balas enemigas van aca
	var balasEnemigas:FlxTypedGroup<Bala> = new FlxTypedGroup<Bala>();
	
	//octos
	var grupoOcto:FlxTypedGroup<OctoBattery> = new FlxTypedGroup<OctoBattery>();
	var canOctos:Int = 10;
	var contOctos:Int = 0;
	
	//blasters
	var grupoBlaster:FlxTypedGroup<Blaster> = new FlxTypedGroup<Blaster>();
	var canBlaster:Int = 15;
	var contBlaster:Int = 0;
	
	//bunbys
	var grupoBunby:FlxTypedGroup<BunbyHeli> = new FlxTypedGroup<BunbyHeli>();
	var canBunby:Int = 11;
	var contBunby:Int = 0;
	
	//variables para el lvl
	var ogmoLoader:FlxOgmoLoader;
	var tileMap:FlxTilemap;
	var pasto:FlxTilemap;
	
	// shadow Platform
	var plati:PlatShadow;
	//barros
	var grupoBarro:FlxTypedGroup<Barro> = new FlxTypedGroup<Barro>();
	var canBarro:Int = 3;
	var contBarro:Int = 0;
	
	override public function create():Void
	{
		super.create();
		//BGM
		bgm = new FlxSound();
		bgm.loadEmbedded(AssetPaths.cancerbutcatchy__wav, true);
		bgm.play();
		bosstheme = new FlxSound();
		bosstheme.loadEmbedded(AssetPaths.BossTheme__wav, true);
		//fondo
		fondo = new FlxSprite(0, -160);
		fondo.loadGraphic(AssetPaths.fondo__png);
		add(fondo);
		
		//Pastito try
		pastito = new FlxSprite(0, 0);
		pastito.loadGraphic(AssetPaths.pastito__png, false);
		
		//carga del lvl
		ogmoLoader = new FlxOgmoLoader(AssetPaths.Megalevel__oel);
		tileMap = ogmoLoader.loadTilemap(AssetPaths.tiles__png, 16, 16, "tiles");
		pasto = ogmoLoader.loadTilemap(AssetPaths.tiles__png, 16, 16, "pastito");
		
		FlxG.worldBounds.set(0, 0, tileMap.width, tileMap.height);
		FlxG.camera.setScrollBounds(0, tileMap.width, 0, tileMap.height);
		tileMap.setTileProperties(0, FlxObject.NONE);
		tileMap.setTileProperties(1, FlxObject.ANY);
		tileMap.setTileProperties(2, FlxObject.ANY);
		pasto.setTileProperties(0, FlxObject.NONE);
		ogmoLoader.loadEntities(funcionPosicionar, "entities");
		
		FlxG.camera.follow(player);
		
		// shadow plat
		plati = new PlatShadow(800, 48);
		// barros
		var l:Int = 0;
		for (barro in 0...canBarro) 
		{
			grupoBarro.members[barro] = new Barro(550 + l, 80);
			l += 16;
		}
		
		add(tileMap);
		add(player);
		add(pastito);
		//add de octos
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
		// add de bunbys y sus balas
		for (bunby in grupoBunby) 
		{
			add(bunby);
			balasEnemigas.add(bunby.getBala());
		}
		// add de todas las balas enemigas
		for (bala in balasEnemigas) 
		{
			add(bala);
		}
		//add de plati
		add(plati);
		// add de barros
		for (barro in grupoBarro) 
		{
			add(barro);
		}
	}


	override public function update(elapsed:Float):Void
	{		
		//colisiones
		FlxG.collide(tileMap, player);
		coliOctoFondo(grupoOcto);
		coliOctoJugador(grupoOcto, player);
		coliBlasterJugador(grupoBlaster, player);
		coliBunbyJugador(grupoBunby, player);
		colisionJugadorBalas(balasEnemigas, player);
		colisionBalaEnemigos(grupoBunby, grupoBlaster, grupoOcto);
		//FlxG.overlap(Reg.shadowbullet, tileMap, muerteBala); esto todavia no funca....
		caidaLibre();
		// coli de plat
		FlxG.collide(plati, player);
		// coli de barros
		coliDeBarros(grupoBarro, player);
		
		//BGM switch
		if (player.x > Reg.canchalenght - 450){
			bgm.stop();
			bosstheme.play();
		}
		//Dev mode
		if (FlxG.keys.justPressed.BACKSPACE&&FlxG.keys.justPressed.ENTER){
		Reg.devmode = true;
		}
		if (Reg.devmode == true){
			player.y = -100;
				if (FlxG.keys.pressed.LEFT){
				player.x = player.x -= 5;
			}
			if (FlxG.keys.pressed.RIGHT){
				player.x = player.x += 5;
			}
			tileMap.setTileProperties(1, FlxObject.NONE);
			tileMap.setTileProperties(2, FlxObject.NONE);
		}
		
		ReturnToBounds();
		
		if (Reg.animfinish < Reg.atkcd){
			Reg.animfinish += FlxG.elapsed;
		}
		if (Reg.animfinish >= Reg.atkcd){
			if (player.isTouching(FlxObject.FLOOR)&&!FlxG.keys.pressed.RIGHT&&!FlxG.keys.pressed.LEFT){
				player.Idle();
			}
			if(!player.isTouching(FlxObject.FLOOR)){
			player.Air();
		}
		if (FlxG.keys.justPressed.SPACE){
			Reg.shadowbullet = new ShadowBullet(player.x + player.width, player.y + player.height / 2);
			player.Attack();
		}
		}

		if (player.isTouching(FlxObject.FLOOR)){
			player.SoundRun();
			Movimiento();
		}
		
		super.update(elapsed);
	}
	
	private function Movimiento():Void{
		player.velocity.x = 0;
		
		if (player.x<Reg.canchalenght-player.width) 
		{
			player.MoveRight();
			if(FlxG.keys.pressed.RIGHT){
			player.scale.x = 1.5;
			}
		}
		if (player.x > 0) 
		{
			player.MoveLeft();
			if(FlxG.keys.pressed.LEFT){
			player.scale.x = 1.5;
			}
		}
		if (FlxG.keys.justPressed.UP && player.isTouching(FlxObject.FLOOR)) 
		{
			player.Jump();
			Reg.airanim = true;
		}
	}
	private function ReturnToBounds():Void{
		if (player.x > Reg.canchalenght - player.width){
			player.x = Reg.canchalenght	 - player.width;
		}
		if (player.x < 0){
			player.x = 0;
		}
	}
	private function funcionPosicionar(entityName:String, entityData:Xml):Void{
		var _x:Int = Std.parseInt(entityData.get("x"));
		var _y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "Player") 
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
		if (entityName == "Bunby") 
		{
			grupoBunby.members[contBunby] = new BunbyHeli(_x, _y);
			contBunby++;
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
				player.hurt(1);
				trace(player.health);
				member.kill();
			}
		}
	}
	private function coliBlasterJugador(blasters:FlxTypedGroup<Blaster>,player:Player):Void{
		for (blaster in blasters) 
		{
			if (FlxG.overlap(blaster, player)) 
			{
				player.hurt(1);
				trace(player.health);
				blaster.kill();
			}
		}
	}
	private function coliBunbyJugador(bunbys:FlxTypedGroup<BunbyHeli>,player:Player):Void{
		for (bunby in bunbys) 
		{
			if (FlxG.overlap(bunby,player)) 
			{
				player.hurt(1);
				trace(player.health);
				bunby.kill();
			}
		}
	}
	private function colisionJugadorBalas(balas:FlxTypedGroup<Bala>,player:Player):Void{
		for (bala in balas) 
		{
			if (FlxG.overlap(bala,player)) 
			{
				player.hurt(1);
				trace(player.health);
				bala.kill();
			}
		}
	}
	private function caidaLibre():Void{
		if (player.y + player.height > FlxG.camera.height) 
		{
			player.kill();
			trace("muerto");
		}
	}
	private function colisionBalaEnemigos(bunbys:FlxTypedGroup<BunbyHeli>, blasters:FlxTypedGroup<Blaster>, octos:FlxTypedGroup<OctoBattery>):Void{
		for (bunby in bunbys) 
		{
			if (FlxG.overlap(bunby,Reg.shadowbullet)) 
			{
				bunby.kill();
				Reg.shadowbullet.destroy();
			}
		}
		for (blaster in blasters) 
		{
			if (FlxG.overlap(blaster,Reg.shadowbullet)) 
			{
				blaster.kill();
				Reg.shadowbullet.destroy();
			}
		}
		for (octo in octos) 
		{
			if (FlxG.overlap(octo,Reg.shadowbullet)) 
			{
				octo.kill();
				Reg.shadowbullet.destroy();
			}
		}
	}
	private function muerteBala(bala:ShadowBullet,tilemap:Tilemap):Void{
		bala.destroy();
	}
	//prueba
	private function coliDeBarros(barros:FlxTypedGroup<Barro>, player:Player):Void{
		for (barro in barros) 
		{
			if (FlxG.collide(barro,player)) 
			{
				trace("lo toca");
			}
		}
	}
}