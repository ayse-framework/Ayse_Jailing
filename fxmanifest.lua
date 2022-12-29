author "helmimarif"
description "Jailing System for Ayseframework"
version "1.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
	"ui/index.html",
	"ui/script.js",
	"ui/style.css"
}
ui_page "ui/index.html"

shared_script "config.lua"
client_script "client.lua"
server_script "server.lua"

dependency "Ayse_Core"