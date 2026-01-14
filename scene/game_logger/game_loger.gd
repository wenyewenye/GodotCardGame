extends Control
class_name  GameLogger
@onready var text_edit: TextEdit = $TextEdit
var logFile:FileAccess

var LogEnable = {
				Events.LOGLEVEL.NONE:0,
				Events.LOGLEVEL.SYSTEM:1,
				Events.LOGLEVEL.TURN:1,
				Events.LOGLEVEL.ATTACK:1,
				Events.LOGLEVEL.SUPERATTACK:1,
				Events.LOGLEVEL.RESPONSE:1,
				Events.LOGLEVEL.LITE:1}

func _ready() -> void:
	Events.setlog.connect(on_log)
	logFile = FileAccess.open("./temp/log.txt",FileAccess.WRITE)
	
func on_log(text:String,level:Events.LOGLEVEL):
	#text_edit.text = text_edit.text + text
	logFile.store_string(text+'\n')
	if Global.isDebug:
		return
	if LogEnable[level] == 1:
		text_edit.insert_line_at(0,text)
	pass
func GetLogFilePath():
	var path = "./log/log_" + Time.get_date_string_from_system()
	if not DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_absolute(path)
	path +=  "/log_" + str(int(Time.get_unix_time_from_system()))+".txt"
	return path
	
func SaveLogTxt():
	var filepath = logFile.get_path()
	logFile.close()
	#FileUtility.copy_file(logFile.get_path(),GetLogFilePath())
	FileUtility.delete_file(filepath)
	
	logFile = FileAccess.open("./temp/log.txt",FileAccess.WRITE)
