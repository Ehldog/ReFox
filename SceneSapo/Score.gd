extends Label

var scoring = 0

func _process(delta):
	text = "High Score: " + str(Global.globalscore / Global.SCORE_MODIFIER) + " "


