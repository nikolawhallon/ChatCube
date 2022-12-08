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

	var url = "https://dgversetts.deepgram.com/text-to-speech/polly/pcm?text=" + output.percent_encode();

	$TTSHTTPRequest.request(url)

func _on_TTSHTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		return

	var player = AudioStreamPlayer3D.new()
	if transformToPlayAt:
		player.global_transform = transformToPlayAt
	self.add_child(player)
	var sound = AudioStreamSample.new()
	sound.data = body
	sound.format = AudioStreamSample.FORMAT_16_BITS
	sound.loop_mode = AudioStreamSample.LOOP_DISABLED
	sound.stereo = false
	sound.mix_rate = 16000
	player.stream = sound
	player.play()
