extends Node2D
class_name file_creator

#this script should allow the player to name their save_file


@export var name_label : Label

var fi : int = -1

@export var file_slots : Array[file_slot]

#autoloads
@onready var save_fi : save_file = get_node("/root/save_file_auto")

func _ready():
	pass

func add_to_label(c : String):
	name_label.text += c

func _on_a_activated():
	add_to_label("A")

func _on_finish_activated():
	if fi == -1:
		print("no file index in file creator, file not created.")
		return
	var new_file : file_01 = file_01.new()
	new_file.player_name = name_label.text
	save_fi.current_file = new_file
	save_fi.record_file(fi)
	file_slots[fi].refresh_display()

func _on_b_activated():
	add_to_label("B")

func _on_c_activated():
	add_to_label("C")

func _on_d_activated():
	add_to_label("D")

func _on_e_activated():
	add_to_label("E")

func _on_f_activated():
	add_to_label("F")

func _on_g_activated():
	add_to_label("G")

func _on_h_activated():
	add_to_label("H")

func _on_i_activated():
	add_to_label("I")

func _on_j_activated():
	add_to_label("J")

func _on_k_activated():
	add_to_label("K")

func _on_l_activated():
	add_to_label("L")

func _on_m_activated():
	add_to_label("M")

func _on_n_activated():
	add_to_label("N")

func _on_o_activated():
	add_to_label("O")

func _on_p_activated():
	add_to_label("P")

func _on_q_activated():
	add_to_label("Q")

func _on_r_activated():
	add_to_label("R")

func _on_s_activated():
	add_to_label("S")

func _on_t_activated():
	add_to_label("T")

func _on_u_activated():
	add_to_label("U")

func _on_v_activated():
	add_to_label("V")

func _on_w_activated():
	add_to_label("W")

func _on_x_activated():
	add_to_label("X")

func _on_y_activated():
	add_to_label("Y")

func _on_z_activated():
	add_to_label("Z")
