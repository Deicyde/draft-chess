extends Node2D

class_name Shop

var pawn_amount = 0
var knight_amount = 0
var bishop_amount = 0
var rook_amount = 0
var queen_amount = 0

var pawn_price = 1
var knight_price = 3
var bishop_price = 3
var rook_price = 5
var queen_price = 9

var max_income = 6
var income = 1
var turns_remaining = 18
var white_funds = 10
var black_funds = 10

@onready var pawn_amount_label = $"Graphics/Remaining Quantities/Pawn Amount"
@onready var knight_amount_label = $"Graphics/Remaining Quantities/Knight Amount"
@onready var bishop_amount_label = $"Graphics/Remaining Quantities/Bishop Amount"
@onready var rook_amount_label = $"Graphics/Remaining Quantities/Rook Amount"
@onready var queen_amount_label = $"Graphics/Remaining Quantities/Queen Amount"

@onready var white_funds_label = $WhiteFunds
@onready var black_funds_label = $BlackFunds

@onready var pawn_buy_button = $"Graphics/Buy Buttons/Pawn Buy"
@onready var knight_buy_button = $"Graphics/Buy Buttons/Knight Buy"
@onready var bishop_buy_button = $"Graphics/Buy Buttons/Bishop Buy"
@onready var rook_buy_button = $"Graphics/Buy Buttons/Rook Buy"
@onready var queen_buy_button = $"Graphics/Buy Buttons/Queen Buy"

@onready var piece_graphics = [$"Graphics/Pawn Graphic", $"Graphics/Knight Graphic", $"Graphics/Bishop Graphic", $"Graphics/Rook Graphic", $"Graphics/Queen Graphic"]

@onready var main_game = get_parent()

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_shop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset_shop():
	pawn_amount = 16
	knight_amount = 4
	bishop_amount = 4
	rook_amount = 4
	queen_amount = 2
	black_funds = 1
	white_funds = 0
	income = 1
	turns_remaining = 18
	update_shop()
	
func update_shop():
	pawn_amount_label.text = "x" + str(pawn_amount)
	knight_amount_label.text = "x" + str(knight_amount)
	bishop_amount_label.text = "x" + str(bishop_amount)
	rook_amount_label.text = "x" + str(rook_amount)
	queen_amount_label.text = "x" + str(queen_amount)
	white_funds_label.text = "White Funds: $" + str(white_funds) + "    (+$" + str(income) + " next turn)"
	black_funds_label.text = "Black Funds: $" + str(black_funds) + "    (+$" + str(min(income+1,6)) + " next turn)"
	$EndTurn.text = "Pass Turn \n (" + str(max(turns_remaining-1, 0)) + " remaining)"
	
func handle_purchase(fen_str):
	fen_str = fen_str.to_lower()
	var cost = 0
	if fen_str == 'p':
		pawn_amount -= 1
		cost = pawn_price
	if fen_str == 'n':
		knight_amount -= 1
		cost = knight_price
	if fen_str == 'b':
		bishop_amount -= 1
		cost = bishop_price
	if fen_str == 'r':
		rook_amount -= 1
		cost = rook_price
	if fen_str == 'q':
		queen_amount -= 1
		cost = queen_price
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		black_funds -= cost
	else:
		white_funds -= cost 
	update_shop()

func _on_pawn_buy_pressed() -> void:
	if main_game.game_state != Globals.GameState.DRAFTING:
		return
	if pawn_amount <= 0:
		return
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		if black_funds < pawn_price:
			return
	elif white_funds < pawn_price:
		return
	main_game.purchased_piece = Globals.PieceType.PAWN
	main_game.set_purchase_fen_str(Globals.PieceType.PAWN)
	main_game.purchase_markers()


func _on_knight_buy_pressed() -> void:
	if main_game.game_state != Globals.GameState.DRAFTING:
		return
	if knight_amount <= 0:
		return
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		if black_funds < knight_price:
			return
	elif white_funds < knight_price:
		return
	main_game.purchased_piece = Globals.PieceType.KNIGHT
	main_game.set_purchase_fen_str(Globals.PieceType.KNIGHT)
	main_game.purchase_markers()


func _on_bishop_buy_pressed() -> void:
	if main_game.game_state != Globals.GameState.DRAFTING:
		return
	if bishop_amount <= 0:
		return
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		if black_funds < bishop_price:
			return
	elif white_funds < bishop_price:
		return
	main_game.purchased_piece = Globals.PieceType.BISHOP
	main_game.set_purchase_fen_str(Globals.PieceType.BISHOP)
	main_game.purchase_markers()


func _on_rook_buy_pressed() -> void:
	if main_game.game_state != Globals.GameState.DRAFTING:
		return
	if rook_amount <= 0:
		return
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		if black_funds < rook_price:
			return
	elif white_funds < rook_price:
		return
	main_game.purchased_piece = Globals.PieceType.ROOK
	main_game.set_purchase_fen_str(Globals.PieceType.ROOK)
	main_game.purchase_markers()


func _on_queen_buy_pressed() -> void:
	if main_game.game_state != Globals.GameState.DRAFTING:
		return
	if queen_amount <= 0:
		return
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		if black_funds < queen_price:
			return
	elif white_funds < queen_price:
		return
	main_game.purchased_piece = Globals.PieceType.QUEEN
	main_game.set_purchase_fen_str(Globals.PieceType.QUEEN)
	main_game.purchase_markers()


func _on_end_turn_pressed() -> void:
	if main_game.game_state != Globals.GameState.DRAFTING:
		return
		
	main_game.flip_turn_no_move()
	
	if main_game.board.get_player_turn() == Globals.PieceColor.BLACK:
		if income < max_income:
			income += 1
		black_funds += income
		for piece in piece_graphics:
			piece.piece_type_str = piece.piece_type_str.to_lower()
			piece.reset()
	else:
		white_funds += income
		for piece in piece_graphics:
			piece.piece_type_str = piece.piece_type_str.to_upper()
			piece.reset()
			
	turns_remaining -= 1
	if turns_remaining == 0:
		black_funds -= max_income
		main_game.end_draft()
		
	update_shop()
