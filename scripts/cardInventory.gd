extends Resource
class_name CardInventory

# keyvalue pair where key = cardType AND value = cardAmt
@export var cards: Array[CardAndAmt]

# function to add a card to the inventory
func add_card(card: Card, amount: int):
	for entry in cards:
		if entry.card == card:
			entry.amt += amount
			return
	var new_entry = CardAndAmt.new()
	new_entry.card = card
	new_entry.amt = amount
	cards.append(new_entry)

# function to remove a card from the inventory
func remove_card(card: Card, amount: int):
	for entry in cards:
		if entry.card == card:
			entry.amt -= amount
			if entry.amt <= 0:
				cards.erase(entry)
			return

# function to get the amount of a specific card
func get_card_amount(card: Card) -> int:
	for entry in cards:
		if entry.card == card:
			return entry.amt
	return 0
