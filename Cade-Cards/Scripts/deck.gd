extends Node2D

const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const ENEMY_CARD_SCENE_PATH = "res://Scenes/EnemyCard.tscn"
const CARD_DRAW_SPEED = 0.7
const STARTING_HAND_SIZE = 5
const PLAYER_HAND = true
const ENEMY_HAND = false

var player_deck = ["Shiny Nickle", 
"3 Dolla", "3 Dolla", "3 Dolla", "3 Dolla", "3 Dolla", "3 Dolla",
"Picture of Markiplier",
 "5 Dolla","5 Dolla","5 Dolla","5 Dolla","5 Dolla", 
"10 Dolla", "10 Dolla", "10 Dolla", "10 Dolla", "10 Dolla", 
"Treasure Trove", "Treasure Trove", 
"Golden F-150", 
"Flies", "Flies", "Flies", "Flies", "Flies", "Flies", 
"Worms", 
"Raccoons", "Raccoons", "Raccoons", 
"Crabs", "Crabs", "Crabs",  
"Nuclear Waste"]

var card_database_reference
var drawn_card_this_turn = false

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_card_this_turn = false
	for i in range(STARTING_HAND_SIZE):
		enemy_draw_card()
	draw_card()

func draw_card():
	if drawn_card_this_turn:
		return
	
	drawn_card_this_turn = true
	if player_deck.size() > 0:
		var card_drawn_name = player_deck[0]
		player_deck.erase(card_drawn_name)
		
		if player_deck.size() == 0:
			$Area2D/CollisionShape2D.disabled = true
			$Sprite2D.visible = false
			$RichTextLabel.visible = false
		 
		$RichTextLabel.text = str(player_deck.size())
		#change image
		#var card_image_path = str("res://images/cards/" + card_drawn_name ".png")
		#new_card.get_node("cardImage").texture = load(card_image_path)
		var card_scene = preload(CARD_SCENE_PATH)
		var new_card = card_scene.instantiate()
		new_card.points = card_database_reference.CARDS[card_drawn_name][0]
		new_card.get_node("Points").text = str(card_database_reference.CARDS[card_drawn_name][0])
		$"../cardManager".add_child(new_card)
		new_card.name = "Card"
		$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)




func enemy_draw_card():
	
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	#change image
	#var card_image_path = str("res://images/cards/" + card_drawn_name ".png")
	#new_card.get_node("cardImage").texture = load(card_image_path)

	var card_scene = preload(ENEMY_CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	new_card.points = card_database_reference.CARDS[card_drawn_name][0]
	new_card.get_node("Points").text = str(new_card.points)
	$"../cardManager".add_child(new_card)
	new_card.name = "Card"
	$"../EnemyHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	



func reset_draw():
	drawn_card_this_turn = false
