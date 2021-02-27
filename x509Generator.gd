extends Node

const cert_file = "X509Certificate.crt"
const key_file = "X509Key.key"
onready var path = OS.get_executable_path().get_base_dir()
onready var cert_path = path + "/" + cert_file
onready var key_path = path + "/" + key_file

const CN = "WelcomeOfFate"
const O = "Hagabooga"
const C = "CA"
onready var not_before = (
	str(OS.get_date().year - 1)
	+ ("0" if OS.get_date().month < 10 else "")
	+ str(OS.get_date().month)
	+ ("0" if OS.get_date().day < 10 else "")
	+ str(OS.get_date().day)
	+ "000000"
)
onready var not_after = (
	str(OS.get_date().year + 1)
	+ ("0" if OS.get_date().month < 10 else "")
	+ str(OS.get_date().month)
	+ ("0" if OS.get_date().day < 10 else "")
	+ str(OS.get_date().day)
	+ "000000"
)


func _ready():
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
	create_cert()
	var _error = OS.shell_open(path)
	get_tree().quit()


func create_cert():
	var CNOC = "CN=%s,O=%s,C=%s" % [CN, O, C]
	var crypto = Crypto.new()
	var key = crypto.generate_rsa(4096)
	var cert = crypto.generate_self_signed_certificate(key, CNOC, not_before, not_after)
	cert.save(cert_path)
	key.save(key_path)
