fx_version 'adamant'
games { 'gta5' }

server_script('@mysql-async/lib/MySQL.lua')
server_script('server.lua')
client_script('client/clothingshop.lua')
client_script('client/tattooshop.lua')
client_script('client/healingspots.lua')
client_script('client/barbershop.lua')
client_script('client/skins.lua')
client_script('client/client.lua')
client_script('client/skinchanger.lua')
client_script "@urp-errorlog/client/cl_errorlog.lua"



ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/webfonts/fa-brands-400.eot',
    'client/html/webfonts/fa-brands-400.svg',
    'client/html/webfonts/fa-brands-400.ttf',
    'client/html/webfonts/fa-brands-400.woff',
    'client/html/webfonts/fa-brands-400.woff2',
    'client/html/webfonts/fa-regular-400.eot',
    'client/html/webfonts/fa-regular-400.svg',
    'client/html/webfonts/fa-regular-400.ttf',
    'client/html/webfonts/fa-regular-400.woff',
    'client/html/webfonts/fa-regular-400.woff2',
    'client/html/webfonts/fa-solid-900.eot',
    'client/html/webfonts/fa-solid-900.svg',
    'client/html/webfonts/fa-solid-900.ttf',
    'client/html/webfonts/fa-solid-900.woff',
    'client/html/webfonts/fa-solid-900.woff2',
    'client/html/css/all.min.css',
    'server.lua'
})
