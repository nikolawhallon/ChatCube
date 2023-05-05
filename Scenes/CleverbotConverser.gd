extends Node

var cleverbotConversationStarted = false
var cleverbotCS = null
var transformToPlayAt = null

func set_transform_to_play_at(transform):
	transformToPlayAt = transform

func get_cleverbot_response(text):
	var cleverbot_api_key = "INSERT_YOUR_CLEVERBOT_API_KEY"
	var url = "https://www.cleverbot.com/getreply?key=" + cleverbot_api_key

	if cleverbotConversationStarted:
		url += "&cs=" + cleverbotCS;
	url += "&input=" + text;

	$CleverbotHTTPRequest.request(url)

func _on_CleverbotHTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		return
		
	var response_dict = JSON.parse(body.get_string_from_utf8())
	cleverbotCS = response_dict.result["cs"]
	cleverbotConversationStarted = true
	var output = response_dict.result["output"]
	print(output)

	var url = "https://api.elevenlabs.io/v1/text-to-speech/21m00Tcm4TlvDq8ikWAM";

	var data = {"text": output}
	var query = JSON.print(data)

	print(query)

	var headers = ["accept: audio/mpeg", "xi-api-key: INSERT_YOUR_ELEVENLABS_API_KEY", "Content-Type: application/json"]
	$TTSHTTPRequest.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_TTSHTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print("failed with response code:")
		print(response_code)
		print("and body:")
		print(body.get_string_from_utf8())
		return

	var player = AudioStreamPlayer3D.new()
	if transformToPlayAt:
		player.global_transform = transformToPlayAt
	self.add_child(player)

	var sound = AudioStreamMP3.new()
	sound.data = body
	player.stream = sound
	player.play()
