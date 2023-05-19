# Chat Cube

As speech and language AI becomes more mature, being able to converse with non-playable-characters (NPCs) in video games
is becoming a closer and closer reality. Well, technically it has been possible since at least Seaman (1999),
but early conversational AI NPCs were extremely limited compared to what can be done with the deep-learning models of
today (and indeed, of tomorrow). Here I present a simple "game" where you can have a conversation with an NPC backed
by some of the leading models in AI!

Chat Cube is a demo using the Godot game engine where you talk to an AI NPC - and that AI NPC is a cube!
When you speak into the microphone, Deepgram transcribes your speech, sends it off to a chat bot AI to get a response,
and then the rotating cube says that response using Elevenlabs text-to-speech (TTS). Currently the chat bot
is Cleverbot, but this demo will be expanded to support ChatGPT as soon as I get a solid hour or so of dev time.

The game is hosted on itch.io here: https://browncanstudios.itch.io/chat-cube and below I'll describe
how to run it in the Godot Editor, and where you could take this demo.

<p align="center">
  <img src="./READMEAssets/chatcubeitchcover.png" alt="A picture of Chat Cube."/>
</p>

## Pre-requisites

* Godot 3.x
* a Deepgram API Key
* an Elevenlabs API Key
* a Cleverbot API Key
* (Optional) it would be very useful to go through [the Deepgram-Godot tutorial](https://blog.deepgram.com/deepgram-godot-tutorial/)

## Running the game

Clone the repository for the game:

```
git clone git@github.com:nikolawhallon/ChatCube.git
```

Next, edit the following file, replacing `INSERT_YOUR_DEEPGRAM_API_KEY` with your Deepgram API Key:

```
ChatCube/Scenes/DeepgramIntegration/DeepgramInstance.gd
```

Likewise, edit the following file, replacing `INSERT_YOUR_CLEVERBOT_API_KEY` and `INSERT_YOUR_ELEVENLABS_API_KEY` with
your Cleverbot API Key and Elevenlabs API Key, respectively:

```
ChatCube/Scenes/CleverbotConverser.gd
```

Now, open Godot 3.x, import the game, and click the "Run" button!

## Some tech

[The Deepgram-Godot tutorial](https://blog.deepgram.com/deepgram-godot-tutorial/) describes how to use your microphone
to stream audio to Deepgram and receive transcripts back in Godot. This demo extends the demo presented there with
a chatbot and with TTS. The script `ChatCube/Game.gd` handles signals from Deepgram integration as follows:

```
func _on_DeepgramInstance_message_received(message):
	var message_dict = JSON.parse(message)
	var speech_final = message_dict.result["speech_final"]
	if speech_final:
		var transcript = message_dict.result["channel"]["alternatives"][0]["transcript"]
		if !transcript.empty():
			print(transcript)
			$CleverbotConverser.get_cleverbot_response(transcript)
```

It tries to parse Deepgram responses as `json`, and if a non-empty transcript is received marked as `speech_final`,
it will call `$CleverbotConverser.get_cleverbot_response(transcript)`. This function is defined
in the `ChatCube/Scenes/CleverbotConverser.gd` script, which contains all the logic for the chatbot and TTS integration

TODO: Finish.

## Conclusion

This is cool tech!

TODO: Finish.
