<%-- 
    Document   : recuperar_senha
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page import="config.HashUtil"%>
<%@page import="model.DAO.UsuarioDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Processando Recuperação</title>
        <!-- Importa o CSS e fontes para manter o estilo -->
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
        <style> body { font-family: 'Inter', sans-serif; } </style>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            'brand-purple-light': '#f2eefe', 'brand-purple': '#5b21b6',
                            'brand-purple-medium': '#a78bfa', 'brand-purple-faded': '#ede9fe',
                            'brand-purple-text': '#4c1d95', 'brand-green': '#22c55e', 'brand-blue': '#3b82f6',
                        }
                    }
                }
            }
        </script>
    </head>
    <body class="bg-brand-purple-light flex items-center justify-center min-h-screen p-4">
        
        <div class="w-full max-w-md mx-auto bg-white p-8 rounded-2xl shadow-xl text-center">
            <%
                String errorMessage = null;
                boolean sucesso = false;

                try {
                    // 1. Obter os dados do formulário
                    String cpf = request.getParameter("cpf");
                    String palavraChave = request.getParameter("palavra_chave");
                    String novaSenha = request.getParameter("senha_nova");
                    String confirmaSenha = request.getParameter("confirmar_senha_nova");

                    // 2. Validação dos campos
                    if (cpf == null || palavraChave == null || novaSenha == null || confirmaSenha == null ||
                        cpf.trim().isEmpty() || palavraChave.trim().isEmpty() || 
                        novaSenha.trim().isEmpty() || confirmaSenha.trim().isEmpty()) {
                        
                        errorMessage = "Todos os campos são obrigatórios.";
                        
                    } else if (!novaSenha.equals(confirmaSenha)) {
                        // Validação (extra) se as senhas não batem (o JS já deve ter feito isso)
                        errorMessage = "As novas senhas não conferem. Tente novamente.";
                    
                    } else {
                        
                        // 3. Criptografar (Hash) os dados
                        String cpfLimpo = cpf.replaceAll("[^0-9]", "");
                        String palavraChaveHash = HashUtil.toSHA256(palavraChave);
                        String novaSenhaHash = HashUtil.toSHA256(novaSenha);
                        
                        // 4. Chamar o DAO para a operação atômica
                        UsuarioDAO usuarioDAO = new UsuarioDAO();
                        sucesso = usuarioDAO.redefinirSenha(cpfLimpo, palavraChaveHash, novaSenhaHash);

                        if (!sucesso) {
                            errorMessage = "CPF ou Palavra-Chave de Recuperação estão incorretos.";
                        }
                    }

                } catch (Exception e) {
                    errorMessage = "Erro no Servidor: " + e.getMessage();
                    e.printStackTrace(); // Loga o erro completo no console do Tomcat
                }

                // 5. Mostrar o feedback para o usuário
                if (sucesso) {
                    // SUCESSO (Parecido com a tela de "Cadastro Realizado")
                    out.println("<h2 class='text-2xl font-bold text-brand-green mb-4'>Senha Redefinida!</h2>");
                    out.println("<p class='text-gray-700'>Sua senha foi alterada com sucesso.</p>");
                    out.println("<a href='../login_cadastro.html' class='mt-6 block w-full p-3 bg-brand-purple text-white rounded-lg font-bold text-center'>Ir para o Login</a>");
                } else {
                    // ERRO
                    out.println("<h2 class='text-2xl font-bold text-red-600 mb-4'>Erro ao Redefinir</h2>");
                    out.println("<p class='text-gray-700'>" + (errorMessage != null ? errorMessage : "Erro desconhecido.") + "</p>");
                    out.println("<a href='../login_cadastro.html' onclick='history.back(); return false;' class='mt-6 block w-full p-3 bg-brand-purple text-white rounded-lg font-bold text-center'>Tentar Novamente</a>");
                }
            %>
        </div>
    </body>
</html>