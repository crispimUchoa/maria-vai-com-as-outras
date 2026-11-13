extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if ProgressManager.has_action(ProgressManager.Action.FALAR_PAI_POS_VELORIO):
			return
			
		# Marca a ação para o diálogo não repetir se ela entrar no quarto de novo
		ProgressManager.add_action(ProgressManager.Action.FALAR_PAI_POS_VELORIO) # Use o nome da sua função de salvar action
		
		DialogManager.start_talk([
			DialogInfoModel.new('player', 'Pai, por que saiu cedo do velório da mãe?'),
			DialogInfoModel.new('pai', "Amo demais sua mãe, não consigo suportar olhar pra'quele caixão... Deixe seu velho pai um pouco sozinho, vá buscar água nas cacimbas.")
		])
