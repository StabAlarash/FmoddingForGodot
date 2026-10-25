extends Control
## Draw-strength bar (the fpc reticle already provides the crosshair).

var charge := 0.0
var aim_t := 0.0


func update_state(new_charge: float, new_aim_t: float) -> void:
	charge = new_charge
	aim_t = new_aim_t
	queue_redraw()


func _draw() -> void:
	var center := size * 0.5
	var color := Color(1, 1, 1, lerpf(0.6, 0.95, aim_t))

	# Crosshair ticks close in as the shot gets focused.
	var gap := lerpf(14.0, 3.0, aim_t)
	var tick := 7.0
	draw_line(center + Vector2(-gap - tick, 0), center + Vector2(-gap, 0), color, 2.0)
	draw_line(center + Vector2(gap, 0), center + Vector2(gap + tick, 0), color, 2.0)
	draw_line(center + Vector2(0, -gap - tick), center + Vector2(0, -gap), color, 2.0)
	draw_line(center + Vector2(0, gap), center + Vector2(0, gap + tick), color, 2.0)
	draw_circle(center, 1.5, color)

	if charge > 0.0:
		var bar := Rect2(Vector2(center.x - 110.0, size.y - 70.0), Vector2(220.0, 8.0))
		draw_rect(bar, Color(0, 0, 0, 0.5))
		var fill := bar
		fill.size.x *= charge
		draw_rect(fill, Color.WHITE.lerp(Color(1.0, 0.6, 0.1), charge))
