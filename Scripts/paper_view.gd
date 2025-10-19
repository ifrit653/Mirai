extends Node2D

@onready var paper_sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var next_button: Button = $NextButton
@onready var prev_button: Button = $PrevButton
@onready var page_number : Label = $PageNumber  

var pages: Array[String] = []
var current_page := 0

func _ready():
	# Set label color but don't print yet - no content loaded
	label.modulate = Color.BLACK

func show_paper(paper_id : int):
	print("the paper is shwan")
	pages = _load_paper_pages(paper_id)
	current_page = 0
	_update_page()
	
	# Force label visibility
	label.visible = true
	label.modulate = Color.BLACK
	label.z_index = 10
	

func _update_page():
	if pages.size() > 0:
		label.text = pages[current_page]
		page_number.text = str(current_page + 1)
		print("Updated to page ", current_page, ": ", label.text)
		print("Label visible: ", label.visible)
		print("Label modulate: ", label.modulate)
	else:
		print("No pages to display!")

func _on_next_pressed() -> void:
	if current_page < pages.size() - 1:
		current_page += 1
		_update_page()

func _on_prev_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		_update_page()

func _load_paper_pages(paper_id: int) -> Array[String]:
	match paper_id:
		1:
			return [
				"CASE #: CP-2025-1047
				Date: 2025-10-19
				Time reported: 14:12
				Location: 8 Rue de la Paix, Market District",
				
				"Offender details\n
				Name: Armand R. Faly
				Age: 22
				Gender: Male
				Address: Lot 14B, Market District
				ID: ID-4589-MG
				Occupation: Street vendor (fruit stall)", 
				
				'Reported infraction: \n
				Type: Petty theft/shoplifting (value under 10,000 MGA)
				Summary:
				Suspect allegedly removed a packaged snack from a convenience stall without paying. Staff noticed and called municipal officer. Suspect claims "forgot" and intended to pay later.',
				'Evidence collected\n
				CCTV clip from convenience stall (timestamp 2025-10-19 13:58) — 12 seconds.
				Witness statement (vendor): "He picked an item, looked around and walked out without paying." (Signed)
				Item recovered: single pack of chips (serial/batch unknown).
				No prior convictions on record.',
				'Witness statements\n 
				Vendor: Mme. H. Rakoto "He took a pack, then left quickly. I called the patrol."
				Friend (present): Mr. J. Andry "He said he was embarrassed and would come pay." (verbal)
				Officer notes
				Suspect cooperative. Appeared nervous. No physical altercation. Item value: approx. 4,200 MGA. Recommended citation and return of item (if still usable).',
				'Legal classification & suggested disposition\n
				Infraction code: M-101 (Petty theft — summary offence)
				Recommended disposition by Officer: Fine 20,000 MGA or 2 days community service; mandatory apology to vendor; attend community awareness session on petty theft consequences. Restitution: 4,200 MGA (item cost) to vendor.'
			]
		2:
			return [
				"Repport \n\n'Today, I saw something move in the cellar...'",
				"Page 2: The rest is unreadable."
			]
		_:
			return ["This page is blank."]

func _on_close_button_pressed() -> void:
	queue_free()
