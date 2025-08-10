if _G.Playprint == nil then _G.Playprint = true end
local function get_speakers(name)
    if name then
        local speaker = peripheral.wrap(name)
        if speaker == nil then
            error(("Speaker %q does not exist"):format(name), 0)
            return
        elseif not peripheral.hasType(name, "speaker") then
            error(("%q is not a speaker"):format(name), 0)
        end

        return { speaker }
    else
        local speakers = { peripheral.find("speaker") }
        if #speakers == 0 then
            error("No speakers attached", 0)
        end
        return speakers
    end
end
function spekerStop()
    local speakers = { peripheral.find("speaker") }
    for _, speaker in pairs(speakers) do
        speaker.stop()
    end
end

function speakerPlay(buffer)
    local speakers = { peripheral.find("speaker") }
    for _, speaker in pairs(speakers) do
        a = speaker.playAudio(buffer)
    end
    return a
end
    

local function pcm_decoder(chunk)
    local buffer = {}
    for i = 1, #chunk do
        buffer[i] = chunk:byte(i) - 128
    end
    return buffer
end


function displayProgressBar(percent)
    term.setCursorPos(1, 1)
    local screenWidth, _ = term.getSize()  -- 获取终端的宽度和高度
    local barLength = math.floor(screenWidth - 8)  -- 进度条长度为屏幕宽度减去固定长度（用于百分比显示）
    
    local numBars = math.floor(percent / (100 / barLength))
    
    -- 构建进度条字符串
    local progressBar = "["
    for i = 1, barLength do
        if i <= numBars then
            progressBar = progressBar .. "="
        else
            progressBar = progressBar .. " "
        end
    end
    progressBar = progressBar .. "] " .. math.floor(percent) .. "%"  -- 百分比不显示小数点
    
    -- 清空屏幕并输出进度条到屏幕顶部

    term.setCursorPos(1, 3)
    print(progressBar)
end

-- 测试函数




local cmd = ...
if cmd == "stop" then
    _G.Playopen = false
    local speakers = { peripheral.find("speaker") }
    for _, speaker in pairs(speakers) do
        speaker.stop()
    end
    spekerStop()
elseif cmd == "play" then
    local _, file, type = ...

    local handle, err
    if http and file:match("^https?://") then
        if type == "mp3" then
            if _G.Playprint then print("mp3 > dfpwm.....") end
            local json = textutils.serialiseJSON({ ["url"] = file } )
            handle, err = http.get{ url = http.post("http://gmapi.liulikeji.cn:15842/dfpwm",json).readAll(), binary = true }
        else
            handle, err = http.get{ url = file, binary = true }
        end
    else
        handle, err = fs.open(file, "rb")
    end

    if not handle then
        error(err, 0)
    end

    local start = handle.read(4)
    local pcm = false
    local size = 16 * 1024 - 4
    if start == "RIFF" then
        handle.read(4)
        if handle.read(8) ~= "WAVEfmt " then
            handle.close()
            error("Could not play audio: Unsupported WAV file", 0)
        end

        local fmtsize = ("<I4"):unpack(handle.read(4))
        local fmt = handle.read(fmtsize)
        local format, channels, rate, _, _, bits = ("<I2I2I4I4I2I2"):unpack(fmt)
        if not ((format == 1 and bits == 8) or (format == 0xFFFE and bits == 1)) then
            handle.close()
            error("Could not play audio: Unsupported WAV file", 0)
        end
        if channels ~= 1 or rate ~= 48000 then
        end
        if format == 0xFFFE then
            local guid = fmt:sub(25)
            if guid ~= "\x3A\xC1\xFA\x38\x81\x1D\x43\x61\xA4\x0D\xCE\x53\xCA\x60\x7C\xD1" then -- DFPWM format GUID
                handle.close()
                error("Could not play audio: Unsupported WAV file", 0)
            end
            size = size + 4
        else
            pcm = true
            size = 16 * 1024 * 8
        end

        repeat
            local chunk = handle.read(4)
            if chunk == nil then
                handle.close()
                error("Could not play audio: Invalid WAV file", 0)
            elseif chunk ~= "data" then -- Ignore extra chunks
                local size = ("<I4"):unpack(handle.read(4))
                handle.read(size)
            end
        until chunk == "data"

        handle.read(4)
        start = nil
    end


    local decoder = pcm and pcm_decoder or require "cc.audio.dfpwm".make_decoder()
    local b1=true
    achunk_1 = handle.readAll()
    local achunk_s = achunk_1
    local achunk_K = #achunk_1
    _G.whilecs_1 = 0
    _G.setPlay = nil

    function play1()
        _G.Playopen = true
        
        _G.Playstop = false
        c1=true

        while _G.Playopen do

            if _G.Playstop then
                local speakers = { peripheral.find("speaker") }
                for _, speaker in pairs(speakers) do
                    speaker.stop()
                end

                if _G.Playprint then print("play stop....") end
                while _G.Playstop do sleep(0.1) end
                b1=true
                c1=false
            end 

            --local chunk = handle.read(size)
            if c1 then
                chunk = achunk_1:sub(0,size)
                achunk_1 = achunk_1:sub(size+1,-1)

                local achunk_ZK = achunk_K / size

                if _G.setPlay ~= nil then 
                    local speakers = { peripheral.find("speaker") }
                    for _, speaker in pairs(speakers) do
                        speaker.stop()
                    end
                    _G.whilecs_1 = math.floor((setPlay / 100) * achunk_ZK)

                    achunk_1 = achunk_s:sub(size*_G.whilecs_1,-1)
                    chunk = achunk_1:sub(0,size)
                    achunk_1 = achunk_1:sub(size+1,-1)
                    _G.setPlay = nil
                    b1 = true
                end

                local f = _G.whilecs_1 / achunk_ZK
                _G.getPlay = f
                if _G.Playprint then
                    term.clear()
                    displayProgressBar(f*100)
                    print(_G.whilecs_1)
                    print(achunk_ZK)
                    print(f)
                end
                
                _G.whilecs_1 = _G.whilecs_1+1
                
                if f >= 1 then break end
                
                if chunk == nil then break end
                
                if start then
                    chunk, start = start .. chunk, nil
                    size = size + 4
                end
                
            end
            
            local buffer = decoder(chunk)
            if b1 then
                speakerPlay(buffer)
                b1=false
                c1 = true

            else
                
                while setPlay==nil and _G.Playstop==false do
                    local speakers = { peripheral.find("speaker") }
                    for i,speaker in pairs(speakers) do
                        os.pullEvent("speaker_audio_empty")
                    end
                    speakerPlay(buffer)
                    break
                end
                
            end
            
        end
        _G.getPlay=nil
    end


    play1()


    spekerStop()

    handle.close()
else
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
end