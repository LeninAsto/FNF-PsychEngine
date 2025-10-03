## Modcharting Functions
```lua
-- You must enter all of this only within this function, or else it will not work.
function onInitModchart()

    -- [Modifiers Section] --

    -- Search a modifier by `mod` and adds it.

    -- mod:String   The modifier name string
    -- field:Int    The playfield number  (-1 by default)

    addModifier(mod, field);

    -- Adds or rewrites the percent of `mod`and sets it to `value`

    -- mod:String   The modifier name string
    -- value:Float  The value to be assigned to the modifier.
    -- field:Int    The playfield number  (-1 by default)

    setPercent(mod, value, field);

    -- Returns the percent of `mod`

    -- mod:String   The modifier name string
    -- field:Int    The playfield number  (-1 by default)

    -- returns: Float

    getPercent(mod, field);

    -- Registers a new modifier in the name of `modN`

    -- modN:String  The modifier name string
    -- mod:Modifier The custom modifier class instance.

    registerModifier(modN, mod);

    -- [Events Section] --

    -- Adds or rewrites the percentage of `mod` and sets it to `value`
    -- when the specified beat is reached.

    -- mod:String   The modifier name string
    -- beat:Float   The beat number where the event will be executed.
    -- value:Float  The value to be assigned to the modifier.
    -- player:Int   The player/strumline number (-1 by default)
    -- field:Int    The playfield number  (-1 by default)

    set(mod, beat, value, player, field);

    -- Tweens the percentage of `mod` from its current value to `value`
    -- over the specified duration, using the provided easing function.

    -- mod:String   The modifier name string
    -- beat:Float   The beat number where the event will be executed.
    -- length:Float The tween duration in beats.
    -- ease:F->F    The ease function (Float to Float)
    -- value:Float  The value to be assigned to the modifier.
    -- player:Int   The player/strumline number (-1 by default)
    -- field:Int    The playfield number  (-1 by default)

    ease(mod, beat, length, value, ease, player, field);

    -- Execute the callback function when the specified beat is reached.

    -- beat:Float   The beat number where the event will be executed.
    -- func:V->V    The modifier name string
    -- field:Int    The playfield number  (-1 by default)

    callback(beat, func, field);

    -- Repeats the execution of the callback function for the specified duration,
    -- starting at the given beat.

    -- beat:Float   The beat number where the event will be executed.
    -- length:Float The repeater duration in beats.
    -- func:V->V    The modifier name string
    -- field:Int    The playfield number  (-1 by default)

    repeater(beat, length, func, field);

    -- Adds a custom event.
    
    -- event:Event  The custom event to be added.
    -- field:Int    The playfield number  (-1 by default)

    addEvent(event, field);

    -- [Playfield Section] --
    
    -- Adds a new playfield.
    
    -- WARNING: If you add a playfield after adding modifiers, you will have to add them again to the new playfield.
    
    addPlayfield();
end
```