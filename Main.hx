package ;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.display.Sprite;
import flash.geom.Point;
import motion.Actuate;
import flash.Lib;
import openfl.Assets;

/**
 * ...
 * @author Jeremiah Goerdt aka CaptainKraft
 */

class Main extends Sprite {
	
	// global constants
    public static var instance:Main;
    public static var WIDTH = 800 / 20;
    public static var HEIGHT = 800 / 20;

	// UI objects
    private var start:Bitmap;
    private var startSprite:Sprite;
    private var instructions:Bitmap;
    private var instructionsSprite:Sprite;
    private var proceed:Bitmap;
    private var proceedSprite:Sprite;
    private var scaleDir:Float;
    private var instructionScreen:Bitmap;
    private var endScreen:Bitmap;
    private var scoreImage:Bitmap;
    private var command:Bitmap;
    private var commandSprite:Sprite;
	
	// game objects
    private var bg:Bitmap;
    public var level:Level;
    public var tiles:Array<Tile>;
    public var player:Player;
    private var path:Array<Point>;
    private var highlight:Bitmap;
    private var highlights:Array<Bitmap>;
    private var highlighted:Bitmap;
    public var score:Int;
    private var scoreText:TextField;

    // helpers
    private var playing = false;
    private var executed = false;
	
	public function new() {
		super();

        instance = this;
		addEventListener(Event.ENTER_FRAME, update);
        addEventListener(MouseEvent.CLICK, click);

        bg = new Bitmap(Assets.getBitmapData("assets/bg.png"));
        addChild(bg);

        tiles = new Array<Tile>();
        level = new Level(0);
        addChild(level);

        highlight = new Bitmap(Assets.getBitmapData("assets/highlight.png"));
        highlights = new Array<Bitmap>();
        addChild(highlight);

        player = new Player();
        addChild(player);
        var font = Assets.getFont("assets/font.ttf");
        var format = new TextFormat(font.fontName);
        scoreImage = new Bitmap(Assets.getBitmapData("assets/score.png"));
        scoreImage.x = 10;
        scoreImage.y = 610;
        addChild(scoreImage);
        score = 0;
        scoreText = new TextField();
        scoreText.defaultTextFormat = format;
        scoreText.embedFonts = true;
        scoreText.text = Std.string(score);
        scoreText.textColor = 0xFFFFFF;
        scoreText.x = 175;
        scoreText.y = 608;
        scoreText.scaleX = 2;
        scoreText.scaleY = 2;
        addChild(scoreText);

        // display execute command
        commandSprite = new Sprite();
        commandSprite.x = 620;
        commandSprite.y = 625;
        addChild(commandSprite);
        command = new Bitmap(Assets.getBitmapData("assets/execute.png"));
        command.x -= command.width / 2;
        command.y -= command.height / 2;
        commandSprite.addChild(command);

        path = new Array<Point>();

        scaleDir = 0.2;

        // display menu
        instructionScreen = new Bitmap(Assets.getBitmapData("assets/instructionScreen.png"));
        instructionScreen.visible = false;
        instructionScreen.x += 50;
        instructionScreen.y += 50;
        //addChild(instructionScreen);
        endScreen = new Bitmap(Assets.getBitmapData("assets/gameover.png"));
        endScreen.visible = false;
        endScreen.x += 50;
        endScreen.y += 50;
        startSprite = new Sprite();
        startSprite.x = 400;
        startSprite.y = 400;
        addChild(startSprite);
        start = new Bitmap(Assets.getBitmapData("assets/start.png"));
        start.x -= start.width / 2;
        start.y -= start.height / 2;
        startSprite.addChild(start);
        startSprite.scaleX = 0.8;
        startSprite.scaleY = 0.8;
        instructionsSprite = new Sprite();
        instructionsSprite.x = 400;
        instructionsSprite.y = 500;
        addChild(instructionsSprite);
        instructions = new Bitmap(Assets.getBitmapData("assets/instructions.png"));
        instructions.x -= instructions.width / 2;
        instructions.y -= instructions.height / 2;
        instructionsSprite.addChild(instructions);
	}

    public function addScore(pickups:Int, moves:Int){
        score += pickups * 10 + (100 - moves);
        scoreText.text = Std.string(score);
    }

    public function endGame(){
        playing = false;
        removeChild(level);
        Helper.safeDestroy(level);
        level = new Level(0);
        addChild(level);
        endScreen.visible = true;
        addChild(endScreen);
    }

    public function clearTiles(){
        if(tiles != null) for(t in tiles) {
            removeChild(t); 
            tiles.remove(t);
        }
    }

    public function changeLevel(){
        for(t in tiles) addChild(t);
        if(player != null){
            addChild(player);
            addChild(highlight);
            path = new Array<Point>();
            addChild(commandSprite);
            executed = false;
            player.setLoc(new Point(0, 0));
        }
    }

    private function click(me:MouseEvent){
        var x = Lib.current.stage.mouseX;
        var y = Lib.current.stage.mouseY;

        if(playing && !executed){
            // figure out which tile the mouse is covering
            var xLoc = Math.floor(x / Tile.WIDTH);
            var yLoc = Math.floor(y / Tile.HEIGHT);

            if(!executed && command.hitTestPoint(x, y)){
                executed = true;
                player.startMove(path);
            }
            else if(!player.isMoving && path.length > 0){
                if(xLoc == path[path.length - 1].x || yLoc == path[path.length - 1].y){
                    path.push(new Point(xLoc, yLoc));
                    highlighted = new Bitmap(Assets.getBitmapData("assets/highlight.png"));
                    highlighted.x = Math.floor(Lib.current.stage.mouseX / Tile.WIDTH) * Tile.WIDTH;
                    highlighted.y = Math.floor(Lib.current.stage.mouseY / Tile.HEIGHT) * Tile.HEIGHT;
                    highlights.push(highlighted);
                    addChild(highlighted);
                    player.moves++;
                }
            }
            else if(!player.isMoving && xLoc == player.getLoc().x || yLoc == player.getLoc().y) {
                path.push(new Point(xLoc, yLoc));
                highlighted = new Bitmap(Assets.getBitmapData("assets/highlight.png"));
                highlighted.x = Math.floor(Lib.current.stage.mouseX / Tile.WIDTH) * Tile.WIDTH;
                highlighted.y = Math.floor(Lib.current.stage.mouseY / Tile.HEIGHT) * Tile.HEIGHT;
                highlights.push(highlighted);
                addChild(highlighted);
            }
        } else if(instructionScreen.visible){
            instructionScreen.visible = false;
            start.visible = true;
            instructions.visible = true;
        } else if(!endScreen.visible){
            if(start.visible && start.hitTestPoint(x, y)){
                playing = true;
                start.visible = false;
                instructions.visible = false;
            } else if(instructions.visible && instructions.hitTestPoint(x, y)){
                instructionScreen.visible = true;
                addChild(instructionScreen);
                start.visible = false;
                instructions.visible = false;
            }
        }
        if(endScreen.hitTestPoint(x, y) && endScreen.visible){
            endScreen.visible = false;
            start.visible = true;
            instructions.visible = true;
            //level.changeMap(level.id);
            executed = false;
            playing = true;
            score = 0;
            scoreText.text = Std.string(score);
        }
    }
	
	private function update(e:Event) {
        var x = Lib.current.stage.mouseX;
        var y = Lib.current.stage.mouseY;

        if(playing){
            player.update();

            // highlight valid moves
            var xLoc = Math.floor(x / Tile.WIDTH);
            var yLoc = Math.floor(y / Tile.HEIGHT);
            highlight.x = Math.floor(Lib.current.stage.mouseX / Tile.WIDTH) * Tile.WIDTH;
            highlight.y = Math.floor(Lib.current.stage.mouseY / Tile.HEIGHT) * Tile.HEIGHT;
            if(path.length > 0){
                if(xLoc == path[path.length - 1].x || yLoc == path[path.length - 1].y){
                    highlight.visible = true;
                } 
                else highlight.visible = false;
            }
            else if(xLoc == player.getLoc().x || yLoc == player.getLoc().y) {
                highlight.visible = true;
            } 
            else highlight.visible = false;

            // scaling execute command button
            if(!executed && command.hitTestPoint(x, y)){
                if(commandSprite.scaleX <= 0.8) scaleDir = 0.02;
                if(commandSprite.scaleX >= 1) scaleDir = -0.02;
                commandSprite.scaleX += scaleDir;
                commandSprite.scaleY += scaleDir;
            }
        } else {
            // update buttons if they exist
            if(start.visible && start.hitTestPoint(x, y)){
                if(startSprite.scaleX <= 0.7) scaleDir = 0.02;
                if(startSprite.scaleX >= 0.9) scaleDir = -0.02;
                startSprite.scaleX += scaleDir;
                startSprite.scaleY += scaleDir;
            } 
            if(instructions.visible && instructions.hitTestPoint(x, y)){
                if(instructionsSprite.scaleX <= 0.8) scaleDir = 0.02;
                if(instructionsSprite.scaleX >= 1) scaleDir = -0.02;
                instructionsSprite.scaleX += scaleDir;
                instructionsSprite.scaleY += scaleDir;
            } 
        }

        if(executed){
            highlight.visible = false;
            if(!player.isMoving) {
                if(!player.isMoving && level.id == level.maps.length - 1){
                    endGame();
                } else {
                    level.changeMap(++level.id);
                }
            }
        }
	}
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;

		Lib.current.addChild(new Main());
	}
}
