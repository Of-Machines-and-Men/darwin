class_name RoundTransition
extends CanvasLayer

@onready var fade_rect: ColorRect = $FadeRect
@onready var banner_container: Control = $BannerContainer
@onready var banner_label: Label = $BannerContainer/BannerLabel

const BANNER_HOLD: float = 1.5
const BANNER_FADE: float = 0.3
const SCREEN_FADE: float = 0.5

func _ready() -> void:
	fade_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	banner_container.modulate.a = 0.0


## Shows the round complete banner, then fades the screen to black.
## Awaitable — resumes when the screen is fully black.
func play_round_end(round_number: int) -> void:
	banner_label.text = "Round %d Complete!" % round_number

	var tween := create_tween()
	tween.tween_property(banner_container, "modulate:a", 1.0, BANNER_FADE)
	await tween.finished

	await get_tree().create_timer(BANNER_HOLD).timeout

	tween = create_tween().set_parallel(true)
	tween.tween_property(banner_container, "modulate:a", 0.0, SCREEN_FADE)
	tween.tween_property(fade_rect, "color:a", 1.0, SCREEN_FADE)
	await tween.finished


## Fades the screen to black. Awaitable.
func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, SCREEN_FADE)
	await tween.finished


## Fades the screen in from black. Awaitable.
func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, SCREEN_FADE)
	await tween.finished
