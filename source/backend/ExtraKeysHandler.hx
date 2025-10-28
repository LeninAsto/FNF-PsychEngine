package backend;

import flixel.input.keyboard.FlxKey;

class ExtraKeysHandler {
    public static var instance:ExtraKeysHandler;

    public var data:ExtraKeysData;

    public function new() {
        reloadExtraKeys();
    }

    public function reloadExtraKeys() {
        trace('Loading Extra Keys data...');

        var parser = new json2object.JsonParser<ExtraKeysData>();
        var dataPath:String = 'data/extrakeys.json';
        var dataText:String = Paths.getTextFromFile(dataPath);
		parser.fromJson(dataText);
		data = parser.value;

        trace('Load complete.');
    }

    public function getIndex(mania:Int, note:Int):Int {
        if (data == null || data.keys == null) return note;
        var maniaIndex = mania - 1; // mania=4 -> índice 3
        if (maniaIndex < 0 || maniaIndex >= data.keys.length) return note;
        var keySet = data.keys[maniaIndex];
        if (keySet == null || keySet.notes == null) return note;
        if (note < 0 || note >= keySet.notes.length) return note;
        return keySet.notes[note];
    }

    public function getAnimSet(index:Int):EKAnimation {
        if (data == null || data.animations == null) return null;
        if (index < 0 || index >= data.animations.length) return null;
        return data.animations[index];
    }

    public function keysToIndex(numKeys:Int):Int {
        return numKeys - 1; // Convertir mania a índice del array (mania=4 -> índice 3)
    }

    public function getKeyNames(numKeys:Int):Array<String> {
        // Devolver los nombres de las teclas que coinciden con ClientPrefs
        switch(numKeys) {
            case 1: return ['note_one1'];
            case 2: return ['note_two1', 'note_two2'];
            case 3: return ['note_three1', 'note_three2', 'note_three3'];
            case 4: return ['note_left', 'note_down', 'note_up', 'note_right'];
            case 5: return ['note_five1', 'note_five2', 'note_five3', 'note_five4', 'note_five5'];
            case 6: return ['note_six1', 'note_six2', 'note_six3', 'note_six4', 'note_six5', 'note_six6'];
            case 7: return ['note_seven1', 'note_seven2', 'note_seven3', 'note_seven4', 'note_seven5', 'note_seven6', 'note_seven7'];
            case 8: return ['note_eight1', 'note_eight2', 'note_eight3', 'note_eight4', 'note_eight5', 'note_eight6', 'note_eight7', 'note_eight8'];
            case 9: return ['note_nine1', 'note_nine2', 'note_nine3', 'note_nine4', 'note_nine5', 'note_nine6', 'note_nine7', 'note_nine8', 'note_nine9'];
            case 10: return ['note_ten1', 'note_ten2', 'note_ten3', 'note_ten4', 'note_ten5', 'note_ten6', 'note_ten7', 'note_ten8', 'note_ten9', 'note_ten10'];
            case 11: return ['note_elev1', 'note_elev2', 'note_elev3', 'note_elev4', 'note_elev5', 'note_elev6', 'note_elev7', 'note_elev8', 'note_elev9', 'note_elev10', 'note_elev11'];
            case 12: return ['note_twelve1', 'note_twelve2', 'note_twelve3', 'note_twelve4', 'note_twelve5', 'note_twelve6', 'note_twelve7', 'note_twelve8', 'note_twelve9', 'note_twelve10', 'note_twelve11', 'note_twelve12'];
            case 13: return ['note_thirteen1', 'note_thirteen2', 'note_thirteen3', 'note_thirteen4', 'note_thirteen5', 'note_thirteen6', 'note_thirteen7', 'note_thirteen8', 'note_thirteen9', 'note_thirteen10', 'note_thirteen11', 'note_thirteen12', 'note_thirteen13'];
            case 14: return ['note_fourteen1', 'note_fourteen2', 'note_fourteen3', 'note_fourteen4', 'note_fourteen5', 'note_fourteen6', 'note_fourteen7', 'note_fourteen8', 'note_fourteen9', 'note_fourteen10', 'note_fourteen11', 'note_fourteen12', 'note_fourteen13', 'note_fourteen14'];
            case 15: return ['note_fifteen1', 'note_fifteen2', 'note_fifteen3', 'note_fifteen4', 'note_fifteen5', 'note_fifteen6', 'note_fifteen7', 'note_fifteen8', 'note_fifteen9', 'note_fifteen10', 'note_fifteen11', 'note_fifteen12', 'note_fifteen13', 'note_fifteen14', 'note_fifteen15'];
            case 16: return ['note_sixteen1', 'note_sixteen2', 'note_sixteen3', 'note_sixteen4', 'note_sixteen5', 'note_sixteen6', 'note_sixteen7', 'note_sixteen8', 'note_sixteen9', 'note_sixteen10', 'note_sixteen11', 'note_sixteen12', 'note_sixteen13', 'note_sixteen14', 'note_sixteen15', 'note_sixteen16'];
            case 17: return ['note_seventeen1', 'note_seventeen2', 'note_seventeen3', 'note_seventeen4', 'note_seventeen5', 'note_seventeen6', 'note_seventeen7', 'note_seventeen8', 'note_seventeen9', 'note_seventeen10', 'note_seventeen11', 'note_seventeen12', 'note_seventeen13', 'note_seventeen14', 'note_seventeen15', 'note_seventeen16', 'note_seventeen17'];
            case 18: return ['note_eighteen1', 'note_eighteen2', 'note_eighteen3', 'note_eighteen4', 'note_eighteen5', 'note_eighteen6', 'note_eighteen7', 'note_eighteen8', 'note_eighteen9', 'note_eighteen10', 'note_eighteen11', 'note_eighteen12', 'note_eighteen13', 'note_eighteen14', 'note_eighteen15', 'note_eighteen16', 'note_eighteen17', 'note_eighteen18'];
            default: return ['note_left', 'note_down', 'note_up', 'note_right']; // 4K por defecto
        }
    }
}

class ExtraKeysData {
    // indexing
    public var keys:Array<EKManiaMode>;

    // these are only used to set the colors into your save data!
    public var colors:Array<EKNoteColor>;
    public var pixelNoteColors:Array<EKNoteColor>;

    public var animations:Array<EKAnimation>;
    public var maxKeys:Int;
    public var minKeys:Int;

    // these are used to set your keybinds into your save data!
    // also used when you click the Default Reset button
    public var keybinds:Array<Array<Array<Int>>>;

    // I said i wouldnt, but here it is! Anyway...
    public var scales:Array<Float>;

    // I also said this wouldnt be here
    public var pixelScales:Array<Float>;
}

class EKManiaMode {
    // 4k = 0,1,2,3
    public var notes:Array<Int>;
}

class EKNoteColor {
    public var inner:String;
    public var border:String;
    public var outline:String;

    public function new(){}
}

class EKAnimation {
    // arrowLEFT
    public var strum:String;

    // left confirm
    public var anim:String;

    // purple hold end
    public var note:String;

    // singLEFT
    public var sing:String;

    // 0
    public var pixel:Int;
}