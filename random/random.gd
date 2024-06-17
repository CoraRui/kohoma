extends Node
class_name random_generator

#this class should help automate some of the randomization of things that i've been doing.

static func random_dict(rd : Dictionary) -> String:
	#this function accepts a dictionary with string keys and int values.
	#it selects one of those keys based on the weighted proportion of their value in the dict
	
	var total : int
	
	#collect total
	for v in rd.values():
		total += v
	
	#generate randomized value.
	var r : int = randi_range(0, total)
	
	#subtract the values from r until r < 0, return that value.
	for k in rd:
		r -= rd[k]
		if r <= 0:
			return k
		
	return "huh?"

