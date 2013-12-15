package ;

import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;
import motion.Actuate;
import motion.easing.Linear;
import flash.geom.Vector3D;

class Player extends Sprite{

    private var img:Bitmap;
    private var loc:Point;
    private var isMoving = false;
    private var speed = 100;
    private var destination:Point;
    private var path:Array<Point>;
    private var center:Point;

    public function new(){
        super();

        img = new Bitmap(Assets.getBitmapData("assets/player.png"));
        addChild(img);

        loc = new Point(img.x, img.y);
        center = new Point(loc.x + img.width / 2, loc.y + img.height / 2);
    }

    private function changeDestination(){
		var locVec = new Vector3D(loc.x, loc.y, 0);
		destination = path.pop();
        destination.x *= Tile.WIDTH;
        destination.y *= Tile.HEIGHT;
		var destinationVec = new Vector3D(destination.x, destination.y, 0);
		var tmp = Vector3D.distance(locVec, destinationVec);
		Actuate.tween(loc, tmp / speed, {x:destination.x, y:destination.y}).ease(Linear.easeNone);
    }

    public function startMove(path:Array<Point>){
        path.reverse();
        this.path = path;
		isMoving = true;
        changeDestination();
    }

    public function getLoc(){
        return new Point(Math.floor(img.x / Tile.WIDTH), Math.floor(img.y / Tile.HEIGHT));
    }

    public function setLoc(newLoc:Point){
        loc.x = newLoc.x * Tile.WIDTH;
        loc.y = newLoc.y * Tile.HEIGHT;
    }

    private function move(){
        center.x = loc.x + img.width / 2;
        center.y = loc.y + img.height / 2;
		img.x = loc.x;
		img.y = loc.y;
		if (path.length > 0 && loc.x == destination.x && loc.y == destination.y) {
            changeDestination();
		} else if(loc.x == destination.x && loc.y == destination.y){
            isMoving = false;
        }
    }

    public function update(){
        if(isMoving) move();

        // check if player hits a specific tile
        var xLoc = Math.floor(center.x / Tile.WIDTH);
        var yLoc = Math.floor(center.y / Tile.HEIGHT);
        var test = Std.int(yLoc * Main.WIDTH + xLoc);
        var tile = Main.instance.level.getTile(test);
        if(tile == Tile.WALL){
            Actuate.stop(loc);
            isMoving = false;
        } else if(tile == Tile.PICKUP){
            Main.instance.level.replaceTile(test, Tile.BG);
        } else if(tile == Tile.EXIT){
            Actuate.stop(loc);
            Main.instance.level.changeMap(++Main.instance.level.id);
        }
    }
}
