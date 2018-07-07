local M = {}

--библиотека json используется для удобной сериализации данных их файла
-- local json = require("json")

--библиотека с функцией шифрования
local openssl = require "plugin.openssl"

--инициализайия aes-256-cbc
local cipher = openssl.get_cipher ( "aes-256-cbc" )

--библиотека mime нужна для перевода текстовых данных в base64
--так как при этом данные удобней при необходимости передавать в теле запроса
local mime = require ( "mime" )

local path_extract = function(fn)
	return system.pathForFile( fn, system.DocumentsDirectory )
end

--сохрание
function M.save(f,data)
	local file_path = path_extract(f)
	local file = io.open(file_path, "w")
	if file then
		local json_txt = json.encode(data)--перевод таблицы в json
		local aes256_txt = cipher:encrypt( json_txt, encrypt_password)--шифрование
		local base64_txt = mime.b64(aes256_txt)--перевод в base64
		file:write( base64_txt )--запись в файл
		io.close( file )
	end
end

--загрузка
function M.load(f)
	local file_path = path_extract(f)
	local file = io.open(file_path, "r")--открытие файла на чтение
	if file then
		local base64_txt = file:read("*a")--чтение всего файла как текст
		io.close( file )--закрытие файла
		local aes256_txt = mime.unb64(base64_txt)
		local json_txt = cipher:decrypt(aes256_txt,encrypt_password )
		local data = json.decode(json_txt)
		return data
	else
		return nil;
	end
end

return M
