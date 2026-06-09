package objects;

// Made by Vaesea, fixed by AnatolyStev
// Well actually it came from Discover Haxeflixel but still

// Note from Vaesea: AnatolyStev meant Area2D probably

import flixel.util.FlxColor;
import echo.Body;
import flixel.FlxObject;
import creatures.player.Tux;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;

using echo.FlxEcho;

class BonusBlock extends FlxSprite
{
    public var content:String;
    public var isEmpty = false;

    public var echoArea2DThing:FlxSprite; // trust me this has something to do with echo

    var blockImage = FlxAtlasFrames.fromSparrow('assets/images/objects/bonusblock.png', 'assets/images/objects/bonusblock.xml');

    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = blockImage;
        animation.addByPrefix('full', 'bonusblock full', 12, false); // I messed up and used default settings for the FNF Spritesheet and XML generator.
        animation.addByPrefix('empty', 'bonusblock empty', 12, false);
        animation.play("full");

        this.add_body({x: this.x + this.width * 0.5, y: this.y + this.height * 0.5, mass: STATIC, kinematic: true, shape: {type: RECT, width: 32, height: 32}, material: {gravity_scale: 0}});

        // really quick thing. sort of as a test but if this works then i guess i'll just go ahead with doing this
        echoArea2DThing = new FlxSprite(this.x + 4, this.y + 32);
        echoArea2DThing.makeGraphic(24, 1, FlxColor.RED);

        // i hope this works
        echoArea2DThing.add_body({x: echoArea2DThing.x + echoArea2DThing.width * 0.5, y: echoArea2DThing.y + echoArea2DThing.height * 0.5, mass: STATIC, shape: {type: RECT, width: 24, height: 1}});

        // please let this work
        echoArea2DThing.add_to_group(Global.PS.blockHitAreas);
    }

    public function hit(tux:Tux)
    {
        if (!isEmpty)
        {
            isEmpty = true;
            createItem();
            var originalY = this.get_body().y;
            FlxTween.tween(this.get_body(), {y: originalY - 8}, 0.06) .wait(0.06) .then(FlxTween.tween(this.get_body(), {y: originalY}, 0.06, {onComplete: empty}));
        }
        else if (isEmpty)
        {
            FlxG.sound.play("assets/sounds/brick.wav");
        }
    }

    // public function sync(_)
    // {
    //     var body = this.get_body();

    //     body.x = this.x + this.width * 0.5;
    //     body.y = this.y + this.height * 0.5;
    // }

    function empty(_)
    {
        animation.play("empty");
    }

    function createItem()
    {
        switch (content)
        {
            default:
                var Coin:Coin = new Coin(Std.int(x), Std.int(y - 32));
                Coin.collect();
                Global.PS.entities.add(Coin);
            
            // case "powerup":
            //     var powerup:PowerUp = new PowerUp(Std.int(x), Std.int(y - 32));
            //     Global.PS.items.add(powerup);
            //     FlxG.sound.play("assets/sounds/upgrade.wav");
            
            // case "star":
            //     var herring:Herring = new Herring(Std.int(x), Std.int(y - 32));
            //     Global.PS.items.add(herring);
            //     FlxG.sound.play("assets/sounds/upgrade.wav");
            
            // case "tuxdoll":
            //     var tuxDoll:TuxDoll = new TuxDoll(Std.int(x), Std.int(y - 32));
            //     Global.PS.td.add(tuxDoll);
            //     FlxG.sound.play("assets/sounds/upgrade.wav");
        }
    }
}