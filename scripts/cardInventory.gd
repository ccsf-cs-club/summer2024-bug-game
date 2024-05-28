extends Resource
class_name CardInventory
# A class that define what a draw deck is and contains, for both the player and opponent

# keyvalue pair where key = cardType AND value = cardAmt
@export var card_hand: Array[CardAndAmt] # TODO Maybe rename this for clarity

# function to add a card to the inventory
func add_card(added_card: Card, added_amount: int):
	for entry in card_hand:# checks if current entry is the same as a card already in hand
		if entry.card == added_card:
			entry.amt += added_amount
			return
	var new_entry = CardAndAmt.new()
	new_entry.card = added_card
	new_entry.amt = added_amount
	card_hand.append(new_entry)

# function to remove a card from the inventory
func remove_card(removed_card: Card, removed_amount: int):
	for entry in card_hand:
		if entry.card == removed_card:
			entry.amt -= removed_amount
			if entry.amt <= 0:
				card_hand.erase(entry)
			return

# function to get the amount of a specific card
func get_card_amount(card_inst: Card) -> int:
	for entry in card_hand:
		if entry.card == card_inst:
			return entry.amt
	return 0
