extends CanvasLayer
class_name HUDCombate

@export_group("Corações da Maria")
@export var maria_coracao_cheio: Texture2D
@export var maria_coracao_vazio: Texture2D

@export_group("Corações do Lobisomem")
@export var lobo_coracao_cheio: Texture2D
@export var lobo_coracao_vazio: Texture2D

@onready var control_raiz: Control = $Control
@onready var box_maria: HBoxContainer = $Control/CoracoesMaria
@onready var box_lobisomem: HBoxContainer = $Control/CoracoesLobisomem

func _ready() -> void:
	add_to_group("hud_combate")
	layer = 10 # Garante que fique acima de sombras, vinhetas e luzes do mapa
	visible = true
	ocultar_hud()

func iniciar_hud_combate(vida_maria: int = 3, vida_lobisomem: int = 3) -> void:
	print("[HUDCombate] Iniciando HUD -> Maria: ", vida_maria, " | Lobo: ", vida_lobisomem)
	visible = true
	if control_raiz:
		control_raiz.visible = true
	if box_maria:
		box_maria.visible = true
	if box_lobisomem:
		box_lobisomem.visible = true
		
	atualizar_vida_maria(vida_maria)
	atualizar_vida_lobisomem(vida_lobisomem)

func ocultar_hud() -> void:
	if box_maria:
		box_maria.visible = false
	if box_lobisomem:
		box_lobisomem.visible = false

func atualizar_vida_maria(vida_atual: int) -> void:
	_atualizar_coracoes(box_maria, vida_atual, maria_coracao_cheio, maria_coracao_vazio)

func atualizar_vida_lobisomem(vida_atual: int) -> void:
	_atualizar_coracoes(box_lobisomem, vida_atual, lobo_coracao_cheio, lobo_coracao_vazio)

func _atualizar_coracoes(container: HBoxContainer, vida_atual: int, tex_cheio: Texture2D, tex_vazio: Texture2D) -> void:
	if not container:
		return
	var coracoes = container.get_children()
	for i in range(coracoes.size()):
		var icone = coracoes[i] as TextureRect
		if not icone:
			continue
			
		if i < vida_atual:
			icone.texture = tex_cheio
		else:
			icone.texture = tex_vazio
