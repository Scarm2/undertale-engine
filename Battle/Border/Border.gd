extends NinePatchRect

# Original by JCW87

var ResizeSpeed = 480

signal ResizeFinished


func _physics_process(delta: float) -> void:
	var X1 = min(ResizeSpeed * delta, abs(margin_left - Globals.IdealBorder[0]))
	var Y1 = min(ResizeSpeed * delta, abs(margin_top - Globals.IdealBorder[2]))
	var X2 = min(ResizeSpeed * delta, abs(margin_right - Globals.IdealBorder[1]))
	var Y2 = min(ResizeSpeed * delta, abs(margin_bottom - Globals.IdealBorder[3]))
	
	if margin_left > Globals.IdealBorder[0]: margin_left -= X1
	elif margin_left < Globals.IdealBorder[0]: margin_left += X1
	
	if margin_top > Globals.IdealBorder[2]: margin_top -= Y1
	elif margin_top < Globals.IdealBorder[2]: margin_top += Y1
	
	if margin_right > Globals.IdealBorder[1]: margin_right -= X2
	elif margin_right < Globals.IdealBorder[1]: margin_right += X2
	
	if margin_bottom > Globals.IdealBorder[3]: margin_bottom -= Y2
	elif margin_bottom < Globals.IdealBorder[3]: margin_bottom += Y2
	
	if (margin_left == Globals.IdealBorder[0] and
		margin_top == Globals.IdealBorder[2] and
		margin_right == Globals.IdealBorder[1] and
		margin_bottom == Globals.IdealBorder[3]
		): emit_signal("ResizeFinished")
	
	rect_pivot_offset = rect_size / 2.0
	
	$Background/Color.margin_right = rect_size.x + 2
	$Background/Color.margin_bottom = rect_size.y + 2
	
	$Collision/Left.shape.extents = Vector2(480, 640)
	$Collision/Top.shape.extents = Vector2(640, 480)
	$Collision/Right.shape.extents = $Collision/Left.shape.extents
	$Collision/Bottom.shape.extents = $Collision/Top.shape.extents
	
	$Collision/Left.position = Vector2(-$Collision/Left.shape.extents.x + 5, $Collision/Left.shape.extents.y - 480)
	$Collision/Top.position = Vector2(rect_size.x / 2, -$Collision/Top.shape.extents.y + 5)
	$Collision/Right.position = Vector2(rect_size.x + $Collision/Right.shape.extents.x - 5, $Collision/Right.shape.extents.y - 480)
	$Collision/Bottom.position = Vector2(rect_size.x / 2, rect_size.y + $Collision/Top.shape.extents.y - 5)
	
	$TargetBottomMask.position = rect_size
