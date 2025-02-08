extends Node

const SMALL_CARD_SCALE = 0.6
const CARD_MOVE_SPEED = 0.2

var player_score
var enemy_score
var battle_timer
var empty_card_slots = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	empty_card_slots.append($"../EnemyCardSlot1")
	empty_card_slots.append($"../EnemyCardSlot2")
	empty_card_slots.append($"../EnemyCardSlot3")
	empty_card_slots.append($"../EnemyCardSlot4")
	empty_card_slots.append($"../EnemyCardSlot5")
	empty_card_slots.append($"../EnemyCardSlot6")
	empty_card_slots.append($"../EnemyCardSlot7")
	empty_card_slots.append($"../EnemyCardSlot8")
	empty_card_slots.append($"../EnemyCardSlot9")
	empty_card_slots.append($"../EnemyCardSlot10")
	
	player_score = 0
	$"../PlayerScore".text = str(player_score)
	enemy_score = 0
	$"../EnemyScore".text = str(enemy_score)
	
	
	

func _on_end_turn_button_pressed() -> void:
	opponent_turn()


func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false

	battle_timer.start()
	await battle_timer.timeout
	
	if $"../Deck".player_deck.size() != 0:
		$"../Deck".enemy_draw_card()
		battle_timer.start()
		await battle_timer.timeout

	if empty_card_slots.size() == 0:
		end_opponent_turn()
		return

	await try_play_card()
	
	
	end_opponent_turn()


func try_play_card():
	var enemy_hand = $"../EnemyHand".player_hand 
	if enemy_hand.size() == 0:
		end_opponent_turn()
		return
	
	var random_empty_card_slot = empty_card_slots[randi_range(0, empty_card_slots.size()-1)]
	empty_card_slots.erase(random_empty_card_slot)
	
	var curr_card_with_highest_score = enemy_hand[0]
	
	for card in enemy_hand:
		if card.points > curr_card_with_highest_score.points:
			curr_card_with_highest_score = card
			
	var tween = get_tree().create_tween()
	tween.tween_property(curr_card_with_highest_score, "position", random_empty_card_slot.position, CARD_MOVE_SPEED)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(curr_card_with_highest_score, "scale", Vector2(SMALL_CARD_SCALE, SMALL_CARD_SCALE), CARD_MOVE_SPEED)
	
	$"../EnemyHand".remove_card_from_hand(curr_card_with_highest_score)
	enemy_score = curr_card_with_highest_score.points + enemy_score
	$"../EnemyScore".text = str(enemy_score)
	battle_timer.start()
	await battle_timer.timeout

func end_opponent_turn():
	$"../Deck".reset_draw()
	$"../cardManager".reset_played_card()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
	if get_winner():
		return
	$"../Deck".draw_card()
	

func get_winner():
	if player_score >= 50:
		get_tree().change_scene_to_file("res://Scenes/win.tscn")
	if enemy_score >= 50:
		get_tree().change_scene_to_file("res://Scenes/lose.tscn")
		return true
