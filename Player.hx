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

    public function new(){
        super();

        img = new Bitmap(Assets.getBitmapData("assets/player.png"));
        addChild(img);

        loc = new Point(img.x, img.y);
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
        img.x = newLoc.x * Tile.WIDTH;
        img.y = newLoc.y * Tile.HEIGHT;
    }

    private function move(){
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
    }
}
