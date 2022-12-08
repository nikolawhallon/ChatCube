extends Spatial

func _ready():
	$CleverbotConverser.set_transform_to_play_at($ChatCube.global_transform)

func _on_DeepgramInstance_message_received(message):
	var message_dict = JSON.parse(message)
	var speech_final = message_dict.result["speech_final"]
	if speech_final:
		var transcript = message_dict.result["channel"]["alternatives"][0]["transcript"]
		if !transcript.empty():
			print(transcript)
			$CleverbotConverser.get_cleverbot_response(transcript)
