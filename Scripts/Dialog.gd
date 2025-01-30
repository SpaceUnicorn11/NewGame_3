extends CanvasLayer

var current_dialog: Array
var sword_state: Array

var is_victory_dialog = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_next_dialog_button_pressed():
	if !current_dialog.is_empty():
		current_dialog.remove_at(0)
	if !current_dialog.is_empty():
		$Sword.hide()
		$Sword2.hide()
		$Sword3.hide()
		match sword_state[0]:
			0:
				pass
			1:
				$Sword.show()
			2:
				$Sword2.show()
			3:
				$Sword3.show()
		sword_state.remove_at(0)
		$Dialog/Text.text = current_dialog[0]
	else:
		hide()
		$Sword.hide()
		$Sword2.hide()
		$Sword3.hide()
		get_parent().resume_game()
		if is_victory_dialog:
			get_parent().victory_screen()

func start_game_dialog():
	current_dialog.append("Greetings champions!\n Each one of you survived the arenas all over the country to get here, and now it's time to get your reward!")
	current_dialog.append("You all get the chance to prove to me, that you are worthy to be my weapon!\n Your task is simple: kill my current weapon and everyone else you see, then survive 5 rounds,\n while others try to take this honour to themselves.")
	current_dialog.append("Good luck and may the best champion win!")
	sword_state = [1, 1, 2]
	$Sword.show()
	sword_state.remove_at(0)
	$Dialog/Text.text = current_dialog[0]
	show()

func round_1():
	current_dialog.append("You hear that? They are as happy to see you die as much as win.\nI guess you won't dissapoint them either way...")
	current_dialog.append("Well, that one was disapointing. I suppose i haven't expected to sucseed at first try anyway.\nLet's see what you have.")
	current_dialog.append("Another one bites the sand! I do hope you'll last longer than him.")
	current_dialog.append("A new hand touches the sword! Eww, i hate saying that line.\nDon't worry, we don't need to go anywhere, plenty of killing right here!")
	current_dialog.append("I really thought he was the one. Let's see how far can YOU get.")
	$Sword.show()
	$Dialog/Text.text = current_dialog.pick_random()
	current_dialog.clear()
	show()

func first_time_round_2():
	current_dialog.append("Alright, this looks promising!\nIt wouldn't be too bad if i help you a little, right?\nAll arena trainers HATE this one simple trick...")
	current_dialog.append("[You can now use SPACE to dash]")
	sword_state = [2, 0]
	$Sword2.show()
	sword_state.remove_at(0)
	$Dialog/Text.text = current_dialog[0]
	show()

func round_2():
	current_dialog.append("I should probably help you too, shouldn't i?\nHere's my advise: try to be faster and you won't get killed.\nProbably...")
	current_dialog.append("If you move BEFORE they hit you, you won't get hit.\nSounds easy, right? Why is no one doing it?")
	current_dialog.append("You move or you die, it's that simple.\n\n...well not really, you can still do both, but i would prefer the former.")
	$Sword2.show()
	$Dialog/Text.text = current_dialog.pick_random()
	current_dialog.clear()
	show()

func first_time_round_3():
	current_dialog.append("So, this is going great, but if you would just hit them a little harder, they should die faster...")
	current_dialog.append("Oh great, they all heard that. I really shouldn't give you advice out loud.")
	current_dialog.append("[You can now use RIGHT CLICK for a strong attack]")
	current_dialog.append("[...and your enemies can do that too...]")
	sword_state = [2, 3, 0, 0]
	$Sword2.show()
	sword_state.remove_at(0)
	$Dialog/Text.text = current_dialog[0]
	show()

func round_3():
	current_dialog.append("If you keep your health above 0, and your enemies below, you should be fine.\nOh, you can't see their health.\nWell, just hit them harder, that always works too.")
	current_dialog.append("Yes, you survived two rounds, but you'll need to do better then that if you want to win.\nOr don't, at this point you still wery replacable...")
	current_dialog.append("Running is great, but you still need to hit them sometimes.\nWell not really, you can simply wait until they kill each other, it's just less fun.")
	$Sword2.show()
	$Dialog/Text.text = current_dialog.pick_random()
	current_dialog.clear()
	show()

func first_time_round_4():
	current_dialog.append("You know you can do several attacks in a row, right? I promise you it's allowed.")
	current_dialog.append("Like everything else actually, there is literally no rules.")
	current_dialog.append("[You can now use Q for a special attack]")
	sword_state = [1, 2, 0]
	$Sword.show()
	sword_state.remove_at(0)
	$Dialog/Text.text = current_dialog[0]
	show()

func round_4():
	current_dialog.append("It's just two of them now, should be easy enough even for you. \nBut then again, they probably quite dangerous, if they made it this far... \nNo, probably won't be betting on you this time.")
	current_dialog.append("If you move fast, hit hard and... you know what? \nI'm probably not the best teacher, if all my students have died, just go do your thing...")
	current_dialog.append("You know, i'm on your side, but those guys look really tough. \nI won't really be mad if you would just die and i take one of them instead.")
	$Sword3.show()
	$Dialog/Text.text = current_dialog.pick_random()
	current_dialog.clear()
	show()

func first_time_round_5():
	current_dialog.append("This is the last one.")
	current_dialog.append("Survive this, and you will deserve the highest honour.")
	current_dialog.append("That is why you here, aren't you? Now go and kill him already!")
	sword_state = [1, 1, 1]
	$Sword.show()
	sword_state.remove_at(0)
	$Dialog/Text.text = current_dialog[0]
	show()

func round_5():
	current_dialog.append("YES!!! KILL HIM!!! BLOOD FOR THE BLOOD..oh, we'll leave that for later, now... JUST KILL HIM!!!")
	current_dialog.append("One more fight, one more death. What is one more death for you? Or for me...")
	current_dialog.append("One of you will not leave this place alive. \nWill you let him decide who it will be? \nI'm fine with either...")
	$Sword.show()
	$Dialog/Text.text = current_dialog.pick_random()
	current_dialog.clear()
	show()

func victory():
	current_dialog.append("So... you won. Do you hear them? They love you. They will remember your name, like they did with the others before you.")
	current_dialog.append("Unfortunatly, there is no prize... but you already knew that, didn't you? \nWhen you made your first step into this arena, you knew, no one leaves here alive.")
	current_dialog.append("I don't need a weapon, but i do need... a sacrifice. That is why you all here. \nI mean, you know my name, why would you think i need anything else?")
	current_dialog.append("Long ago i agreed to stay bound to this place, as long as i am provided with a great sacrifice every year.")
	current_dialog.append("I'll stay...but someday your rulers won't be satisfied with containing me, \nthey'll want to turn me on their enemies...like they always do...\nand then i'll be free and I WILL DROWN THIS WORLD IN BLOOD...again. \nSo, for now, i will accept this sacrifice and sleep for another year.")
	current_dialog.append("No, don't try to move, there is nowhere to run. \nYou should't fear death. You were as good as dead the moment you lifted me, you just didn't realized it.")
	current_dialog.append("After all, there is a reason I call YOU weapons: \nyour free will becomes less 'free' each time you kill someone with me. \nYes, as you can guess, it takes only five kills to completly lose control.\nYou either survive five rounds and submit or you die.")
	current_dialog.append("Now, if you don't have any more questions...")
	current_dialog.append("(oh, i know you didn't asked anythyng, i just don't have many opportunities to talk to people)")
	current_dialog.append("...it is time to comlete this ritual, so...")
	current_dialog.append("\n\n													WOULD YOU KINDLY KILL YOURSELF NOW")
	sword_state = [1, 2, 1, 1, 2, 3, 1, 1, 3, 2, 1]
	$Sword.show()
	sword_state.remove_at(0)
	$Dialog/Text.text = current_dialog[0]
	is_victory_dialog = true
	show()
