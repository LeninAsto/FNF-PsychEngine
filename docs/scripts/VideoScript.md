# Video Script Guide for FNF PlusEngine

This guide will help you play videos in your charts using **Haxe**.

## 📋 Requirements

- Video file in `.mp4` format inside the `mods/"modname"/videos/` folder

## 🎬 Basic Implementation

```haxe
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxCamera;
import backend.Conductor;
import Main;

var myVideo:FlxVideoSprite;
var videoArray:Array<FlxVideoSprite> = [];
var videosToDestroy:Array<FlxVideoSprite> = [];

function onCreate()
{
    FlxG.autoPause = false;

    myVideo = new FlxVideoSprite();
    myVideo.load(Paths.video('videoName')); // No extension

    videoArray = [myVideo];
    
    for (i in videoArray)
    {
        i.bitmap.rate = game.playbackRate;
        i.alpha = 0.001;
        i.cameras = [game.camOther];
        game.add(i);
    }
}

function onCreatePost()
{
    for (i in videoArray)
    {
        i.play();
        new FlxTimer().start(0.0001, function(tmr) {
            i.pause();
            i.bitmap.time = 0;
        });
    }

    FlxG.autoPause = true;
}

function onSongStart() 
{
    playVideo(myVideo, 15.0); // Duration in seconds
}

function playVideo(vid:FlxVideoSprite, endTime:Float)
{
    vid.screenCenter();
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.resume();

    new FlxTimer().start(endTime / game.playbackRate, function(tmr) {
        vid.alpha = 0.001;
        videosToDestroy.push(vid);
    });
}

function onPause() {
    for (i in videoArray)
        if (i != null && i.alpha == 1) i.pause();
}

function onResume() {
    for (i in videoArray)
        if (i != null && i.alpha == 1) i.resume();
}

function onUpdatePost(e) {
    for (i in videoArray) if (i.alpha == 1) i.screenCenter();

    if (videosToDestroy.length > 0) 
        for (i in videosToDestroy) 
            if (i != null) i.destroy();
}

function onDestroy() {
    for (i in videoArray) if (i != null) i.destroy();
}
```

## 🎛️ Video Customization

### Change Size

```haxe
// In the playVideo function, after vid.bitmap.time = 0;
vid.scale.set(0.5, 0.5);  // 50% of original size
// Or specific size:
vid.setGraphicSize(640, 360);
vid.updateHitbox();
```

### Change Position

```haxe
// Custom position
vid.x = 100;
vid.y = 50;

// Different positions
vid.screenCenter();           // Center
vid.x = 0; vid.y = 0;        // Top left corner
vid.x = FlxG.width - vid.width; // Top right corner
```

### Change Opacity

```haxe
vid.alpha = 0.8;  // 80% opacity
```

### Change Camera

```haxe
// In onCreate(), change the camera:
i.cameras = [game.camHUD];     // UI/HUD
i.cameras = [game.camGame];    // Main game
i.cameras = [game.camOther];   // Other camera
i.cameras = [FlxG.camera];     // Main camera
```

### Play at Different Times

```haxe
function onStepHit()
{
    switch (curStep)
    {
        case 128:  // Step 128
            playVideo(myVideo, 10.0);
        case 256:  // Step 256
            playVideo(otherVideo, 5.0);
    }
}

function onBeatHit()
{
    if (curBeat == 32) // Beat 32
        playVideo(myVideo, 8.0);
}
```

### Multiple Videos

```haxe
var video1:FlxVideoSprite;
var video2:FlxVideoSprite;
var video3:FlxVideoSprite;

function onCreate()
{
    // ... base code ...
    
    video1 = new FlxVideoSprite();
    video1.load(Paths.video('intro'));
    
    video2 = new FlxVideoSprite();
    video2.load(Paths.video('drop'));
    
    video3 = new FlxVideoSprite();
    video3.load(Paths.video('outro'));

    videoArray = [video1, video2, video3];
    
    // ... rest of the code ...
}

function onStepHit()
{
    switch (curStep)
    {
        case 0:   playVideo(video1, 5.0);   // Intro
        case 512: playVideo(video2, 10.0);  // Drop
        case 1024: playVideo(video3, 8.0);  // Outro
    }
}
```

## 🎨 Special Effects

### Video with Fade In/Out

```haxe
function playVideoWithFade(vid:FlxVideoSprite, endTime:Float)
{
    vid.screenCenter();
    vid.alpha = 0;
    vid.bitmap.time = 0;
    vid.resume();
    
    // Fade In
    FlxTween.tween(vid, {alpha: 1}, 0.5);
    
    // Fade Out before ending
    new FlxTimer().start((endTime - 1.0) / game.playbackRate, function(tmr) {
        FlxTween.tween(vid, {alpha: 0}, 1.0, {
            onComplete: function(tween) {
                videosToDestroy.push(vid);
            }
        });
    });
}
```

### Spinning Video

```haxe
function playVideoSpinning(vid:FlxVideoSprite, endTime:Float)
{
    vid.screenCenter();
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.resume();
    
    // Rotate continuously
    FlxTween.tween(vid, {angle: 360}, 2.0, {type: LOOPING});
    
    new FlxTimer().start(endTime / game.playbackRate, function(tmr) {
        vid.alpha = 0.001;
        videosToDestroy.push(vid);
    });
}
```

### Video with Zoom

```haxe
function playVideoZoom(vid:FlxVideoSprite, endTime:Float)
{
    vid.screenCenter();
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.scale.set(0.1, 0.1);
    vid.resume();
    
    // Zoom In
    FlxTween.tween(vid.scale, {x: 1, y: 1}, 1.0, {ease: FlxEase.elasticOut});
    
    new FlxTimer().start(endTime / game.playbackRate, function(tmr) {
        vid.alpha = 0.001;
        videosToDestroy.push(vid);
    });
}
```

## ⚙️ Advanced Settings

### Playback Speed Control

```haxe
// In onCreate()
vid.bitmap.rate = game.playbackRate * 1.5;  // 1.5x faster
vid.bitmap.rate = game.playbackRate * 0.5;  // 0.5x slower
```

### Looping Video

```haxe
function playVideoLoop(vid:FlxVideoSprite)
{
    vid.screenCenter();
    vid.alpha = 1;
    vid.bitmap.time = 0;
    vid.resume();
    vid.bitmap.onEndReached.add(function() {
        vid.bitmap.time = 0;  // Restart when finished
    });
}
```

### BPM Synchronization

```haxe
function onBeatHit()
{
    // Video every 4 beats
    if (curBeat % 4 == 0)
        playVideoShort(effectVideo, Conductor.stepCrochet * 4 / 1000);
}
```

## 📝 Tips and Best Practices

1. **Video Format**: Use `.mp4` with H.264 codec for best compatibility
2. **Performance**: Smaller videos (resolution and duration) improve performance
3. **Memory**: Always clean up videos with `onDestroy()` to avoid memory leaks
4. **Timing**: Test synchronization at different playback rates
5. **Cameras**: Use `camOther` for videos that shouldn't be affected by camera effects

## 🐛 Troubleshooting

- **Video doesn't appear**: Check that the file is in `mod/"modname"/videos/`
- **Lag**: Lower the video resolution or use compression
- **Synchronization**: Adjust timing values according to your BPM

---

*Enjoy creating epic charts with videos! 🎵🎬*
