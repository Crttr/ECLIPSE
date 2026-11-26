-- ECLIPSE | Горячие клавиши Hyprland
local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- "

local function digitCode(d)
    return "code:" .. (d == 0 and 19 or (9 + d))
end

-- Единый способ регистрации с описанием для шпаргалки
local function bind(keys, action, description, options)
    options = options or {}
    options.description = description
    hl.bind(keys, action, options)
end
local function win(keys, action, description, options)
    bind(mainMod .. " + " .. keys, action, description, options)
end

-- УПРАВЛЕНИЕ ОКНАМИ
win("Escape", hl.dsp.exec_cmd("hyprctl kill"), "Окна: принудительное закрытие выбранного окна")
win("Q", hl.dsp.window.close(), "Окна: закрыть окно")
win("ALT + Space", hl.dsp.window.float({ action = "toggle" }), "Окна: плавающий режим")
win("D", hl.dsp.window.fullscreen({ mode = 1 }), "Окна: максимизация")
win("F", hl.dsp.window.fullscreen(), "Окна: полноэкранный режим")
win("J", hl.dsp.layout("togglesplit"), "Окна: сменить направление разделения (dwindle)")
win("Left", hl.dsp.focus({ direction = "left" }), "Окна: фокус влево")
win("Right", hl.dsp.focus({ direction = "right" }), "Окна: фокус вправо")
win("Up", hl.dsp.focus({ direction = "up" }), "Окна: фокус вверх")
win("Down", hl.dsp.focus({ direction = "down" }), "Окна: фокус вниз")
bind("ALT + Tab", hl.dsp.window.cycle_next(), "Окна: следующее окно")
win("Tab", hl.dsp.exec_cmd(noctCall .. "window-switcher"), "Окна: меню переключения")
win("SHIFT + Up", hl.dsp.window.move({ direction = "u" }), "Окна: переместить вверх")
win("SHIFT + Right", hl.dsp.window.move({ direction = "r" }), "Окна: переместить вправо")
win("SHIFT + Left", hl.dsp.window.move({ direction = "l" }), "Окна: переместить влево")
win("SHIFT + Down", hl.dsp.window.move({ direction = "d" }), "Окна: переместить вниз")
win("mouse:272", hl.dsp.window.drag(), "Окна: перетащить мышью")
win("mouse:273", hl.dsp.window.resize(), "Окна: изменить размер мышью")

-- РАБОЧИЕ ПРОСТРАНСТВА
for i = 1, 10 do
    local key = digitCode(i % 10)
    win(key, hl.dsp.focus({ workspace = i }), "Рабочие столы: открыть " .. i)
    win("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Рабочие столы: перенести окно на " .. i)
end
for i = 1, NUM_WPM do
    local key = digitCode(i % 10)
    win("CONTROL + " .. key, hl.dsp.focus({ workspace = "m~" .. i }), "Рабочие столы: локальный стол " .. i)
    win("SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }), "Рабочие столы: перенести на локальный стол " .. i)
    if i > 2 then
        win("SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = "m~" .. i, follow = false }), "Рабочие столы: перенести без перехода на локальный стол " .. i)
    end
end
win("CONTROL + Right", hl.dsp.focus({ workspace = "m+1" }), "Рабочие столы: следующий")
win("CONTROL + Left", hl.dsp.focus({ workspace = "m-1" }), "Рабочие столы: предыдущий")
win("CONTROL + Down", hl.dsp.focus({ workspace = "emptym" }), "Рабочие столы: пустой стол")
win("mouse_down", hl.dsp.focus({ workspace = "m-1" }), "Рабочие столы: предыдущий колесом")
win("mouse_up", hl.dsp.focus({ workspace = "m+1" }), "Рабочие столы: следующий колесом")
win("CONTROL + mouse_up", hl.dsp.focus({ workspace = "m-1" }), "Рабочие столы: предыдущий колесом (Ctrl)")
win("CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }), "Рабочие столы: следующий колесом (Ctrl)")
win("CONTROL + SHIFT + Right", hl.dsp.window.move({ workspace = "m+1" }), "Рабочие столы: перенести на следующий")
win("CONTROL + SHIFT + Left", hl.dsp.window.move({ workspace = "m-1" }), "Рабочие столы: перенести на предыдущий")
win("CONTROL + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "m-1" }), "Рабочие столы: перенести на предыдущий колесом")
win("CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }), "Рабочие столы: перенести на следующий колесом")
win("SHIFT + S", hl.dsp.window.move({ workspace = "special" }), "Рабочие столы: спрятать окно")
win("S", hl.dsp.workspace.toggle_special(), "Рабочие столы: открыть скрытый стол")

-- МОНИТОРЫ: текущие разъёмы, если переменные не заполнены
local monitors = {
    MONITOR1 ~= "" and MONITOR1 or "0",
    MONITOR2 ~= "" and MONITOR2 or "1"
}
for i, monitor in ipairs(monitors) do
    win("ALT + " .. digitCode(i), hl.dsp.focus({ monitor = monitor }), "Мониторы: выбрать " .. i)
    win("ALT + SHIFT + " .. digitCode(i), hl.dsp.window.move({ monitor = monitor }), "Мониторы: перенести окно на " .. i)
end
win("SHIFT + mouse_up", hl.dsp.window.move({ monitor = "-1" }), "Мониторы: перенести на предыдущий")
win("SHIFT + mouse_down", hl.dsp.window.move({ monitor = "+1" }), "Мониторы: перенести на следующий")

-- МАСШТАБИРОВАНИЕ
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    hl.config({ cursor = { zoom_factor = math.max(1.0, math.min(3.0, zoomvalue + value)) } })
end
win("Minus", function() zoomfunction(-0.3) end, "Масштаб: уменьшить", { repeating = true })
win("Plus", function() zoomfunction(0.3) end, "Масштаб: увеличить", { repeating = true })
win("code:82", function() zoomfunction(-0.3) end, "Масштаб: уменьшить (NumPad)", { repeating = true })
win("code:86", function() zoomfunction(0.3) end, "Масштаб: увеличить (NumPad)", { repeating = true })

-- ПРИЛОЖЕНИЯ
win("Return", hl.dsp.exec_cmd(launchPrefix .. TERMINAL), "Приложения: терминал")
win("E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), "Приложения: файловый менеджер")
win("T", hl.dsp.exec_cmd(launchPrefix .. EDITOR), "Приложения: текстовый редактор")
win("C", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), "Приложения: калькулятор")
bind("XF86Calculator", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), "Приложения: калькулятор (медиаклавиша)")
win("W", hl.dsp.exec_cmd(launchPrefix .. BROWSER), "Приложения: браузер")
bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"), "Приложения: мониторинг системы")

-- NOCTALIA
win("Z", hl.dsp.exec_cmd(noctCall .. "settings-toggle"), "Noctalia: настройки")
win("X", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"), "Noctalia: центр управления")
win("Space", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"), "Noctalia: поиск приложений")
win("period", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"), "Noctalia: эмодзи")
win("L", hl.dsp.exec_cmd(noctCall .. "session lock"), "Noctalia: заблокировать экран")
win("ALT + C", hl.dsp.exec_cmd(noctCall .. "panel-toggle session"), "Noctalia: меню сеанса")
win("SHIFT + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"), "Noctalia: выбор обоев")
win("V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"), "Noctalia: история буфера обмена")
win("A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"), "Noctalia: уведомления")
-- F1 добавим после проверки IPC-команды установленного плагина.

-- ЗВУК И МУЛЬТИМЕДИА
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"), "Звук: увеличить громкость", { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), "Звук: уменьшить громкость", { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd(noctCall .. "volume-mute"), "Звук: отключить или включить звук", { locked = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctCall .. "mic-mute"), "Звук: отключить или включить микрофон", { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd(noctCall .. "media toggle"), "Медиа: воспроизведение или пауза", { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"), "Медиа: пауза или воспроизведение", { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd(noctCall .. "media next"), "Медиа: следующий трек", { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd(noctCall .. "media previous"), "Медиа: предыдущий трек", { locked = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctCall .. "brightness-up"), "Экран: увеличить яркость", { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), "Экран: уменьшить яркость", { locked = true, repeating = true })

-- СНИМКИ ЭКРАНА
win("P", hl.dsp.exec_cmd("hyprpicker -a -n"), "Экран: пипетка цвета")
bind("Print", hl.dsp.exec_cmd(noctCall .. "screenshot-region"), "Экран: снимок области")
win("Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"), "Экран: снимок всего экрана")

hl.bind(mainMod .. " + F1",
    hl.dsp.exec_cmd(noctCall .. "panel-toggle kenn/keybind-cheatsheet:cheatsheet"),
    { description = "Noctalia: Список горячих клавиш" })
