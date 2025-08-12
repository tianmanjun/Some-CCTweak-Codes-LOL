--Orign In http://alist.liulikeji.cn/d/HFS/music168/music168.lua
-----------------------------------------------------------------系统启动阶段-------------------------------------------------------------------------------------------------

--*获取程序所在目录
local mypath = "/" .. fs.getDir(shell.getRunningProgram())

if not fs.exists(mypath .. "/lib/basalt.lua") then shell.run(
    "wget http://alist.liulikeji.cn/d/HFS/Installer/lib/basalt.lua lib/basalt.lua") end
if not fs.exists(mypath .. "/speaker.lua") then shell.run("wget http://alist.liulikeji.cn/d/HFS/music168/speaker.lua") end
if not fs.exists(mypath .. "/lib/pinyin.lua") then shell.run("wget https://github.com/tianmanjun/Some-CCTweak-Codes-LOL/raw/refs/heads/main/pinyin.lua lib/pinyin.lua") end
--*GUI库导入
basalt            = require(mypath .. "/lib/basalt")
pinyin            = require(mypath .. "/lib/pinyin")
--*初始化GUI框架
local mainf       = basalt.createFrame()
main              = {
    mainf:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h"):setBackground(colors.red),
}
_G.Playprint      = false
_G.Playopen       = false
_G.PlayTime       = 0
_G.UserCookie = ''
--*GUI框架配置表
local sub         = {
    ["UI"] = {
        main[1]:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h -2"):setBackground(colors.red),
        main[1]:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h -2"):setBackground(colors.white):hide(),
        main[1]:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h -2"):setBackground(colors.white):hide(),
        main[1]:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h -2"):setBackground(colors.red):hide(),
        main[1]:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h -2"):setBackground(colors.white):hide(),
    },
    ["menu"] = {
        main[1]:addFrame():setPosition(1, "parent.h"):setSize("parent.w", 1):setBackground(colors.lightGray),
    },
    ["BF"] = {
        mainf:addFrame():setPosition(1, "parent.h + 1"):setSize("parent.w", "parent.h"):setBackground(colors.red),
        main[1]:addFrame():setPosition(1, "parent.h - 1"):setSize("parent.w", 1):setBackground(colors.lightGray):hide(),
    },
    ["play_table"] = {
        mainf:addFrame():setPosition(2, "parent.h + 1"):setSize("parent.w-2", 13):setBackground(colors.orange),
    }
}

--创建动画
play_Gui_UP       = mainf:addAnimation():setObject(sub["BF"][1]):move(1, 1, 0.3)
play_Gui_DO       = mainf:addAnimation():setObject(sub["BF"][1]):move(1, mainf:getHeight() + 1, 1)
play_table_Gui_UP = mainf:addAnimation():setObject(sub["play_table"][1]):move(2, mainf:getHeight() - 12, 0.3)
play_table_Gui_DO = mainf:addAnimation():setObject(sub["play_table"][1]):move(2, mainf:getHeight() + 1, 1)
--play_Gui_UP:play()
--main[1]:hide()
--main[1]:addAnimation():setObject(sub["BF"][1]):move(1,"parent.h+1",1.5):play()
--创建播放界面
play_name         = "NO Music"
play_id           = "NO Music"
play_Gui          = {
    sub["BF"][1]:addButton():setPosition(1, 1):setSize(3, 1):setText("V"):onClick(function()
        play_Gui_DO:play()
        play_GUI_state = false
        main[1]:enable()
    end):setBackground(colors.red):setForeground(colors.white),
    sub["BF"][1]:addLabel():setText("NO Music"):setPosition(sub["BF"][1]:getWidth() / 2 - #play_name / 2, 1)
        :setBackground(colors.red):setForeground(colors.white),
    sub["BF"][1]:addLabel():setText("NO Music"):setPosition(sub["BF"][1]:getWidth() / 2 - #play_id / 2, 2):setBackground(
    colors.red):setForeground(colors.white),
    sub["BF"][1]:addLabel():setText(""):setPosition(3, 4):setSize("parent.w-4", "parent.h-10"):setBackground(colors
    .white):setForeground(colors.red),--image
    sub["BF"][1]:addButton():setPosition(3, "parent.h-5"):setSize(1, 1):setText("\3"):onClick(function() end)
        :setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition(8, "parent.h-5"):setSize(1, 1):setText("\25"):onClick(function() end)
        :setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w/2", "parent.h-5"):setSize(2, 1):setText("+-"):onClick(function() end)
        :setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w-3", "parent.h-5"):setSize(1, 1):setText("@"):onClick(function() end)
        :setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w-8", "parent.h-5"):setSize(1, 1):setText("E"):onClick(function() end)
        :setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addProgressbar():setPosition(3, "parent.h - 4"):setSize("parent.w - 4", 1):setProgressBar(colors.red,
        "=", colors.white):setBackground(colors.red):setBackgroundSymbol("-"):setForeground(colors.white),
    sub["BF"][1]:addLabel():setText("00:00"):setPosition("3", "parent.h - 3"):setSize(5, 1):setForeground(colors.white),
    sub["BF"][1]:addLabel():setText("00:00"):setPosition("parent.w - 6", "parent.h - 3"):setSize(5, 1):setForeground(
    colors.white),
    sub["BF"][1]:addButton():setPosition(3, "parent.h - 2"):setSize(3, 1):setText("=O="):onClick(function() end)
        :setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w /2 - 4", "parent.h - 2"):setSize(2, 1):setText("|\17"):onClick(function()
        play_set_1() end):setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w / 2 ", "parent.h - 2"):setSize(2, 1):setText("I>"):onClick(function() if play_data_table["play"] then
            _G.Playstop = true
            play_data_table["play"] = false
        else play_data_table["play"] = true end end):setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w / 2 +4", "parent.h - 2"):setSize(2, 1):setText("\16|"):onClick(function()
        play_set_0() end):setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addButton():setPosition("parent.w - 4", "parent.h - 2"):setSize(3, 1):setText("=T="):onClick(function()
        play_table_Gui_UP:play()
        main[1]:disable()
        sub["BF"][1]:disable()
    end):setForeground(colors.white):setBackground(colors.red),
    sub["BF"][1]:addSlider():setPosition(3, "parent.h - 4"):setSize("parent.w - 4", 1):setMaxValue(100):setBackground(
    colors.red):setForeground(colors.white),                                                                                                                   --:setBackgroundSymbol("\x8c"):setSymbol(" "),
}
--创建播放UI
play_column_Gui   = {
    sub["BF"][2]:addLabel():setText(""):setPosition(1, 1):setSize("parent.w-7", 1):setBackground(colors.lightGray)
        :setForeground(colors.white),
    sub["BF"][2]:addButton():setPosition("parent.w -4 ", 1):setSize(2, 1):setText("I>"):onClick(function() if play_data_table["play"] then
            _G.Playstop = true
            play_data_table["play"] = false
        else play_data_table["play"] = true end end):setForeground(colors.white):setBackground(colors.lightGray),
    sub["BF"][2]:addButton():setPosition("parent.w-1", 1):setSize(1, 1):setText("T"):onClick(function()
        play_table_Gui_UP:play()
        main[1]:disable()
    end):setForeground(colors.white):setBackground(colors.lightGray),
    sub["BF"][2]:addButton():setPosition(1, 1):setSize("parent.w -5", 1):setText(""):onClick(function()
        play_Gui_UP:play()
        play_GUI_state = true
        main[1]:disable()
    end):setBackground(colors.lights),
}

play_table_Gui    = {
    sub["play_table"][1]:addButton():setPosition("parent.w-3", 1):setSize(3, 1):setText("V"):onClick(function()
        if not play_GUI_state then main[1]:enable() end
        sub["BF"][1]:enable()
        play_table_Gui_DO:play()
    end):setBackground(colors.no):setForeground(colors.white),
    sub["play_table"][1]:addLabel():setText("PlayTable"):setPosition(1, 1):setForeground(colors.white),
    sub["play_table"][1]:addList():setPosition(2, 3):setSize("parent.w-2", "parent.h-2"):setScrollable(true),
}

--创建菜单栏
menuBut           = {
    sub["menu"][1]:addButton():setPosition(3, 1):setSize(3, 1):setText("{Q}"):onClick(function()
        for index, value in ipairs(menuBut) do value:setBackground(colors.lightGray) end
        menuBut[1]:setBackground(colors.red)
        for index, value in ipairs(sub["UI"]) do value:hide() end
        sub["UI"][1]:show()
    end):setForeground(colors.white):setBackground(colors.red),
    sub["menu"][1]:addButton():setPosition(8, 1):setSize(3, 1):setText("{T}"):onClick(function()
        for index, value in ipairs(menuBut) do value:setBackground(colors.lightGray) end
        menuBut[2]:setBackground(colors.red)
        for index, value in ipairs(sub["UI"]) do value:hide() end
        sub["UI"][2]:show()
    end):setForeground(colors.white):setBackground(colors.lightGray),
    sub["menu"][1]:addButton():setPosition(12, 1):setSize(4, 1):setText("{PH}"):onClick(function()
        for index, value in ipairs(menuBut) do value:setBackground(colors.lightGray) end
        menuBut[3]:setBackground(colors.red)
        for index, value in ipairs(sub["UI"]) do value:hide() end
        sub["UI"][3]:show()
    end):setForeground(colors.white):setBackground(colors.lightGray),
    sub["menu"][1]:addButton():setPosition(17, 1):setSize(3, 1):setText("{G}"):onClick(function()
        for index, value in ipairs(menuBut) do value:setBackground(colors.lightGray) end
        menuBut[4]:setBackground(colors.red)
        for index, value in ipairs(sub["UI"]) do value:hide() end
        sub["UI"][4]:show()
    end):setForeground(colors.white):setBackground(colors.lightGray),
    sub["menu"][1]:addButton():setPosition(22, 1):setSize(3, 1):setText("{Z}"):onClick(function()
        for index, value in ipairs(menuBut) do value:setBackground(colors.lightGray) end
        menuBut[5]:setBackground(colors.red)
        for index, value in ipairs(sub["UI"]) do value:hide() end
        sub["UI"][5]:show()
    end):setForeground(colors.white):setBackground(colors.lightGray),
}

-----------------------------------------------------------------DATA---------------------------------------------------------------------------------------------------------
play_data_table   = { ["music"] = {}, ["play"] = false, ["play_table"] = {}, ["play_table_index"] = 0, ["mode"] = "", }
_G.Playopen       = false
-----------------------------------------------------------------模块---------------------------------------------------------------------------------------------------------
--多线程
thread_table      = {}
function AddThread(funct)
    thread1 = mainf:addThread()
    thread1:start(funct)
    table.insert(thread_table, thread1)
    return #thread_table
end

--音乐+
function play_set_1()
    _G.music168_playopen = false
    _G.getPlay = 0
    _G.Playopen = false
    _G.Playstop = false
    table_index = play_table_Gui[3]:getItemIndex()
    if table_index <= 1 then
        play_table_Gui[3]:selectItem(play_table_Gui[3]:getItemCount())
    else
        play_table_Gui[3]:selectItem(table_index - 1)
    end
end

--音乐-
function play_set_0()
    _G.music168_playopen = false
    _G.getPlay = 0
    _G.Playopen = false
    _G.Playstop = false
    table_index = play_table_Gui[3]:getItemIndex()
    if table_index >= play_table_Gui[3]:getItemCount() then
        play_table_Gui[3]:selectItem(1)
    else
        play_table_Gui[3]:selectItem(table_index + 1)
    end
end

--获取URL
function GetmusicUrl(music_id)
    while true do
        if _G.UserCookie ~= '' then
            local jsontb = { id = tostring(MusicID), level = "standard", cookie = Cookie }
            httpi = http.post("https://apis.netstart.cn/music/song/url", textutils.serialiseJSON(jsontb),
                { ["Content-Type"] = "application/json" })
        if httpi then
            local bstr = httpi.readAll()
            local tb = textutils.unserialiseJSON(bstr)
            return tb["data"][1]["url"]
        end
        else
            local http = http.post(server_url .. "api/song/url", textutils.serialiseJSON({ ["id"] = music_id }))
            if http then
                json_str = http.readAll()
                local table = textutils.unserialiseJSON(json_str)
                if table["data"][1]["url"] then
                    return (table["data"][1]["url"])
                end
            end
        end
    end
end
--获取时间
function GetmusicTime(music_id)
    while true do
        local http = http.post(server_url .. "api/song/url", textutils.serialiseJSON({ ["id"] = music_id }))
        if http then
            json_str = http.readAll()
            local table = textutils.unserialiseJSON(json_str)
            if table["data"][1]["time"] then
                return (table["data"][1]["time"])
            end
        end
    end
end
--替换全角符号
function GetOffCharas(Values)
                    namechanged = string.gsub(Values,'。','.')
                    namechanged = string.gsub(namechanged,'，',',')
                    namechanged = string.gsub(namechanged,'、','&')
                    namechanged = string.gsub(namechanged,'‘','\'')
                    namechanged = string.gsub(namechanged,'“','\"')
                    namechanged = string.gsub(namechanged,'”','\"')
                    namechanged = string.gsub(namechanged,'’','\'')
                    namechanged = string.gsub(namechanged,'】',']')
                    namechanged = string.gsub(namechanged,'【','[')
                    namechanged = string.gsub(namechanged,'？','?')
                    namechanged = string.gsub(namechanged,'！','!')
                    namechanged = string.gsub(namechanged,'《',"<<")
                    namechanged = string.gsub(namechanged,'》',">>")
                    namechanged = string.gsub(namechanged,'￥','$')
                    namechanged = string.gsub(namechanged,'…',"...")
                    namechanged = string.gsub(namechanged,'（','(')
                    namechanged = string.gsub(namechanged,'）',')')
                    namechanged = string.gsub(namechanged,'；',';')
                    namechanged = string.gsub(namechanged,'：',':')
                    return namechanged
end
--dfpwm转码
--------------图片相关------------------
function GetCoverImageFromID(MusicID)
    jsontb = { ids = tostring(MusicID) }
    httpi = http.post("https://apis.netstart.cn/music/song/detail", textutils.serialiseJSON(jsontb),
        { ["Content-Type"] = "application/json" })
     tb = textutils.unserialiseJSON(httpi.readAll())
     picurl = tb["songs"][1]["al"]["picUrl"]
     irequestData = {
        input_url = picurl,
        args = { "-vf", "scale=10:10", "-q:v", "100" },
        output_format = "bmp"
    }
    iresponse, err = http.post(
        "http://newgmapi.liulikeji.cn/api/ffmpeg",
        textutils.serializeJSON(irequestData),
        { ["Content-Type"] = "application/json" }
    )
     re_str = iresponse.readAll()
     re_tb = textutils.unserializeJSON(re_str)
    
    return re_tb.download_url
end
function hexencode(str)
    return (str:gsub(".", function(char) return string.format("%2x", char:byte()) end))
end
function hexdecode(hex_str)
    hex_str = hex_str:gsub("%s", ""):upper()
     bytes = {}
    for i = #hex_str, 1, -2 do
        bytes[#bytes + 1] = hex_str:sub(i - 1, i)
    end
     big_endian = table.concat(bytes)
    return tonumber(big_endian, 16)
end

precolors = {
    { 240, 240, 240,  1 },
    { 242, 178, 51,   2 },
    { 229, 127, 216,  4 },
    { 153, 178, 242,  8 },
    { 222, 222, 108,  16 },
    { 127, 204, 25,   32 },
    { 242, 178, 204,  64 },
    { 76,  76,  76,   128 },
    { 153, 153, 153,  256 },
    { 76,  153, 178,  512 },
    { 178, 102, 229,  1024 },
    { 51,  102, 204,  2048 },
    { 127, 102, 76,   4096 },
    { 87,  166, 78,   8192 },
    { 204, 76,  76,   16384 },
    { 17,  17,  17,   32768 }
}
function imageload(posx, posy, hex)
     indexz = 0
    for i = 109, #hex, 8 do
        indexz = indexz + 1
         ColorHex = string.sub(hex, i, i + 7)
         r = tonumber(string.sub(ColorHex, 1, 1), 16) * 16 + tonumber(string.sub(ColorHex, 2, 2), 16)
         g = tonumber(string.sub(ColorHex, 3, 3), 16) * 16 + tonumber(string.sub(ColorHex, 4, 4), 16)
         b = tonumber(string.sub(ColorHex, 5, 5), 16) * 16 + tonumber(string.sub(ColorHex, 6, 6), 16)
         color = 1
        for j=1 , #precolors do
            if math.abs(r-precolors[j][1])+math.abs(g-precolors[j][2])+math.abs(b-precolors[j][3]) < math.abs(r-precolors[color][1])+math.abs(g-precolors[color][2])+math.abs(b-precolors[color][3]) then
                color = j
                --print(string.format("for %d,%d,%d find %d,%d,%d",r,g,b,precolors[j][1],precolors[j][2],precolors[j][3]))
            end
        end
        play_Gui[indexz+18]=sub["BF"][1]:addLabel():setText(""):setPosition(3+indexz % 10, math.floor(indexz / 10)):setSize(1,1):setBackground(precolors[color][4]):setForeground(precolors[color][4])
    end
end
--19


--播放
function playmusic(music_name, music_id, play_table, index)
    _G.getPlay = 0
    _G.Playopen = false
    _G.Playstop = false
    name,sname = pinyin(GetOffCharas(music_name),true,'')
    play_Gui[2]:setText(name):setPosition(sub["BF"][1]:getWidth() / 2 + 1 - #music_name / 2, 1)
    play_Gui[3]:setText(music_id):setPosition(sub["BF"][1]:getWidth() / 2 + 1 - #tostring(music_id) / 2, 2)
    play_column_Gui[1]:setText(name .. " | " .. tostring(music_id))
    play_data_table["music"] = { ["music_id"] = music_id, ["music_name"] = music_name }
    play_data_table["play_table"] = play_table
    play_data_table["play_table_index"] = index
    play_data_table["play"] = true

    play_table_Gui[3]:clear()
    for index, value in ipairs(play_table) do
        name,sname = pinyin(GetOffCharas(value["name"]),true,'')
        play_table_Gui[3]:addItem(name .. " | " .. tostring(value["id"]))
    end
    play_table_Gui[3]:selectItem(index)
    _G.music168_music_id = music_id

    _G.music168_playopen = true
    
    --basalt.debug("true")
    --play_thread_id = AddThread(function ()
    --


    --end)
end

--搜索
server_url = "http://music168.liulikeji.cn:15843/"
function Search(input_str, GUI_in, api)
    Search_table = {}
    while true do
        kg_a = false
        kg_d1 = false
        if api == "search" then
            http1 = http.post(server_url .. "api/search", textutils.serialiseJSON({ ["value"] = input_str }))
            json_str = http1.readAll()
            table_get = textutils.unserialiseJSON(json_str)
            if table_get["result"]["songCount"] ~= 0 then kg_a = true end
            if tonumber(input_str) then
            jsontb = { ids = tostring(input_str) }
            httpGetFromID = http.post("https://apis.netstart.cn/music/song/detail", textutils.serialiseJSON(jsontb),
             { ["Content-Type"] = "application/json" })
                json_str2 = httpGetFromID.readAll()
                table_get2 = textutils.unserialiseJSON(json_str2)
                if httpGetFromID and table_get2["songs"][1] then
                    kg_d1 = true
                    name,sn = pinyin(GetOffCharas(table_get2["songs"][1]["name"] or "NULL"),true,'')
                    arname,san = pinyin(GetOffCharas(table_get2["songs"][1]["ar"][1]["name"] or "NULL"),true,'')
                    output2_table = { ["id"] = tonumber(input_str), ["name"] = name , ["artists_id"] = table_get2["songs"][1]["ar"][1]["id"], ["artists_name"] = arname }
                    
                end
            end
        elseif api == "playlist" then
            http1 = http.post(server_url .. "api/playlist/detail", textutils.serialiseJSON({ ["id"] = input_str }))
            json_str = http1.readAll()
            table_get = textutils.unserialiseJSON(json_str)
            if table_get["code"] ~= 404 then kg_a = true end
        end
        

        if http1 or kg_d1 then
            if kg_a or kg_d1 then
                if not kg_d1 then
                if api == "search" then
                    for index, value in ipairs(table_get["result"]["songs"]) do
                        out_table = { ["id"] = value["id"], ["name"] = value["name"], ["artists_id"] = value["artists"]
                        [1]["id"], ["artists_name"] = value["artists"][1]["name"] }
                        Search_table[index] = out_table
                    end
                elseif api == "playlist" then
                    for index, value in ipairs(table_get["playlist"]["tracks"]) do
                        out_table = { ["id"] = value["id"], ["name"] = value["name"], ["artists_id"] = value["ar"][1]
                        ["id"], ["artists_name"] = value["ar"][1]["name"] }
                        Search_table[index] = out_table
                    end
                end
            end
            if kg_d1 then
            Search_table[#Search_table + 1] = output2_table
           end
                a = 2
                if play_lib_F then play_lib_F:remove() end
                play_lib_F = GUI_in[3]:addFrame():setPosition(1, 1):setSize("parent.w", "parent.h"):setBackground(colors
                .white):setScrollable()
                
                

                for index, value in ipairs(Search_table) do
                    frame = play_lib_F:addFrame():setPosition(2, a):setSize("parent.w-2", 3):setBackground(colors
                    .lightBlue):onClick(function()
                        if play_data_table["play"] then
                            shell.run(mypath .. "/speaker.lua stop")
                            if _G.Playopen then end
                            _G.music168_playopen = false
                            play_data_table["play"] = false
                        end
                        play_Gui_UP:play()
                        play_GUI_state = true
                        main[1]:disable()
                        playmusic(value["name"], value["id"], Search_table, index
                    )
                    end)
                    
                    name,sname = pinyin(GetOffCharas(value["name"]),true,'')
                    frame:addLabel():setText(name):setPosition(1, 1)
                    frame:addLabel():setText("id: " .. value["id"]):setPosition(1, 2)
                    artistp,sartistp = pinyin(GetOffCharas(value["artists_name"]),true,'')
                    frame:addLabel():setText("artists: " .. artistp ):setPosition(1, 3)
                    a = a + 4
                end
                break;
            else
                frame = GUI_in[3]:addFrame():setPosition(2, 2):setSize("parent.w-2", 3):setBackground(colors.lightBlue)
                frame:addLabel():setText("Didnt search the song"):setPosition(1, 1)
                break;
            end
        end
    end
end

-----------------------------------------------------------------渲染界面阶段-------------------------------------------------------------------------------------------------
GUI = {
    {
        sub["UI"][1]:addInput():setPosition(2, 1):setSize("parent.w-3", 1):setForeground(colors.gray):setBackground(
        colors.lightGray),
        sub["UI"][1]:addButton():setPosition("parent.w-1", 1):setSize(1, 1):setText("Q"):onClick(function() Search(
            GUI[1][1]:getValue(), GUI[1], "search") end):setForeground(colors.white):setBackground(colors.lightGray),
        sub["UI"][1]:addFrame():setPosition(1, 3):setSize("parent.w", "parent.h -3"):setBackground(colors.white),
        sub["UI"][1]:addButton():setPosition("parent.w-2", 1):setSize(1, 1):setText("X"):onClick(function() 
            GUI[1][1]:setValue("")
         end):setForeground(colors.white):setBackground(colors.lightGray),
    },
    {
        sub["UI"][4]:addInput():setPosition(2, 1):setSize("parent.w-3", 1):setForeground(colors.gray):setBackground(
        colors.lightGray),
        sub["UI"][4]:addButton():setPosition("parent.w-1", 1):setSize(1, 1):setText("Q"):onClick(function() Search(
            GUI[2][1]:getValue(), GUI[2], "playlist") end):setForeground(colors.white):setBackground(colors.lightGray),
        sub["UI"][4]:addFrame():setPosition(1, 3):setSize("parent.w", "parent.h -3"):setBackground(colors.white),
        sub["UI"][4]:addButton():setPosition("parent.w-2", 1):setSize(1, 1):setText("X"):onClick(function() 
            GUI[2][1]:setValue("")
        end):setForeground(colors.white):setBackground(colors.lightGray),
    },
    {
        sub["UI"][5]:addInput():setPosition(1, 1):setSize("parent.w", 1):setForeground(colors.black):setBackground(
        colors.blue),
        sub["UI"][5]:addButton():setPosition(1, 2):setSize("parent.w",1):setText("set cookie"):onClick(function() 
            _G.UserCookie = GUI[3][1]:getValue()
        end):setForeground(colors.white):setBackground(colors.red),
        sub["UI"][5]:addFrame():setPosition(1, 4):setSize("parent.w", "parent.h -4"):setBackground(colors.white),
        sub["UI"][5]:addButton():setPosition(1, 3):setSize("parent.w", 1):setText("Clear"):onClick(function() 
            GUI[3][1]:setValue("")
        end):setForeground(colors.white):setBackground(colors.red),
    },
}

_G.getPlay = nil

function thread2()
    while true do
        --basalt.debug(_G.music168_playopen)
        local screenWidth, _ = term.getSize()
        if play_Gui[18]:getIndex() ~= 1 then
            _G.setPlay = (play_Gui[18]:getIndex() / (screenWidth - 2)) * 100
            play_Gui[18]:setIndex(1)
        end
        sleep(0.1)
        --
        if _G.getPlay ~= nil then
            play_Gui[10]:setProgress(_G.getPlay * 100)
        end
        if play_data_table["play"] == true then
            _G.Playstop = false
            play_Gui[15]:setText("II")
            play_column_Gui[2]:setText("II")
            sub["BF"][2]:show()
        else
            play_Gui[15]:setText("I>")
            play_column_Gui[2]:setText("I>")
            --play_Gui[11]:setText("00:00")
            _G.Playstop = true
        end
        if play_data_table["play_table_index"] ~= 0 then
            if play_data_table["play_table_index"] ~= play_table_Gui[3]:getItemIndex() then
                index = play_table_Gui[3]:getItemIndex()
                if play_data_table["play"] then
                    shell.run(mypath .. "/speaker.lua stop")
                    if _G.Playopen then

                    end
                    play_data_table["play"] = false
                end
                _G.music168_playopen = false
                sleep(0.1)
                playmusic(play_data_table["play_table"][index]["name"], play_data_table["play_table"][index]["id"],
                    play_data_table["play_table"], index)
            end
        end
    end
end

function paste()
    while true do
        local event, text = os.pullEvent("paste")
    GUI[1][1]:setValue(text)
    GUI[2][1]:setValue(text)
    GUI[3][1]:setValue(text)
    end
end

function speakerp()
    function speaker_thread()
       --[[ play_time_thread_id = AddThread(function()
            local time_f = os.date("%M%S")
            while true do
                while _G.Playopen do
                    time_f = os.date("%M%S")
                    sleep(0.1)
                end
                time_F = os.date("%M%S")
                play_Gui[11]:setText(string.format("%02d", os.date("*t", time_F - time_f).min or 00) ..":" .. string.format("%02d", os.date("*t", time_F - time_f).sec or 00) or "00:00")
                sleep(1)
            end
        end)]]
        
        --basalt.debug(mypath)
        --shell.run(mypath.."/speaker play "..dfpwmURL.readAll())
        if _G.music168_music_id then
            --basalt.debug(music168_music_id)
            
            _G.Playopen = true
            local requestData = {
                input_url =
                GetmusicUrl(_G.music168_music_id),
                args = { "-vn", "-ar", "48000", "-ac", "1" }, -- DFPWM转换参数 / DFPWM conversion args
                output_format = "dfpwm"
            }
            local response, err = http.post(
                "http://newgmapi.liulikeji.cn/api/ffmpeg",
                textutils.serializeJSON(requestData),
                { ["Content-Type"] = "application/json" }
            )
            if response then
                local responseData = textutils.unserializeJSON(response.readAll())
                dfpwmURL = responseData.download_url
            end
            time = GetmusicTime(_G.music168_music_id)
            _G.PlayTime = time
            play_Gui[12]:setText(string.format("%02d",math.floor(time/60000))..":"..string.format("%02d",math.floor((time - math.floor(time/60000)*60000))/1000))
            shell.run(mypath .. "/speaker play " .. dfpwmURL)
            play_set_0()
        end
    end

    function while_thread() while _G.music168_playopen do sleep(0.01) time = _G.PlayTime * _G.getPlay play_Gui[11]:setText(string.format("%02d",math.floor(time/60000))..":"..string.format("%02d",math.floor((time - math.floor(time/60000)*60000))/1000)) end end

    while true do
        if _G.music168_playopen then parallel.waitForAny(speaker_thread, while_thread) end
        sleep(0.01)
    end
end





_G.music168_playopen = false
-----------------------------------------------------------------启动循环渲染器-----------------------------------------------------------------------------------------------
parallel.waitForAll(basalt.autoUpdate, thread2, paste, speakerp)
-----------------------------------------------------------------以下结束-----------------------------------------------------------------------------------------------------
