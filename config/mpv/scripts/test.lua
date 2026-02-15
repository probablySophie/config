-- function on_pause_change(name, value)
--     if value == true then
--         mp.set_property("fullscreen", "no")
--     end
-- end
-- mp.observe_property("pause", "bool", on_pause_change)

UTILS = require "mp.utils";

local function get_playlist_file()
    local playlist = mp.get_property_native("playlist");
    if playlist ~= nil and #playlist > 0 then
        -- mp.msg.log( "info", "playlist " .. mp.get_property("playlist") );
        -- mp.msg.log( "info", playlist[1].filename );
        return playlist[1]["playlist-path"];
    end
    return nil
end

local function attempt_to_load( path )
    mp.msg.log( "info", "attempt_to_load(" .. path .. ")" );
    -- mp.msg.log( "info", type(UTILS.file_info) );
    -- mp.msg.log( "info", require "mp.utils".file_info( path ).is_file );
    local file_info = require "mp.utils".file_info( path );
    if file_info ~= nil and file_info.is_file then
        mp.msg.log( "info", "File does exist, opening..." );
        mp.set_property("stream-open-filename", path);
        return true
    end
    return false
end

local function on_load_fail()
    local attempted_path = mp.get_property("path");
    mp.msg.log( "info", "on_load_fail called, path is " .. "'" .. ( attempted_path or "NIL" ) .. "'" );

    local playlist_file = get_playlist_file();
    local pwd, error = UTILS.getcwd();
    -- mp.msg.log( "info", "pwd + playlist_file: " .. pwd .. ( (#pwd > 0 and string.sub(pwd, -1) == "/") and "" or "/") .. playlist_file );
    -- mp.msg.log("info", "pwd: " .. ( pwd or "NULL" ))


    mp.msg.log( "info", "playlist item: " .. mp.get_property("playlist") );

    local trimmed_path = attempted_path;
    -- Trim the playlist file's path off of the music file path
    -- Works if in ~
    if playlist_file ~= nil then
        local playlist_file_path = string.gsub( playlist_file, "[^%/]+$", "" ) .. "";
        mp.msg.log( "info", "playlist_file_path: " .. playlist_file_path );

        if attempt_to_load( string.gsub( trimmed_path, playlist_file_path, "" ) ) then return; end
        if attempt_to_load( string.gsub( trimmed_path, pwd .. "/" .. playlist_file_path, "" ) ) then return; end

        if attempt_to_load( string.gsub( string.gsub( trimmed_path, pwd .. "/" .. playlist_file_path, "" ), "Music/", "" ) ) then return; end

        -- trimmed_path = string.sub( trimmed_path, #playlist_file_path[1] );
        -- if attempt_to_load( trimmed_path ) then return; end
        -- mp.msg.log( "info", "trimmed: " .. trimmed_path )

        -- mp.msg.log("info", "attempting to load -pwd");
        -- if attempt_to_load( string.sub(trimmed_path, #pwd + 2) ) then return; end
    end

    -- TODO: Very worst case, get the filename & scan ~/Music for the file

    -- mp.msg.log( "info", "home dir: " .. ( require "os".getenv("home") ) );

    -- Attempt to load our trimmed path but 1 dir up
    -- if attempt_to_load( trimmed_path ) then return; end

    -- Attempt to load but with "^Music/" removed
    -- if attempt_to_load( string.gsub(trimmed_path, "", "") .. "" ) then return; end


    -- mp.msg.log( "info", "trimmed_path: " .. trimmed_path);

    -- If the path was nil or we did actually try load a file, give up
    -- if attempted_path == nil or UTILS.file_info(attempted_path).is_file then return; end

    -- mp.msg.log( "info", mp.get_property("playlist") );

    -- mp.msg.log( "info", attempted_path );

    -- -- The path MPV is run from
    -- local pwd, error = UTILS.getcwd();
    -- mp.msg.log( "info", pwd );

    -- TODO: Try ~/Music/${path}
    -- if attempt_to_load( "" ) then
    --     return;
    -- end

    -- TODO: Try ~/${path}

end

mp.add_hook( "on_load_fail", 1, on_load_fail );

local function print_property(name)
    local value = mp.get_property(name);
    mp.msg.log( "info", name .. ": " .. ( value or "[NULL]" ) )
end

local function on_load()
    mp.msg.log("info", "on_load");

    -- local path = mp.get_property("file-path");
    -- mp.msg.info("Loading file: " .. path)

    -- print_property("file-path");
    -- print_property("path");

    -- for k,v in pairs(info) do
    --     mp.msg.log( "info", k );
    -- end

end
mp.add_hook( "on_load", 1, on_load )


-- mp.msg.log("info", "test.lua");

-- local function test_func()
--     mp.msg.info( mp.get_property("path") );
-- end
