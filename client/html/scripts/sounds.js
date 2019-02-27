var audioPlayer = null;
window.addEventListener('message', function(event) {
	if (event.data.transactionType == "playSound") {
	
		if (audioPlayer != null) {
			audioPlayer.pause();
		}

		audioPlayer = new Audio("./sounds/" + event.data.transactionFile + ".ogg");
		audioPlayer.volume = event.data.transactionVolume;
		audioPlayer.play();

	}
});