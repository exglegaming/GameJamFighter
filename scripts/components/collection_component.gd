extends Area2D


func _on_body_entered(body):
	print(global_position)
	body.apply_central_impulse(Vector2.UP*250)
	body.apply_central_impulse((global_position - body.position).normalized()*100)


func _on_inner_area_body_entered(body):
	body.queue_free()

#func _on_body_exited(body):
