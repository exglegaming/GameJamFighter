extends RigidBody2D

@onready var hitbox = $"HitboxComponent"
@onready var particles:GPUParticles2D = $"GPUParticles2D"

func _on_body_entered(body):
	hitbox.hide()
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	particles.emitting = true

func _on_gpu_particles_2d_finished():
	queue_free()
