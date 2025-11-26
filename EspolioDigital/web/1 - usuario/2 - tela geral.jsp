
<%-- 
    Document   : 2 - telageral
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page import="model.Usuario"%>
<%-- ======================================================================= --%>
<%-- ===== INÍCIO DO BLOCO DE SEGURANÇA E SESSÃO ===== --%>
<%-- ======================================================================= --%>
<%
    // 1. Tenta pegar o usuário da sessão (exatamente como no dashboard)
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    String nomeUsuario = "";
    String cpfUsuario = "";

    // 2. VERIFICAÇÃO DE SEGURANÇA:
    if (usuarioLogado == null) {
        // Se não há usuário na sessão, chuta de volta para o login
        response.sendRedirect("../login_cadastro.html?loginErro=true");
        return; // Para a execução do JSP
    } else {
        // 3. Se o usuário ESTÁ logado, pegamos os dados para pré-preencher
        nomeUsuario = usuarioLogado.getNome();
        cpfUsuario = usuarioLogado.getCpf();
    }
    
    // 4. Formata o CPF para exibição (ex: 123.456.789-00)
    if (cpfUsuario != null && cpfUsuario.length() == 11) {
        cpfUsuario = cpfUsuario.substring(0, 3) + "." + cpfUsuario.substring(3, 6) + "." +
                     cpfUsuario.substring(6, 9) + "-" + cpfUsuario.substring(9, 11);
    }
    
    // =======================================================================
    // ===== NOVO BLOCO DE FEEDBACK (PARA LER A URL) =====
    // =======================================================================
    String sucessoMsg = request.getParameter("sucesso");
    String erroMsg = request.getParameter("erro");
    // =======================================================================
    
%>
<%-- ======================================================================= --%>
<%-- ===== FIM DO BLOCO DE SEGURANÇA E SESSÃO ===== --%>
<%-- ======================================================================= --%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Perfil</title>
    <!-- Carrega o Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Carrega a fonte Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
    <style>
        /* Define a fonte Inter como padrão */
        body {
            font-family: 'Inter', sans-serif;
        }
        /* Estilo para o input de arquivo oculto */
        .file-input-hidden {
            width: 0.1px;
            height: 0.1px;
            opacity: 0;
            overflow: hidden;
            position: absolute;
            z-index: -1;
        }
    </style>
    <script>
        // Configuração customizada do Tailwind para as cores
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'brand-purple-light': '#f2eefe', // Fundo do card
                        'brand-purple': '#5b21b6',     // Roxo escuro (botões)
                        'brand-purple-medium': '#a78bfa', // Roxo médio
                        'brand-purple-faded': '#ede9fe', // Fundo do input
                        'brand-purple-text': '#4c1d95',  // Texto roxo escuro
                        'brand-green': '#22c55e',      // Botão Criar Conta (verde)
                        'brand-blue': '#3b82f6',       // Box LGPD (azul)
                    }
                }
            }
        }
    </script>
</head>
<!-- ATUALIZADO: Fundo da página agora é roxo-claro, como o dashboard -->
<body class="bg-brand-purple-light min-h-screen">

<!-- Wrapper principal para centralizar e dar padding, igual ao dashboard -->
<main class="flex items-start justify-center w-full p-4 py-8">

    <!-- Card de Edição de Perfil -->
    <div class="w-full max-w-lg md:max-w-3xl mx-auto bg-white rounded-2xl shadow-xl overflow-hidden p-6 sm:p-10">

        <!-- TELA DE EDIÇÃO -->
        <div>
            
            <!-- ======================================= -->
            <!-- ===== INÍCIO DAS MENSAGENS DE FEEDBACK ===== -->
            <!-- ======================================= -->
            <% if (sucessoMsg != null) { %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6" role="alert">
                    <strong class="font-bold">Sucesso!</strong>
                    <span class="block sm:inline">Suas alterações foram salvas.</span>
                </div>
            <% } %>
            
            <% if (erroMsg != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6" role="alert">
                    <strong class="font-bold">Erro!</strong>
                    <% if (erroMsg.equals("senhas")) { %>
                        <span class="block sm:inline">As senhas não conferem. Tente novamente.</span>
                    <% } else { %>
                         <span class="block sm:inline">Ocorreu um erro ao salvar as alterações.</span>
                    <% } %>
                </div>
            <% } %>
            <!-- ======================================= -->
            <!-- ===== FIM DAS MENSAGENS DE FEEDBACK ===== -->
            <!-- ======================================= -->

            <!-- Cabeçalho com Botão Voltar -->
            <header class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-brand-purple-text">
                    Editar Perfil
                </h1>
                <!-- ATUALIZADO: Link de 'Voltar' aponta para o dashboard .jsp -->
                <a href="1 - tela geral.jsp" class="text-gray-400 hover:text-brand-purple transition-colors" title="Voltar ao Dashboard">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </a>
            </header>

            <!-- Formulário de Edição ATUALIZADO -->
            <!-- action aponta para o novo Servlet (../ para sair da pasta '1 - usuario') -->
            <form action="../EditarPerfilServlet" method="POST" enctype="multipart/form-data" onsubmit="return validateForm(event);">
                <div class="space-y-4">
                    
                    <!-- Campo: Foto de Perfil (Editável) -->
                    <div class="flex flex-col items-center mb-4">
                        <label for="fotoPerfil" class="cursor-pointer">
                            <div id="photo-preview" class="w-32 h-32 rounded-full bg-brand-purple-faded border-2 border-dashed border-brand-purple-medium flex items-center justify-center text-center text-brand-purple-medium p-2 overflow-hidden">
                                <!-- 
                                    NOTA: Para exibir a foto ATUAL, você precisará de um servlet
                                    separado para carregar a imagem do banco.
                                    Ex: <img src="../CarregarFotoServlet?id=<%= usuarioLogado.getId() %>">
                                    Por enquanto, mostramos o placeholder.
                                -->
                                <span id="preview-text">Alterar foto de perfil</span>
                                <img id="preview-image" src="#" alt="Preview" class="w-full h-full rounded-full object-cover hidden">
                            </div>
                        </label>
                        <input type="file" name="fotoPerfil" id="fotoPerfil" accept="image/*" class="file-input-hidden">
                    </div>

                    <!-- Campo: Nome Completo (Bloqueado, vindo da SESSÃO) -->
                    <div>
                        <label for="reg-nome" class="block text-sm font-medium text-gray-700 mb-1">Nome Completo (Não editável)</label>
                        <input type="text" name="nome" id="reg-nome" value="<%= nomeUsuario %>" disabled
                            class="w-full p-4 bg-gray-200 text-gray-500 rounded-lg border border-brand-purple-medium/30 cursor-not-allowed focus:outline-none">
                    </div>
                    
                    <!-- Campo: CPF (Bloqueado, vindo da SESSÃO) -->
                    <div>
                        <label for="reg-cpf" class="block text-sm font-medium text-gray-700 mb-1">CPF (Não editável)</label>
                        <input type="text" name="cpf" id="reg-cpf" value="<%= cpfUsuario %>" disabled
                            class="w-full p-4 bg-gray-200 text-gray-500 rounded-lg border border-brand-purple-medium/30 cursor-not-allowed focus:outline-none">
                    </div>
                    
                    <hr class="border-t border-brand-purple-medium/20 my-4">

                    <!-- Campo: Nova Senha (Editável) -->
                    <div>
                        <label for="reg-senha" class="block text-sm font-medium text-brand-purple-text mb-1">Nova Senha</label>
                        <input type="password" name="senha" id="reg-senha" placeholder="Deixe em branco para não alterar"
                            class="w-full p-4 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                    </div>

                    <!-- Campo: Confirmar Nova Senha (Editável) -->
                    <div>
                        <label for="reg-confirm-senha" class="block text-sm font-medium text-brand-purple-text mb-1">Confirmar Nova Senha</label>
                        <input type="password" name="confirmar_senha" id="reg-confirm-senha" placeholder="Confirme a nova senha"
                            class="w-full p-4 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                    </div>

                    <!-- Mensagem de Erro de Senha -->
                    <p id="password-error" class="text-red-600 text-sm mt-1 hidden"></p>

                </div>

                <!-- Botões Ação -->
                <div class="space-y-3 mt-8">
                    <button type="submit"
                        class="w-full p-4 bg-brand-green text-white rounded-lg font-bold text-lg hover:bg-opacity-90 transition-all">
                        Salvar Alterações
                    </button>
                    <!-- ATUALIZADO: Link de 'Cancelar' aponta para o dashboard .jsp -->
                    <a href="1 - tela geral.jsp"
                        class="w-full p-4 bg-brand-purple-medium text-white rounded-lg font-bold text-lg hover:bg-opacity-90 transition-all text-center block">
                        Cancelar
                    </a>
                </div>
            </form>
        </div>
    </div>

</main> <!-- Fim do wrapper principal -->

    <script>
        // --- JavaScript para preview da foto de perfil ---
        const photoInput = document.getElementById('fotoPerfil');
        const previewContainer = document.getElementById('photo-preview');
        const previewImage = document.getElementById('preview-image');
        const previewText = document.getElementById('preview-text');

        photoInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    previewImage.classList.remove('hidden');
                    previewText.classList.add('hidden');
                    previewContainer.classList.remove('bg-brand-purple-faded', 'border-dashed');
                }
                
                reader.readAsDataURL(file);
            }
        });

        // --- JavaScript para validar senhas ---
        function validateForm(event) {
            const senha = document.getElementById('reg-senha').value;
            const confirmaSenha = document.getElementById('reg-confirm-senha').value;
            const errorMsg = document.getElementById('password-error');

            // Se ambos os campos de senha estiverem vazios, o usuário não quer mudar a senha.
            // Isso é válido (ele pode estar mudando só a foto).
            if (senha === '' && confirmaSenha === '') {
                errorMsg.classList.add('hidden'); 
                return true; // Permite o envio (só foto)
            }

            // Se um dos campos estiver preenchido, os dois devem ser iguais
            if (senha !== confirmaSenha) {
                event.preventDefault(); // Impede o envio
                errorMsg.innerText = 'As senhas não conferem. Tente novamente.';
                errorMsg.classList.remove('hidden'); // Mostra a mensagem de erro
                return false;
            }

            errorMsg.classList.add('hidden'); 
            return true; // Permite o envio
        }
    </script>

</body>
</html>