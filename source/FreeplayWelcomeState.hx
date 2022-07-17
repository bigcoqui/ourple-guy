package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FreeplayWelcomeState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var bg:FlxSprite;

	override function create()
	{
		super.create();

		bg = new FlxSprite().loadGraphic(Paths.image('freeplaywelcome', 'preload'));
        bg.screenCenter();
		add(bg);

		#if android
		addVirtualPad(NONE, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FirstTimeFreeplay.firstTimeFreeplay = false;
					FirstTimeFreeplay.saveShit();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(bg, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new FreeplayState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(bg, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new MainMenuState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
