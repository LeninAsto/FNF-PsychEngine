package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import openfl.utils.Assets;
import states.FreeplayState;
import backend.CustomFadeTransition;
import backend.Song;
import states.PlayState;
import backend.MusicBeatState;
import DateTools;

class ResultsState extends MusicBeatState
{
    var bgImage:FlxSprite;
    var songInstrumental:String = "";
    var canRetry:Bool = true;

    var params:Dynamic;

    // Variables animadas
    var animatedScore:Int = 0;
    var animatedEpics:Int = 0;
    var animatedSicks:Int = 0;
    var animatedGoods:Int = 0;
    var animatedBads:Int = 0;
    var animatedShits:Int = 0;
    var animatedMisses:Int = 0;
    var animatedCombo:Int = 0;
    var animatedAccuracy:Float = 0;

    // Referencias a los textos
    var scoreText:FlxText;
    var epics:FlxText;
    var sicks:FlxText;
    var goods:FlxText;
    var bads:FlxText;
    var shits:FlxText;
    var misses:FlxText;
    var comboText:FlxText;
    var accText:FlxText;

    public function new(params:Dynamic)
    {
        super();
        this.params = params;
    }

    override public function create()
    {
        super.create();

        // --- Fondo personalizado ---
        var bgPath = 'assets/shared/images/results.png';
        bgImage = new FlxSprite().loadGraphic(bgPath);
        bgImage.setGraphicSize(FlxG.width, FlxG.height);
        bgImage.updateHitbox();
        add(bgImage);

        // --- Música instrumental ---
        var instPath = params.isMod && params.modFolder != null && params.modFolder != ""
            ? 'mods/${params.modFolder}/songs/${params.songName.toLowerCase()}/Inst.ogg'
            : 'assets/songs/${params.songName.toLowerCase()}/Inst.ogg';
        if (Assets.exists(instPath)) {
            FlxG.sound.playMusic(instPath, 1, true);
        } else {
            // Si no existe, reproduce el freakymenu
            playFreakyMenuMusic(params.isMod, params.modFolder);
        }

        // --- Info superior centrada y más pequeña ---
        var infoWidth = 700;
        var infoX = (FlxG.width - infoWidth) / 2;
        var songAndDiff = '${params.songName} [${params.difficulty}]';
        var modOrGame = params.isMod && params.modFolder != null && params.modFolder != "" ? params.modFolder : "Friday Night Funkin'";
        var now = Date.now();
        var dateStr = DateTools.format(now, "%A - %B %d, %Y %H:%Mhrs");

        var topText = new FlxText(infoX, 18, infoWidth, songAndDiff, 28);
        topText.setFormat("vcr.ttf", 28, FlxColor.WHITE, "center");
        add(topText);

        var modText = new FlxText(infoX, 52, infoWidth, modOrGame, 22);
        modText.setFormat("vcr.ttf", 22, FlxColor.LIME, "center");
        add(modText);

        var playedText = new FlxText(infoX, 78, infoWidth, 'Played on $dateStr', 18);
        playedText.setFormat("vcr.ttf", 18, FlxColor.GRAY, "center");
        add(playedText);

        // --- Score y texto a la izquierda ---
        var scoreY = 140;
        var scoreStr = StringTools.lpad("0", "0", 8);
        var scoreLabel = new FlxText(80, scoreY, 400, "SCORE:", 34);
        scoreLabel.setFormat("vcr.ttf", 34, FlxColor.WHITE, "left");
        add(scoreLabel);

        scoreText = new FlxText(260, scoreY, 400, scoreStr, 48);
        scoreText.setFormat("vcr.ttf", 48, FlxColor.WHITE, "left");
        add(scoreText);

        // --- Judgements en dos columnas, más grandes y más separados ---
        var leftX = 80;
        var rightX = 420;
        var judgY = 220;
        var judgSpacing = 56; // Más espacio

        epics = new FlxText(leftX, judgY, 340, 'EPICS: 0', 32);
        epics.setFormat("vcr.ttf", 32, 0xFFA17FFF, "left");
        add(epics);

        sicks = new FlxText(rightX, judgY, 340, 'SICKS: 0', 32);
        sicks.setFormat("vcr.ttf", 32, 0xFF7FC9FF, "left");
        add(sicks);

        goods = new FlxText(leftX, judgY + judgSpacing, 340, 'GOODS: 0', 32);
        goods.setFormat("vcr.ttf", 32, 0xFF7FFF8E, "left");
        add(goods);

        bads = new FlxText(rightX, judgY + judgSpacing, 340, 'BADS: 0', 32);
        bads.setFormat("vcr.ttf", 32, 0xFF888888, "left");
        add(bads);

        shits = new FlxText(leftX, judgY + judgSpacing * 2, 340, 'SHITS: 0', 32);
        shits.setFormat("vcr.ttf", 32, 0xFFFF7F7F, "left");
        add(shits);

        misses = new FlxText(rightX, judgY + judgSpacing * 2, 340, 'MISSES: 0', 32);
        misses.setFormat("vcr.ttf", 32, FlxColor.RED, "left");
        add(misses);

        // --- Highest Combo y Accuracy más abajo y grandes ---
        comboText = new FlxText(leftX, judgY + judgSpacing * 3 + 24, 700, 'HIGHEST COMBO: 0', 40);
        comboText.setFormat("vcr.ttf", 40, FlxColor.YELLOW, "left");
        add(comboText);

        accText = new FlxText(leftX, judgY + judgSpacing * 3 + 70, 700, 'ACCURACY: 0%', 40);
        accText.setFormat("vcr.ttf", 40, FlxColor.CYAN, "left");
        add(accText);

        // --- Rating grande, fuente menor y ancho ajustado ---
        var ratingLetter = params.ratingName != null ? params.ratingName : "";
        var ratingFC = params.ratingFC != null ? params.ratingFC : "";
        var ratingW = 400;
        var ratingX = FlxG.width - ratingW - 150; // Más a la izquierda (ajusta el 340 a tu gusto)
        var ratingY = judgY + 40;
        var ratingText = new FlxText(ratingX, ratingY, ratingW, ratingLetter, 70);
        ratingText.setFormat("vcr.ttf", 70, FlxColor.YELLOW, "center");
        add(ratingText);

        var fcText = new FlxText(ratingX, ratingY + 90, ratingW, ratingFC, 54); // Fuente más grande
        fcText.setFormat("vcr.ttf", 54, FlxColor.CYAN, "center");
        add(fcText);

        // --- Mensaje de práctica ---
        var yBottom = FlxG.height - 110;
        if (params.isPractice != null && params.isPractice) {
            var practiceText = new FlxText(0, yBottom, FlxG.width, "Played in practice mode", 22);
            practiceText.setFormat("vcr.ttf", 22, FlxColor.YELLOW, "center");
            add(practiceText);
            yBottom += 28;
        }

        // --- Versiones arriba del texto de continuar ---
        var engineInfo = "Plus Engine v" + MainMenuState.plusEngineVersion + " | Psych Engine v" + MainMenuState.psychEngineVersion + " | Friday Night Funkin' v0.2.8";
        var engineText = new FlxText(0, FlxG.height - 58, FlxG.width, engineInfo, 22);
        engineText.setFormat("vcr.ttf", 22, FlxColor.CYAN, "center");
        add(engineText);

        // --- Instrucción solo ENTER ---
        var continueText = new FlxText(0, FlxG.height - 34, FlxG.width, "PRESS ENTER FOR CONTINUE", 26);
        continueText.setFormat("vcr.ttf", 26, FlxColor.WHITE, "center");
        add(continueText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // 1. Score
        if (animatedScore < params.score) {
            animatedScore += Math.ceil((params.score - animatedScore) * 0.2 + 1);
            if (animatedScore > params.score) animatedScore = params.score;
            scoreText.text = StringTools.lpad(Std.string(animatedScore), "0", 8);
            return;
        }
        scoreText.text = StringTools.lpad(Std.string(animatedScore), "0", 8);

        // 2. Epics
        if (animatedEpics < params.epics) {
            animatedEpics = animateInt(animatedEpics, params.epics);
            epics.text = 'EPICS: $animatedEpics';
            return;
        }
        epics.text = 'EPICS: $animatedEpics';

        // 3. Sicks
        if (animatedSicks < params.sicks) {
            animatedSicks = animateInt(animatedSicks, params.sicks);
            sicks.text = 'SICKS: $animatedSicks';
            return;
        }
        sicks.text = 'SICKS: $animatedSicks';

        // 4. Goods
        if (animatedGoods < params.goods) {
            animatedGoods = animateInt(animatedGoods, params.goods);
            goods.text = 'GOODS: $animatedGoods';
            return;
        }
        goods.text = 'GOODS: $animatedGoods';

        // 5. Bads
        if (animatedBads < params.bads) {
            animatedBads = animateInt(animatedBads, params.bads);
            bads.text = 'BADS: $animatedBads';
            return;
        }
        bads.text = 'BADS: $animatedBads';

        // 6. Shits
        if (animatedShits < params.shits) {
            animatedShits = animateInt(animatedShits, params.shits);
            shits.text = 'SHITS: $animatedShits';
            return;
        }
        shits.text = 'SHITS: $animatedShits';

        // 7. Misses
        if (animatedMisses < params.misses) {
            animatedMisses = animateInt(animatedMisses, params.misses);
            misses.text = 'MISSES: $animatedMisses';
            return;
        }
        misses.text = 'MISSES: $animatedMisses';

        // 8. Highest Combo
        if (animatedCombo < params.maxCombo) {
            animatedCombo = animateInt(animatedCombo, params.maxCombo);
            comboText.text = 'HIGHEST COMBO: $animatedCombo';
            return;
        }
        comboText.text = 'HIGHEST COMBO: $animatedCombo';

        // 9. Accuracy
        if (animatedAccuracy < params.accuracy) {
            animatedAccuracy += (params.accuracy - animatedAccuracy) * 0.2 + 0.1;
            if (animatedAccuracy > params.accuracy) animatedAccuracy = params.accuracy;
            accText.text = 'ACCURACY: ' + Std.string(Math.round(animatedAccuracy * 1000) / 10) + '%';
            return;
        }
        accText.text = 'ACCURACY: ' + Std.string(Math.round(animatedAccuracy * 1000) / 10) + '%';

        // --- Aquí puedes poner el resto de tu lógica, como la transición con ENTER ---
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.music.stop();
            playFreakyMenuMusic(params.isMod, params.modFolder);
            MusicBeatState.switchState(new FreeplayState());
        }
    }

    function playFreakyMenuMusic(isMod:Bool, modFolder:String)
    {
        FlxG.sound.music.stop();
        FlxG.sound.music.volume = 1;
        var tried = false;
        var path = isMod ? 'mods/$modFolder/music/freakyMenu.ogg' : 'assets/music/freakyMenu.ogg';
        if (Assets.exists(path)) {
            FlxG.sound.playMusic(path, 1, true);
            tried = true;
        }
        if (!tried && Assets.exists("assets/shared/music/freakyMenu.ogg")) {
            FlxG.sound.playMusic("assets/shared/music/freakyMenu.ogg", 1, true);
            tried = true;
        }
        if (!tried && Assets.exists("assets/music/freakyMenu.ogg")) {
            FlxG.sound.playMusic("assets/music/freakyMenu.ogg", 1, true);
        }
    }

    // Función auxiliar para animar enteros
    function animateInt(current:Int, target:Int):Int {
        if (current < target)
            return current + Math.ceil((target - current) * 0.2 + 1);
        return target;
    }
}

