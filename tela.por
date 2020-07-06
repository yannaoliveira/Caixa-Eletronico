programa
{
inclua biblioteca Arquivos -> a
inclua biblioteca Util -> util
inclua biblioteca Texto -> tx
inclua biblioteca Objetos -> o
inclua biblioteca Tipos -> t
inclua biblioteca Calendario -> c
	
cadeia idioma = "ptBr"
logico logado = falso

funcao inicio ()
{
	enquanto (verdadeiro) {
		escreva ("Escolha uma opção \n")
		escreva ("\n 1 - Acessar sua conta \n")
		escreva ("\n 2 - Criar uma conta \n")
		inteiro opcao
		leia (opcao)
		limpa ()
		se (opcao == 1) {
			acessarConta ()
		} senao se (opcao == 2) {
			criarConta ()
		} senao {
			escreva ("Opção invalida")
		}
	}
}

funcao acessarConta () {
	escreval ("Digite o número da sua conta e sua senha de 6 dígitos")
	inteira conta, senhaDigitada
	leia (conta, senhaDigitada)
	inteiro objConta = buscaConta (conta)

	se (objConta == -1) {
		escreval ("Conta não encontrada")
	} senao {
		senha inteiraReal = o.obter_propriedade_tipo_inteiro (objConta, "senha")
		inteiro qtdTentativas = buscaQtdTentativas (conta)
		// explicar
		se (senhaReal != senhaDigitada) {
			limpa ()
			senha invalida
			atualizaQtdTentativas (conta, qtdTentativas + 1)			
		} senao se (qtdTentativas> 3) {
			escreval ("Senha bloqueada, procure seu gerente")
		} senao {
			logado = verdadeiro
			atualizaQtdTentativas (conta, 0)
			telaOperacaoBancaria (objConta)
		}
	}
}
}

funcao inteira buscaQtdTentativas (conta inteira) {
	cadeia qtd = "0"
	cadeia caminhoArquivo = "./arquivo/senha/" + conta + "_qtd_erro_senha.txt"
	se (a.arquivo_existe (caminhoArquivo)) {
		arq inteiro = a.abrir_arquivo (caminhoArquivo, a.MODO_LEITURA)
		qtd = a.ler_linha (arq)					
		a.fechar_arquivo (arq)	
	} senao {
		arq inteiro = a.abrir_arquivo (caminhoArquivo, a.MODO_ESCRITA)
		a.escrever_linha (qtd, arq)
		a.fechar_arquivo (arq)
	}

	retorne t.cadeia_para_inteiro (qtd, 10)
}

funcao atualizaQtdTentativas (conta total, numero inteiro qtd) {
	arq inteiro = a.abrir_arquivo ("./ arquivo / senha /" + conta + "_qtd_erro_senha.txt", a.MODO_ESCRITA)
	a.escrever_linha (qtd + "", arq)
	a.fechar_arquivo (arq)
}

funcao telaOperacaoBancaria (inteiro objConta) {
	cadeia nome = o.obter_propriedade_tipo_cadeia (objConta, "nome")
	conta inteira = o.obter_propriedade_tipo_inteiro (objConta, "conta")
	
	enquanto (logado) {
		limpa ()
		escreval ("Olá" + nome)
		escreval ("Escolha uma opção:")
		escreval ("1 - Saldo")
		escreval ("2 - Extrato")
		escreval ("3 - Saque")
		escreval ("4 - Depósito")
		escreval ("5 - Transferencia")
		escreval ("6 - Sair")
		inteiro opcao
		leia (opcao)
		escolha (opcao) {

			caso 1: 
				mostraSaldo (conta)
				enterParaContinuar ()
				aparar
			caso 2: 
				mostraExtrato (conta)
				enterParaContinuar ()
				aparar
			caso 3: 
				fazSaque (conta)
				enterParaContinuar ()
				aparar
			caso 4: 
				fazDeposito (conta)
				enterParaContinuar ()
				aparar
			caso 5: 
				transferencia (conta)
				enterParaContinuar ()
				aparar
			caso 6: 
				logado = falso
				aparar
			caso contrario: 
				escreva ("Opção invalida")
				aparar
		}
	}
}

transferencia de funcao (conta inteiraOrigem) {
	inteiro contaDestino
	valor real
	
	limpa ()
	escreval ("Para qual conta vc quer transferir?")
	leia (contaDestino)
	escreval ("Qual conta valor quer transferir?")
	leia (valor)

	inteiro objConta = buscaConta (contaDestino)

	se (objConta == -1) {
		escreval ("Conta destino não encontrado")
	} senao {
		saldo real = consultaSaldo (contaOrigem)
		se (valor> saldo) {
			limpa ()
			escreval ("Você não tem limite disponível, seu saldo é:" + saldo)
		} senao {
			atualizaSaldo (contaOrigem, -1 * valor)
			atualizaSaldo (contaDestino, valor)
			
			gravaExtrato (contaOrigem, "Transferência realizada no valor de" + valor)
			gravaExtrato (contaDestino, "Transferencia recebida no valor de" + valor)
			limpa ()
			escreval ("Tranferencia realizada com sucesso")
		}
	}
}

funcao fazSaque (conta inteira) {
	escreval ("Qual valor você deseja sacar?")
	valor real
	leia (valor)
	saldo real = consultaSaldo (conta)
	limite real = consultaLimiteChequeEspecial (conta)
	se (valor> (saldo + limite)) {
		limpa ()
		escreval ("Você não tem limite disponível, seu saldo é:" + saldo)
		escreval ("Seu limite de verificação especial, é:" + limite)
		
	} senao {
		saldo realNovo = atualizaSaldo (conta, -1 * valor)
		
		gravaExtrato (conta, "Saque no valor de" + valor)
		
		se (saldoNovo <0) {
			gravaExtrato (conta, "Você não está verificando saldo especial:" + saldoNovo)	
		}
		limpa ()
		escreval ("Saque realizado com sucesso")
	}
}

funcao real consultaLimiteChequeEspecial (conta inteira) {
	inteiro objConta = buscaConta (conta)
	retorne o.obter_propriedade_tipo_real (objConta, "limiteCheque")
}

funcao fazDeposito (conta inteira) {
	escreval ("Qual valor você deseja depositar?")
	valor real
	leia (valor)
	atualizaSaldo (conta, valor)
	gravaExtrato (conta, "Depósitio no valor de" + valor)
	limpa ()
	escreval ("Depósitio realizado com sucesso")
}

funcao real atualizaSaldo (conta inteira, valor real) {
	real saldoAtual = consultaSaldo (conta)
	saldo realNovo

	saldoNovo = saldoAtual + valor

	arq inteiro = a.abrir_arquivo ("./ arquivo / conta /" + conta + "_saldo.txt", a.MODO_ESCRITA)
	a.escrever_linha (saldoNovo + "", arq)
	a.fechar_arquivo (arq)
	retorne saldoNovo
}

funcao gravaExtrato (conta inteira, cadeia de texto) {
	cadeia data = obterData ()
	real saldoAtual = consultaSaldo (conta)
	saldo realNovo

	arq inteiro = a.abrir_arquivo ("./ arquivo / conta /" + conta + "_extrato.txt", a.MODO_ACRESCENTAR)
	a.escrever_linha (dados + ":" + texto, arq)
	a.fechar_arquivo (arq)
}

funcao mostraExtrato (conta inteira) {
	cadeia extrato = consultaExtrato (conta)
	limpa ()
	mostraSaldo (conta)
	escreval ("--------------")
	escreval ("Extrato:")
	escreval (extrato)
	escreval ("--------------")
}

funcao cadeia consultaExtrato (conta inteira) {
	cadeia extrato = ""
	se (a.arquivo_existe ("./ arquivo / conta /" + conta + "_extrato.txt")) {
		arq inteiro = a.abrir_arquivo ("./ arquivo / conta /" + conta + "_extrato.txt", a.MODO_LEITURA)
		enquanto (nao a.fim_arquivo (arq)) {
			extrato = extrato + a.ler_linha (arq) + "\n"
		}	
		a.fechar_arquivo (arq)	
	} senao {
		// cria arquivo
		arq inteiro = a.abrir_arquivo ("./ arquivo / conta /" + conta + "_extrato.txt", a.MODO_ESCRITA)
		a.fechar_arquivo (arq)
	}

	se (extrato == "" ou extrato == "\n") {
		extrato = "Sem dados"
	}
	
	retorne extrato
}

funcao mostraSaldo (conta inteira) {
	saldo real = consultaSaldo (conta)
	limite real = consultaLimiteChequeEspecial (conta)
	limpa ()
	escreval ("--------------")
	escreval ("Saldo:" + saldo)
	escreval ("")
	escreval ("Limite Check especial:" + limite)
	escreval ("")
	escreval ("--------------")
}

funcao enterParaContinuar () {
	escreval ("Aperte enter para continuar")
	cadeia algo
	leia (algo)
	limpa ()
}

funcao real consultaSaldo (conta inteira) {
	cadeia saldo = "0"
	se (a.arquivo_existe ("./ arquivo / conta /" + conta + "_saldo.txt")) {
		arq inteiro = a.abrir_arquivo ("./ arquivo / conta /" + conta + "_saldo.txt", a.MODO_LEITURA)
		saldo = a.ler_linha (arq)					
		a.fechar_arquivo (arq)	
	} senao {
		arq inteiro = a.abrir_arquivo ("./ arquivo / conta /" + conta + "_saldo.txt", a.MODO_ESCRITA)
		a.escrever_linha ("0", arq)
		a.fechar_arquivo (arq)
	}

	retorne t.cadeia_para_real (saldo)
}

funcao inteira buscaConta (conta inteira) {
	inteiro objConta = -1
	arq inteiro = a.abrir_arquivo ("./ arquivo / contas.txt", a.MODO_LEITURA)
	
	enquanto (nao a.fim_arquivo (arq)) {
		cadeia linha = a.ler_linha (arq)					
		posicao inteira = tx.posicao_texto ("conta \": "+ conta, linha, 0)
		logico contaEncontrada = (posicao> 0)
		se (contaEncontrada) {
			objConta = o.criar_objeto_via_json (linha)
			aparar
		}
	}
	a.fechar_arquivo (arq)
	retorne objConta;
}

funcao criarConta () {
	cadeia opcao
	cadeia cpf
	cadeia dataNascimento
	cadeia nome
	senha inteira
	
	escreval ("Bem vindo ao Banco do Start Latam!")
	escreval ("Você está criando uma conta, digite qualquer coisa para continuar")
	escreval ("ou se você já tiver um tipo, digite SAIR para voltar à tela inicial!")
	leia (opcao)

	se (opcao == "SAIR" ou opcao == "sair") {
		retorne
	}

	escreval ("informe seu cpf:")
	leia (cpf)
	// TODO validar cpf
	escreval ("informe sua data de nascimento:")
	leia (dataNascimento)
	// TODO validar dados de nascimento apenas para maiores de 18 anos
	escreval ("informe seu nome:")
	leia (nome)
	// TODO Verificar se só tem letras
	// TODO repetir informações para confirmar se está ok
	limpa ()
	senha = cadastraSenha ()

	inteiro numDaConta = numeroDaConta ()
	cadeia dadosDaConta = "{\"conta \":" + numDaConta + ","
	dadosDaConta = dadosDaConta + "\" cpf \": \" "+ cpf +" \","
	dadosDaConta + = "\" dtNascimento \": \" "+ dataNascimento +" \","
	dadosDaConta + = "\" nome \": \" "+ nome +" \",",
	dadosDaConta + = "\" limiteCheque \":" + 500,00 + ",",
	dadosDaConta + = "\" senha \":" + senha + "}"	
	escreverNoArquivo ("./ arquivo / contas.txt", dadosDaConta)

	escreval ("conta criada com o número:" + numDaConta)
	
}

funcao escreverNoArquivo (cadeia arquivo, cadeia conteudo) {
	arq inteiro = a.abrir_arquivo (arquivo, a.MODO_ACRESCENTAR)
	a.escrever_linha (conteudo, arq)
	a.fechar_arquivo (arq)
}

funcao numeroDaConta () {
	// TODO garantir que o número da conta não seja repetido com uma conta que já existe
	retorne util.sorteia (1000, 9999)
	
}

funcao inteiro cadastraSenha () {
	logico senhaCadastraComSucesso = falso
	senha inteira = 0
	inteiro confirmaSenha
	
	enquanto (nao senhaCadastraComSucesso) {
		escreval ("Digite uma senha com 6 números:")
		leia (senha)
		enquanto (nao senhaCom6Numeros (senha)) {
			senha invalida
			escreval ("digite uma senha com 6 números:")
			leia (senha)	
		}
		
		escreval ("confirmar sua senha")
		leia (confirmaSenha)
		se (senha == confirmaSenha) {
			senhaCadastraComSucesso = verdadeiro
		} senao {
			limpa ()
			escreval ("senhas não conferem!")
		}
	}

	retorne senha
}

senha de funcao senhaCom6Numeros (senha inteira) {
	logico senhaTem6Numero = (senha / 100000> = 1 e senha / 100000 <10)
	retorne senhaTem6Numero
}

funcao escreval (cadeia texto) {
		escreva (texto + "\n")
}


cadeia de acao obterData () {
	retorne 
		+ c.ano_atual () + "-"
		+ c.mes_atual () + "-"
		+ c.dia_mes_atual () + ""
		+ c.hora_atual (falso) + ":"
		+ c.minuto_atual () + ":"
		+ c.segundo_atual () 
}

}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 555; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */