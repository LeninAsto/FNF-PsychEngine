/*
You need to rename this file to the state it will affect, the main one you need to create is TitleState.hx
Although you can also create from MainMenuState.hx

Like a state script, only onCreate, onUpdate and onDestroy are used, but there are differences:

*/

function onCreate()
{
    // This is called before super.create()
}

function onCreatePost()
{
    // This is called after super.create()
}

function onUpdate(elapsed)
{
    // This is called before super.update()
}

function onUpdatePost(elapsed)
{
    // This is called after super.update()
}

function onDestroy()
{
    // This is called before super.destroy()
}

function onDestroyPost()
{
    // This is called after super.destroy()
}   

// From here you can create your own functions and variables

/*
====================================
AVAILABLE HSCRIPT VARIABLES FOR CUSTOMSTATES
====================================

- Almost all states can be imported
- GameplayChangersSubstate
- Difficulty
- WeekData
- Discord
- RatioScaleMode
- Capabilities
- ModState
- MusicBeatState
- Highscore
- Song
- FlxAxes
- FlxTypedGroup
- FlxCamera
- FlxFlicker
- And more...

====================================
AVAILABLE VARIABLES FOR CUSTOMSTATES
====================================

1. stateName (String)
   - The name of the current state
   - Example: var name = stateName; // "TitleState"
   - Useful for: Knowing which state you're currently in

2. persistentUpdate (Bool)
   - Controls whether the state continues updating when another state is opened on top
   - Example: persistentUpdate = true; // The state will continue updating
   - Default: Scripts can control it individually
   - Useful for: Keeping animations or music active in overlapping states

3. persistentDraw (Bool)
   - Controls whether the state continues drawing when another state is opened on top
   - Example: persistentDraw = true; // The state will remain visible
   - Default: true
   - Useful for: Creating overlays or menus that show the previous state

====================================
SHARED VARIABLES SYSTEM
====================================
These functions allow you to share data between different custom ModStates:

4. setSharedVar(name, value)
   - Saves a variable that other states can read
   - Example: setSharedVar('playerScore', 1000);
   - Example: setSharedVar('playerName', 'Lenin');
   - Useful for: Passing data between custom states

5. getSharedVar(name, ?defaultValue)
   - Gets a previously saved shared variable
   - Example: var score = getSharedVar('playerScore', 0);
   - If the variable doesn't exist, returns the defaultValue
   - Useful for: Retrieving data from previous states

6. hasSharedVar(name)
   - Checks if a shared variable exists
   - Example: if (hasSharedVar('playerScore')) { ... }
   - Returns: true if it exists, false if not
   - Useful for: Checking before getting a variable

7. removeSharedVar(name)
   - Removes a specific shared variable
   - Example: removeSharedVar('playerScore');
   - Returns: true if removed, false if it didn't exist
   - Useful for: Cleaning up data you no longer need

8. clearSharedVars()
   - Removes ALL shared variables
   - Example: clearSharedVars();
   - WARNING! This clears the entire shared variables system
   - Useful for: Completely resetting when exiting the mod

====================================
STATE SWITCHING SYSTEM
======================================

To switch to another state, DO NOT use FlxG.switchState directly.
Instead, assign the new state to the 'nextState' variable:

Example to go to MainMenuState:
   nextState = new MainMenuState();

Example to go to another custom ModState:
   nextState = new ModState('MyCustomState');

The switch will happen automatically in the next frame.

====================================
PRACTICAL EXAMPLE - SCORE SYSTEM
======================================

// In TitleState.hx
function onCreate() {
    clearSharedVars(); // Clear previous data
    setSharedVar('difficulty', 'normal');
}

// In MainMenuState.hx
function onCreate() {
    var dif = getSharedVar('difficulty', 'easy');
    trace('Current difficulty: ' + dif);
}

// Switch to PlayState
function onUpdate(elapsed) {
    if (controls.ACCEPT) {
        setSharedVar('maxScore', 5000);
        nextState = new PlayState(); // Switch state
    }
}
====================================
HOW DO I SWITCH STATES?
====================================

Good question my favorite silly, what you have to do is simple

To switch between ModStates you have to do this:

- MusicBeatState.switchState(new ModState('StateName'));

The "State Name" is the name of the .hx file you created in /mods/yourmod/states/StateName.hx

To switch to a normal state you do this:

- MusicBeatState.switchState(new StateName());

This will normally switch to the engine state you want.

====================================
IMPORTANT NOTES
======================================

- Shared variables (sharedVars) are STATIC, they persist between all ModStates
- Only use nextState to switch states, never FlxG.switchState directly
- The stateName is defined when creating the ModState: new ModState('StateName')
- Scripts are automatically loaded from: mods/yourmod/states/StateName.hx
- persistentUpdate and persistentDraw are useful for substates and overlapping menus

*/
