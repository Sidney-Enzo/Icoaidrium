function love.conf(s)
    --% Window % --
    s.window.title = "icosaidrium"
    s.window.icon = "assets/images/icosaidriumIcon.png"
    s.window.x = nil
    s.window.y = nil
    s.window.height = 448
    s.window.width = 864
    -- s.window.fullscreen = true

    s.window.minwidth = 1
    s.window.minheight = 1
    
    s.window.display = 1
    s.window.borderless = false
    s.window.resizable = true
    s.window.depth = 16 

    --% Debug %--
    s.console = true
    -- s.version = "11.5"

    --% Storage %--
    s.externalstorage = true
    s.identity  = "icosaidrium"

    --% Modules %--
    s.modules.audio = true
    s.modules.data = true
    s.modules.event = true
    s.modules.font = true
    s.modules.graphics = true
    s.modules.image = true
    s.modules.joystick = true
    s.modules.keyboard = true
    s.modules.math = true
    s.modules.mouse = true
    s.modules.physics = true
    s.modules.sound = true
    s.modules.system = true
    s.modules.thread = true
    s.modules.timer = true
    s.modules.touch = true
    s.modules.video = true
    s.modules.window = true
end