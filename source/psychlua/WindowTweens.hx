package psychlua;

import openfl.Lib;
import openfl.system.Capabilities;
import openfl.display.StageDisplayState;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.util.FlxColor;
import states.PlayState;

#if windows
import winapi.WindowsAPI;
#end

class WindowTweens {
    public static function winTweenX(tag:String, targetX:Int, duration:Float = 1, ease:String = "linear", ?onComplete:Void->Void) {
        #if windows
        var window = Lib.current.stage.window;
        var startX = window.x;
        var variables = MusicBeatState.getVariables();
        if(tag != null) {
            var originalTag:String = tag;
            tag = LuaUtils.formatVariable('wintween_$tag');
            variables.set(tag, FlxTween.num(startX, targetX, duration, {
                ease: LuaUtils.getTweenEaseByString(ease),
                onUpdate: function(tween:FlxTween) {
                    window.x = Std.int(FlxMath.lerp(startX, targetX, tween.percent));
                },
                onComplete: function(_) {
                    variables.remove(tag);
                    if (onComplete != null) onComplete();
                    if(PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [originalTag, 'window.x']);
                }
            }));
            return tag;
        } else {
            FlxTween.num(startX, targetX, duration, {
                ease: LuaUtils.getTweenEaseByString(ease),
                onUpdate: function(tween:FlxTween) {
                    window.x = Std.int(FlxMath.lerp(startX, targetX, tween.percent));
                },
                onComplete: function(_) {
                    if (onComplete != null) onComplete();
                }
            });
        }
        #end
        return null;
    }

    public static function winTweenY(tag:String, targetY:Int, duration:Float = 1, ease:String = "linear", ?onComplete:Void->Void) {
        #if windows
        var window = Lib.current.stage.window;
        var startY = window.y;
        var variables = MusicBeatState.getVariables();
        if(tag != null) {
            var originalTag:String = tag;
            tag = LuaUtils.formatVariable('wintween_$tag');
            variables.set(tag, FlxTween.num(startY, targetY, duration, {
                ease: LuaUtils.getTweenEaseByString(ease),
                onUpdate: function(tween:FlxTween) {
                    window.y = Std.int(FlxMath.lerp(startY, targetY, tween.percent));
                },
                onComplete: function(_) {
                    variables.remove(tag);
                    if (onComplete != null) onComplete();
                    if(PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [originalTag, 'window.y']);
                }
            }));
            return tag;
        } else {
            FlxTween.num(startY, targetY, duration, {
                ease: LuaUtils.getTweenEaseByString(ease),
                onUpdate: function(tween:FlxTween) {
                    window.y = Std.int(FlxMath.lerp(startY, targetY, tween.percent));
                },
                onComplete: function(_) {
                    if (onComplete != null) onComplete();
                }
            });
        }
        #end
        return null;
    }
    
    public static function setWindowBorderless(enable:Bool) {
    #if windows
    var window = Lib.current.stage.window;
    window.borderless = enable;
    #end
    }

    public static function setWindowX(x:Int) {
        #if windows
        var window = Lib.current.stage.window;
        window.x = x;
        #end
    }

    public static function setWindowY(y:Int) {
        #if windows
        var window = Lib.current.stage.window;
        window.y = y;
        #end
    }

    public static function setWindowSize(width:Int, height:Int) {
        #if windows
        var window = Lib.current.stage.window;
        window.resize(width, height);
        #end
    }

    public static function getWindowX():Int {
        #if windows
        var window = Lib.current.stage.window;
        return window.x;
        #else
        return 0;
        #end
    }

    public static function getWindowY():Int {
        #if windows
        var window = Lib.current.stage.window;
        return window.y;
        #else
        return 0;
        #end
    }

    public static function getWindowWidth():Int {
        #if windows
        var window = Lib.current.stage.window;
        return window.width;
        #else
        return FlxG.width;
        #end
    }

    public static function getWindowHeight():Int {
        #if windows
        var window = Lib.current.stage.window;
        return window.height;
        #else
        return FlxG.height;
        #end
    }

    public static function centerWindow() {
        #if windows
        var window = Lib.current.stage.window;
        var screenWidth = Capabilities.screenResolutionX;
        var screenHeight = Capabilities.screenResolutionY;
        window.x = Std.int((screenWidth - window.width) / 2);
        window.y = Std.int((screenHeight - window.height) / 2);
        #end
    }

    public static function setWindowTitle(title:String) {
        #if windows
        var window = Lib.current.stage.window;
        window.title = title;
        #end
    }

    public static function getWindowTitle():String {
        #if windows
        var window = Lib.current.stage.window;
        return window.title;
        #else
        return "";
        #end
    }

    public static function setWindowIcon(iconPath:String) {
        #if windows
        try {
            var window = Lib.current.stage.window;
            var iconBitmap = openfl.display.BitmapData.fromFile(iconPath);
            if (iconBitmap != null) {
                window.setIcon(lime.graphics.Image.fromBitmapData(iconBitmap));
            }
        } catch (e:Dynamic) {
            trace('Error setting window icon: $e');
        }
        #end
    }

    public static function setWindowResizable(enable:Bool) {
        #if windows
        var window = Lib.current.stage.window;
        window.resizable = enable;
        #end
    }

    public static function randomizeWindowPosition(minX:Int = 0, maxX:Int = -1, minY:Int = 0, maxY:Int = -1) {
        #if windows
        var window = Lib.current.stage.window;
        var screenWidth = Capabilities.screenResolutionX;
        var screenHeight = Capabilities.screenResolutionY;
        
        // Use screen bounds if not specified
    if (maxX == -1) maxX = Std.int(screenWidth - window.width);
    if (maxY == -1) maxY = Std.int(screenHeight - window.height);
        
        // Ensure mins don't exceed maxs
        minX = Std.int(Math.min(minX, maxX));
        minY = Std.int(Math.min(minY, maxY));
        
        var randomX = Std.int(minX + Math.random() * (maxX - minX));
        var randomY = Std.int(minY + Math.random() * (maxY - minY));
        
        window.x = randomX;
        window.y = randomY;
        #end
    }

    public static function getScreenResolution():{width:Int, height:Int} {
        return {
            width: Std.int(Capabilities.screenResolutionX),
            height: Std.int(Capabilities.screenResolutionY)
        };
    }

    public static function setWindowFullscreen(enable:Bool) {
        #if windows
        var window = Lib.current.stage.window;
        window.fullscreen = enable;
        #end
    }

    public static function isWindowFullscreen():Bool {
        #if windows
        var window = Lib.current.stage.window;
        return window.fullscreen;
        #else
        return false;
        #end
    }

    public static function saveWindowState():String {
        #if windows
        var window = Lib.current.stage.window;
        var state = {
            x: window.x,
            y: window.y,
            width: window.width,
            height: window.height,
            borderless: window.borderless,
            resizable: window.resizable,
            title: window.title
        };
        return haxe.Json.stringify(state);
        #else
        return "{}";
        #end
    }

    public static function loadWindowState(stateJson:String) {
        #if windows
        try {
            var state = haxe.Json.parse(stateJson);
            var window = Lib.current.stage.window;
            
            if (state.x != null) window.x = state.x;
            if (state.y != null) window.y = state.y;
            if (state.width != null && state.height != null) {
                window.resize(state.width, state.height);
                FlxG.resizeGame(state.width, state.height);
            }
            if (state.borderless != null) window.borderless = state.borderless;
            if (state.resizable != null) window.resizable = state.resizable;
            if (state.title != null) window.title = state.title;
        } catch (e:Dynamic) {
            trace('Error loading window state: $e');
        }
        #end
    }

    public static function winTweenSize(targetW:Int, targetH:Int, duration:Float = 1, ease:String = "linear", ?onComplete:Void->Void) {
        #if windows
        var window = Lib.current.stage.window;
        var startW = window.width;
        var startH = window.height;

        // Cambia el modo de escala para que el juego se estire con la ventana
        FlxG.scaleMode = new flixel.system.scaleModes.RatioScaleMode();

        FlxTween.num(0, 1, duration, {
            ease: LuaUtils.getTweenEaseByString(ease),
            onUpdate: function(tween:FlxTween) {
                window.resize(
                    Std.int(FlxMath.lerp(startW, targetW, tween.percent)),
                    Std.int(FlxMath.lerp(startH, targetH, tween.percent))
                );
                FlxG.resizeGame(window.width, window.height);
            },
            onComplete: function(_) {
                if (onComplete != null) onComplete();
            }
        });
        #end
    }

    public static function winResizeCenter(width:Int, height:Int, ?skip:Bool = false, ?markAsResized:Bool = true) {
        #if windows
        if (markAsResized && PlayState.instance != null) {
            PlayState.instance.windowResizedByScript = true;
        }
        var window = Lib.application.window;
        var winYRatio = 1;
        var winY = height * winYRatio;
        var winX = width * winYRatio;

        FlxTween.cancelTweensOf(window);
        if (!skip) {
            FlxTween.tween(window, {
                width: winX,
                height: winY,
                y: Math.floor((Capabilities.screenResolutionY / 2) - (winY / 2)),
                x: Math.floor((Capabilities.screenResolutionX / 2) - (winX / 2)) + (Capabilities.screenResolutionX * Math.floor(window.x / (Capabilities.screenResolutionX)))
            }, 0.4, {
                ease: FlxEase.quadInOut,
                onComplete: function(_) {
                    if (PlayState.instance != null && PlayState.instance.camHUD != null) {
                        PlayState.instance.camHUD.fade(FlxColor.BLACK, 0, true);
                    }
                }
            });
        } else {
            FlxG.resizeWindow(width, height);
            window.y = Math.floor((Capabilities.screenResolutionY / 2) - (winY / 2));
            window.x = Std.int(Math.floor((Capabilities.screenResolutionX / 2) - (winX / 2)) + (Capabilities.screenResolutionX * Math.floor(window.x / (Capabilities.screenResolutionX))));
        }
        FlxG.scaleMode = new RatioScaleMode(true);
        window.resizable = width == 1280;
        #end
    }

    public static function getWindowState():String {
        #if windows
        try {
            // Función simplificada sin acceso directo a Windows API
            var window = Lib.current.stage.window;
            if (window.fullscreen) return "fullscreen";
            return "normal";
        } catch (e:Dynamic) {
            trace('Error getting window state: $e');
            return "error";
        }
        #else
        return "normal";
        #end
    }

    public static function setDesktopWallpaper(path:String) {
        #if windows
        try {
            WindowsAPI.setWallpaper(path);
        } catch (e:Dynamic) {
            trace('Error setting wallpaper: $e');
        }
        #end
    }

    public static function hideDesktopIcons(hide:Bool) {
        #if windows
        try {
            WindowsAPI.hideDesktopIcons(hide);
        } catch (e:Dynamic) {
            trace('Error hiding desktop icons: $e');
        }
        #end
    }

    public static function hideTaskBar(hide:Bool) {
        #if windows
        try {
            WindowsAPI.hideTaskbar(hide);
        } catch (e:Dynamic) {
            trace('Error hiding taskbar: $e');
        }
        #end
    }

    public static function moveDesktopElements(x:Int, y:Int) {
        #if windows
        try {
            WindowsAPI.moveDesktopWindowsInXY(x, y);
        } catch (e:Dynamic) {
            trace('Error moving desktop elements: $e');
        }
        #end
    }

    public static function setDesktopTransparency(alpha:Float) {
        #if windows
        try {
            var clampedAlpha = Math.max(0.0, Math.min(1.0, alpha));
            WindowsAPI.setDesktopWindowsAlpha(clampedAlpha);
        } catch (e:Dynamic) {
            trace('Error setting desktop transparency: $e');
        }
        #end
    }

    public static function setTaskBarTransparency(alpha:Float) {
        #if windows
        try {
            var clampedAlpha = Math.max(0.0, Math.min(1.0, alpha));
            WindowsAPI.setTaskBarAlpha(clampedAlpha);
        } catch (e:Dynamic) {
            trace('Error setting taskbar transparency: $e');
        }
        #end
    }

    public static function getCursorPosition():{x:Int, y:Int} {
        #if windows
        try {
            return {
                x: WindowsAPI.getCursorPositionX(),
                y: WindowsAPI.getCursorPositionY()
            };
        } catch (e:Dynamic) {
            trace('Error getting cursor position: $e');
            return {x: 0, y: 0};
        }
        #else
        return {x: 0, y: 0};
        #end
    }

    public static function getSystemRAM():Int {
        #if windows
        try {
            return WindowsAPI.obtainRAM();
        } catch (e:Dynamic) {
            trace('Error getting system RAM: $e');
            return 0;
        }
        #else
        return 0;
        #end
    }

    public static function showNotification(title:String, message:String) {
        #if windows
        try {
            WindowsAPI.sendWindowsNotification(title, message);
        } catch (e:Dynamic) {
            trace('Error showing notification: $e');
        }
        #end
    }

    public static function resetSystemChanges() {
        #if windows
        try {
            WindowsAPI.resetWindowsFuncs();
        } catch (e:Dynamic) {
            trace('Error resetting system changes: $e');
        }
        #end
    }
}