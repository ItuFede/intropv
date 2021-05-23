extends AudioStreamPlayer

#Audio files:
onready var jump = load("res://Audio/Sfx/Jump.ogg") 
onready var roll = load("res://Audio/Sfx/Roll.ogg") 
onready var footsteps = [load("res://Audio/Sfx/Leaves1.ogg"), load("res://Audio/Sfx/Leaves2.ogg")] 
onready var playerHurt = load("res://Audio/Sfx/playerHurt.wav")
onready var playerAttack = load("res://Audio/Sfx/PlayerAttack.ogg")
onready var gameOver = load("res://Audio/Bgm/gameOver.ogg")
