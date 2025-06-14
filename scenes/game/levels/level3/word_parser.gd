extends Node

const SILABAS_COMUNS = [
		"a", "e", "i", "o", "u",
		"ba","be","bi","bo","bu",
		"ca","ce","ci","co","cu",
		"da","de","di","do","du",
		"fa","fe","fi","fo","fu",
		"ga","ge","gi","go","gu",
		"ja", "jo", "ju",
		"la","le","li","lo","lu",
		"ma","me","mi","mo","mu",
		"na","ne","ni","no","nu",
		"pa","pe","pi","po","pu",
		"qua", "que", "qui", 
		"ra","re","ri","ro","ru",
		"rra", "rre", "rri", "rro", "rru",
		"sa","se","si","so","su",
		"ssa", "sse", "ssi", "sso", "ssu",
		"ta","te","ti","to","tu",
		"va","ve","vi","vo","vu",
		"xa", "xe", "xi", "xo", "xu",
		"ai","ei","eu","oi","ou",
		"ão","ãe","õe",
		"lha", "lhe", "lhi", "lho", "lhu",
		"cha", "che", "chi", "cho", "chu",
		"nha", "nhe", "nhi", "nho", "nhu"
	]

func remover_silaba_aleatoria(texto: String) -> String:
	var texto_lower = texto.to_lower()
	var silabas_presentes = []

	# Verificar quais sílabas estão presentes no texto
	for silaba in SILABAS_COMUNS:
		if texto_lower.find(silaba) >= 0:
			silabas_presentes.append(silaba)

	# Se não encontrar nenhuma sílaba conhecida, devolver o texto original
	if silabas_presentes.size() == 0:
		return texto

	# Escolher uma sílaba aleatória entre as encontradas
	randomize()
	var silaba_escolhida = silabas_presentes[randi() % silabas_presentes.size()]
	var substituto = "_" * silaba_escolhida.length()

	# Substituir todas as ocorrências da sílaba (insensível a maiúsculas/minúsculas)
	var resultado = ""
	var i = 0
	while i < texto.length():
		if texto.substr(i, silaba_escolhida.length()).to_lower() == silaba_escolhida:
			resultado += substituto
			i += silaba_escolhida.length()
		else:
			resultado += texto[i]
			i += 1

	return resultado
