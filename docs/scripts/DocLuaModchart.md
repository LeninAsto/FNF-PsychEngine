# Sistema de Modchart - Documentación Completa

## 📚 Índice
1. [Diferencias entre Lua y Haxe](#diferencias-lua-vs-haxe)
2. [Sistema de Eventos](#sistema-de-eventos)
3. [Funciones de Modchart](#funciones-de-modchart)
4. [Ejemplos Prácticos](#ejemplos-prácticos)

---

## Diferencias Lua vs Haxe

### **Lua (Recomendado para principiantes)**
- ✅ **Más simple y directo** - No requiere compilación
- ✅ **Hot reload** - Puedes editar en tiempo real
- ✅ **Menos propenso a errores** - El engine maneja la mayoría de casos
- ✅ **Ideal para modcharts** - Diseñado específicamente para esto
- ❌ **Menos control** - No puedes crear eventos completamente personalizados
- ❌ **Performance ligeramente menor** - Pero imperceptible en la mayoría de casos

**Cuándo usar Lua:**
- Quieres hacer modcharts estándar (efectos visuales, movimientos de flechas)
- Necesitas iterar rápidamente sin recompilar
- Prefieres sintaxis simple y legible
- Estás empezando con modcharts

### **Haxe (Para usuarios avanzados)**
- ✅ **Control total** - Acceso directo al Manager y PlayField
- ✅ **Performance máxima** - Código compilado nativamente
- ✅ **Tipos personalizados** - Puedes crear tus propios eventos y modificadores
- ✅ **Acceso a APIs internas** - Todo el sistema de modchart
- ❌ **Requiere compilación** - Cada cambio necesita rebuild
- ❌ **Más complejo** - Necesitas entender la arquitectura
- ❌ **Mayor probabilidad de errores** - Puedes romper el sistema

**Cuándo usar Haxe:**
- Necesitas crear modificadores completamente nuevos
- Quieres eventos con comportamiento único
- Necesitas máxima performance (modcharts muy complejos)
- Estás contribuyendo al engine

---

## Sistema de Eventos

### **¿Qué es un Evento?**

Un **evento** es una acción programada que se ejecuta automáticamente cuando la canción alcanza un beat específico. El sistema gestiona estos eventos a través del `EventManager`, que:

1. **Organiza eventos por nombre y jugador** - Usa un HashMap para búsqueda rápida
2. **Ordena eventos por beat** - Garantiza ejecución en orden correcto
3. **Actualiza cada frame** - Compara el beat actual con los eventos pendientes
4. **Ejecuta callbacks** - Cuando `curBeat >= event.beat`

### **Tipos de Eventos Disponibles**

#### **1. SetEvent** - Cambio Instantáneo
```lua
set('reverse', 32, 1, 0, -1)
```
- **Qué hace:** Establece el valor de un modificador instantáneamente
- **Cuándo se ejecuta:** Exactamente en el beat especificado
- **Uso típico:** Cambios abruptos, resets, transiciones instantáneas

**Funcionamiento interno:**
```haxe
// Cuando curBeat >= beat:
setModPercent(name, target, player); // Asigna el valor directamente
fired = true; // Marca como ejecutado (no se repite)
```

#### **2. EaseEvent** - Transición Suave
```lua
ease('drunk', 16, 8, 0.5, 'cubeInOut', 0, -1)
```
- **Qué hace:** Interpola gradualmente desde el valor actual hasta el objetivo
- **Cuándo se ejecuta:** Continuamente desde `beat` hasta `beat + length`
- **Uso típico:** Transiciones suaves, animaciones fluidas

**Funcionamiento interno:**
```haxe
// Cada frame mientras curBeat < endBeat:
var progress = (curBeat - startBeat) / beatLength; // 0.0 a 1.0
var easedProgress = easeFunction(progress); // Aplica curva de easing
var value = lerp(startValue, targetValue, easedProgress);
setModPercent(name, value, player);
```

**Características especiales:**
- Obtiene el valor previo del último evento (evita saltos visuales)
- Si el evento anterior era un Ease, usa su función de easing para calcular el valor final
- `mercy = true` - Se ejecuta cada frame, no solo una vez

#### **3. AddEvent** - Suma Gradual
```lua
add('drunk', 48, 8, 0.25, 'linear', 0, -1)
```
- **Qué hace:** SUMA un valor al porcentaje actual, no lo reemplaza
- **Cuándo se ejecuta:** Continuamente desde `beat` hasta `beat + length`
- **Uso típico:** Acumular efectos, intensificar modificadores

**Diferencia con Ease:**
```lua
-- Si drunk está en 50%:
ease('drunk', 0, 4, 0.75, 'linear', 0, -1) -- Va de 50% a 75% (reemplaza)
add('drunk', 0, 4, 0.25, 'linear', 0, -1)  -- Va de 50% a 75% (50% + 25% = 75%)
```

#### **4. RepeaterEvent** - Ejecución Continua
```lua
repeater(80, 16, 'myRepeaterFunc', -1)

function myRepeaterFunc(event)
    -- Este código se ejecuta CADA FRAME
    local beat = (getSongPosition() / 1000) / (60 / bpm) * 4
    debugPrint('Beat: ' .. beat)
end
```
- **Qué hace:** Ejecuta una función repetidamente cada frame
- **Cuándo se ejecuta:** Cada frame mientras `beat <= curBeat < beat + length`
- **Uso típico:** Efectos basados en tiempo real, animaciones complejas

**Características:**
- `fired = false` después de cada ejecución (se mantiene activo)
- Útil para sincronizar con audio o crear patrones complejos

#### **5. CallbackEvent** - Ejecución Única
```lua
callback(64, 'myCallbackFunc', -1)

function myCallbackFunc(event)
    debugPrint('¡Llegamos al beat 64!')
    setPercent('tipsy', 0.75, 0, -1)
end
```
- **Qué hace:** Ejecuta una función UNA SOLA VEZ
- **Cuándo se ejecuta:** Exactamente cuando `curBeat >= beat`
- **Uso típico:** Triggers, cambios puntuales, logs

---

## Funciones de Modchart

```lua
-- Todo debe estar dentro de esta función para funcionar correctamente
function onInitModchart()

```lua
-- Todo debe estar dentro de esta función para funcionar correctamente
function onInitModchart()

    -- ============================================
    -- [Modifiers Section] - Gestión de Modificadores
    -- ============================================

    -- Busca y agrega un modificador por nombre
    -- mod:String   Nombre del modificador (ej: 'drunk', 'reverse', 'tipsy')
    -- field:Int    Número del playfield (-1 = todos, 0 = jugador, 1 = oponente)
    addModifier(mod, field);

    -- Establece el porcentaje de un modificador inmediatamente (sin eventos)
    -- mod:String   Nombre del modificador
    -- value:Float  Valor a asignar (0.0 = 0%, 1.0 = 100%)
    -- player:Int   Jugador objetivo (-1 = todos)
    -- field:Int    Playfield objetivo (-1 = todos)
    setPercent(mod, value, player, field);

    -- Obtiene el porcentaje actual de un modificador
    -- mod:String   Nombre del modificador
    -- player:Int   Jugador a consultar (por defecto 0)
    -- field:Int    Playfield a consultar (por defecto 0)
    -- returns: Float (el valor actual del modificador)
    local currentValue = getPercent(mod, player, field);

    -- Registra un nuevo modificador personalizado (solo Haxe)
    -- modN:String  Nombre del nuevo modificador
    -- mod:Modifier Instancia de la clase Modifier (solo desde Haxe)
    registerModifier(modN, mod);

    -- ============================================
    -- [Events Section] - Sistema de Eventos
    -- ============================================

    -- SET: Establece un valor instantáneamente en un beat específico
    -- mod:String   Nombre del modificador
    -- beat:Float   Beat donde se ejecutará (ej: 32.0, 64.5)
    -- value:Float  Valor objetivo (0.0 a 1.0 típicamente)
    -- player:Int   Jugador objetivo (-1 = todos, 0 = jugador, 1 = oponente)
    -- field:Int    Playfield objetivo (-1 = todos)
    set(mod, beat, value, player, field);

    -- EASE: Interpola suavemente de valor actual a valor objetivo
    -- mod:String   Nombre del modificador
    -- beat:Float   Beat de inicio
    -- length:Float Duración en beats (ej: 4.0 = 4 beats)
    -- value:Float  Valor objetivo final
    -- ease:String  Función de easing ('linear', 'cubeInOut', 'backOut', etc.)
    -- player:Int   Jugador objetivo (-1 = todos)
    -- field:Int    Playfield objetivo (-1 = todos)
    ease(mod, beat, length, value, ease, player, field);

    -- ADD: Suma un valor gradualmente (acumula, no reemplaza)
    -- Parámetros idénticos a ease()
    -- Diferencia: Si drunk = 50%, add(..., 25%) llegará a 75% (50% + 25%)
    --            mientras que ease() iría directamente a 25%
    add(mod, beat, length, value, ease, player, field);

    -- SETADD: Establece valor + suma en un beat específico
    -- Combina set() con suma: establece (valorActual + value)
    -- mod:String   Nombre del modificador
    -- beat:Float   Beat donde se ejecutará
    -- value:Float  Valor a SUMAR al actual
    -- player:Int   Jugador objetivo (-1 = todos)
    -- field:Int    Playfield objetivo (-1 = todos)
    setAdd(mod, beat, value, player, field);

    -- CALLBACK: Ejecuta una función UNA VEZ en un beat específico
    -- beat:Float     Beat donde se ejecutará
    -- funcName:String Nombre de la función Lua a llamar (como string)
    -- field:Int      Playfield objetivo (-1 = todos)
    callback(beat, 'myCallbackFunction', field);

    -- REPEATER: Ejecuta una función CADA FRAME durante un período
    -- beat:Float      Beat de inicio
    -- length:Float    Duración en beats
    -- funcName:String Nombre de la función Lua a llamar (como string)
    -- field:Int       Playfield objetivo (-1 = todos)
    repeater(beat, length, 'myRepeaterFunction', field);

    -- ============================================
    -- [Playfield Section] - Gestión de Playfields
    -- ============================================
    
    -- Agrega un nuevo playfield (campo de juego adicional)
    -- ADVERTENCIA: Si agregas un playfield DESPUÉS de añadir modificadores,
    -- tendrás que añadir los modificadores nuevamente al nuevo playfield
    addPlayfield();

    -- ============================================
    -- [Alias Section] - Nombres Alternativos
    -- ============================================
    
    -- Crea un alias (nombre alternativo) para un modificador
    -- name:String      Nombre del modificador original
    -- aliasName:String Nombre alternativo/alias
    -- field:Int        Playfield objetivo
    alias(name, aliasName, field);

    -- ============================================
    -- [Constants] - Constantes Útiles
    -- ============================================
    
    -- Tamaño de las hold notes
    local holdSize = getHoldSize();        -- Tamaño completo
    local holdSizeDiv2 = getHoldSizeDiv2(); -- Tamaño / 2

    -- Tamaño de las flechas
    local arrowSize = getArrowSize();       -- Tamaño completo (160)
    local arrowSizeDiv2 = getArrowSizeDiv2(); -- Tamaño / 2 (80)
end
```

---

## Ejemplos Prácticos

### **Ejemplo 1: Modchart Básico**
```lua
function onInitModchart()
    -- Agregar modificadores que usaremos
    addModifier('reverse', -1)
    addModifier('drunk', -1)
    addModifier('tipsy', -1)
    
    -- Beat 0-16: Sin efectos
    
    -- Beat 16: Activar reverse instantáneamente
    set('reverse', 16, 1, 0, -1) -- Solo jugador
    
    -- Beat 32-48: Drunk aumenta gradualmente
    ease('drunk', 32, 16, 0.5, 'cubeInOut', -1, -1) -- Ambos jugadores
    
    -- Beat 64: Reset todo
    callback(64, 'resetModchart', -1)
end

function resetModchart(event)
    debugPrint('¡Reseteando modchart!')
    setPercent('reverse', 0, -1, -1)
    setPercent('drunk', 0, -1, -1)
end
```

### **Ejemplo 2: Efectos Acumulativos**
```lua
function onInitModchart()
    addModifier('invert', -1)
    
    -- Cada 16 beats, aumentar invert en 10%
    set('invert', 16, 0.1, -1, -1)      -- 10%
    setAdd('invert', 32, 0.1, -1, -1)   -- 10% + 10% = 20%
    setAdd('invert', 48, 0.1, -1, -1)   -- 20% + 10% = 30%
    setAdd('invert', 64, 0.1, -1, -1)   -- 30% + 10% = 40%
end
```

### **Ejemplo 3: Repeater para Efectos Pulsantes**
```lua
local bpm = 140

function onInitModchart()
    addModifier('zoom', -1)
    
    -- Efecto de pulso del beat 32 al 64
    repeater(32, 32, 'pulseEffect', -1)
end

function pulseEffect(event)
    -- Calcular beat actual con decimales
    local beat = (getSongPosition() / 1000) / (60 / bpm) * 4
    local beatFraction = beat % 1 -- 0.0 a 1.0 dentro del beat
    
    -- Pulsar al ritmo: más grande al inicio del beat, más pequeño al final
    local pulseAmount = 1.0 - beatFraction
    setPercent('zoom', pulseAmount * 0.2, -1, -1) -- Máximo 20% zoom
end
```

### **Ejemplo 4: Callback para Cambios Drásticos**
```lua
function onInitModchart()
    addModifier('reverse', -1)
    addModifier('flip', -1)
    addModifier('invert', -1)
    
    -- Preparar efectos suaves
    ease('reverse', 0, 32, 0.5, 'linear', 0, -1)
    
    -- En beat 32: Cambio drástico
    callback(32, 'dropEffect', -1)
    
    -- Reset en beat 64
    callback(64, 'resetAll', -1)
end

function dropEffect(event)
    debugPrint('¡DROP!')
    -- Activar múltiples efectos instantáneamente
    setPercent('flip', 1, -1, -1)
    setPercent('invert', 1, -1, -1)
    setPercent('reverse', 1, -1, -1)
end

function resetAll(event)
    setPercent('flip', 0, -1, -1)
    setPercent('invert', 0, -1, -1)
    setPercent('reverse', 0, -1, -1)
end
```

### **Ejemplo 5: Efectos Diferentes por Jugador**
```lua
function onInitModchart()
    addModifier('drunk', -1)
    addModifier('reverse', -1)
    
    -- Player (0): Drunk crece
    ease('drunk', 16, 16, 0.8, 'cubeOut', 0, -1)
    
    -- Opponent (1): Reverse activo
    set('reverse', 16, 1, 1, -1)
    
    -- Beat 48: Intercambiar efectos
    ease('drunk', 48, 8, 0, 'cubeIn', 0, -1)      -- Player pierde drunk
    ease('drunk', 48, 8, 0.8, 'cubeOut', 1, -1)   -- Opponent gana drunk
    set('reverse', 48, 0, 1, -1)                   -- Opponent pierde reverse
    set('reverse', 48, 1, 0, -1)                   -- Player gana reverse
end
```

---

## 🔧 Funciones de Easing Disponibles

Puedes usar estos strings en `ease()` y `add()`:

**Suaves:**
- `'linear'` - Sin easing, velocidad constante
- `'smoothStepIn'` / `'smoothStepOut'` / `'smoothStepInOut'`
- `'smootherStepIn'` / `'smootherStepOut'` / `'smootherStepInOut'`

**Cuadráticas:**
- `'quadIn'` / `'quadOut'` / `'quadInOut'`
- `'cubeIn'` / `'cubeOut'` / `'cubeInOut'`
- `'quartIn'` / `'quartOut'` / `'quartInOut'`
- `'quintIn'` / `'quintOut'` / `'quintInOut'`

**Especiales:**
- `'sineIn'` / `'sineOut'` / `'sineInOut'` - Movimiento sinusoidal
- `'circIn'` / `'circOut'` / `'circInOut'` - Circular
- `'expoIn'` / `'expoOut'` / `'expoInOut'` - Exponencial
- `'backIn'` / `'backOut'` / `'backInOut'` - Sobrepasa y vuelve
- `'bounceIn'` / `'bounceOut'` / `'bounceInOut'` - Rebote
- `'elasticIn'` / `'elasticOut'` / `'elasticInOut'` - Elástico

---

## ⚠️ Notas Importantes

1. **`player` vs `field`:**
   - `player`: Jugador/Strumline (0 = jugador, 1 = oponente, -1 = todos)
   - `field`: Playfield/Campo de juego (normalmente -1 a menos que uses múltiples playfields)

2. **Timing de eventos:**
   - Los eventos se evalúan cada frame basándose en `Conductor.songPosition`
   - Los beats son flotantes: `32.5` es válido (mitad del beat 32)

3. **Orden de ejecución:**
   - `onInitModchart()` se llama ANTES de que empiece la canción
   - Los eventos se ordenan automáticamente por beat
   - Múltiples eventos en el mismo beat se ejecutan en orden de creación

4. **Performance:**
   - Los `repeater` se ejecutan cada frame, úsalos con cuidado
   - Los `callback` se ejecutan una vez y se limpian automáticamente
   - Los eventos `ease` y `add` solo calculan mientras están activos

---

## 🎯 Tips y Trucos

**1. Usar callbacks para debug:**
```lua
callback(32, 'debugBeat32', -1)
function debugBeat32(event)
    debugPrint('Estado drunk: ' .. getPercent('drunk', 0, -1))
end
```

**2. Combinar ease con diferentes jugadores:**
```lua
-- Efecto espejo: uno sube mientras otro baja
ease('drunk', 16, 16, 0.8, 'cubeInOut', 0, -1)
ease('drunk', 16, 16, 0, 'cubeInOut', 1, -1)
```

**3. Usar repeater para sincronización perfecta:**
```lua
repeater(0, 999, 'beatSync', -1) -- Durante toda la canción
function beatSync(event)
    local pos = getSongPosition() / 1000
    local beat = pos / (60 / bpm) * 4
    if beat % 4 < 0.1 then -- Cada 4 beats
        setPercent('zoom', 0.2, -1, -1)
    else
        setPercent('zoom', 0, -1, -1)
    end
end
```

**4. Valores típicos de modificadores:**
- `0.0` = Desactivado (0%)
- `0.5` = Efecto medio (50%)
- `1.0` = Efecto completo (100%)
- Algunos modificadores aceptan valores negativos o >1.0

---

## 🚨 Errores Comunes

1. **"Manager.instance is null"**
   - Causa: Modcharting deshabilitado en opciones
   - Solución: Activa "Modcharting" en ClientPrefs

2. **Eventos no se ejecutan**
   - Causa: No están dentro de `onInitModchart()`
   - Solución: Coloca todos los eventos dentro de la función

3. **Callback no funciona**
   - Causa: Nombre de función como string incorrecto
   - Solución: `callback(32, 'myFunc', -1)` con comillas

4. **Modificador no existe**
   - Causa: No agregaste el modificador con `addModifier()`
   - Solución: Siempre usa `addModifier()` antes de usar el modificador

---

**Última actualización:** Octubre 2025 | **Versión:** Plus Engine 1.0
```