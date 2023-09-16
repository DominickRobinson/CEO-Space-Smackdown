extends Weapon


@onready var spring  = $Controller/DampedSpringJoint2D
@onready var controller = $Controller
@onready var line = $Line2D
@onready var collision = $Controller/CollisionShape2D


func _ready():
	spring.node_a = get_parent().get_path()
	spring.node_b = controller.get_path()
	
	controller.add_collision_exception_with(get_parent())
	
	deactivate()
	
	controller.body_entered.connect(_on_hit)

func _physics_process(delta):
	line.global_position = Vector2.ZERO
	if is_instance_valid(spring.node_a) and is_instance_valid(spring.node_b):
		line.set_point_position(0, get_node(spring.node_a).global_position) 
		line.set_point_position(1, get_node(spring.node_b).global_position) 
	
	get_node(spring.node_a)

func activate():
	visible = true
	collision.disabled = false

func deactivate():
	visible = false
	collision.disabled = true


func _on_hit(body : Node):
	if body is Player:
		var p = body as Player
		var vec = Vector2(cos(global_rotation), sin(global_rotation)) * impulse_length
		p.take_damage(damage, vec)
