<%-- 
    Document   : usuario
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page import="config.HashUtil"%>
<%@page import="model.Usuario"%>
<%@page import="model.DAO.UsuarioDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Processando Cadastro</title>
        <!-- Importa o CSS e fontes do seu login_cadastro.html para manter o estilo -->
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', sans-serif; }
        </style>
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
                try {
                    // 1. Instância do Objeto
                    Usuario usuario = new Usuario();

                    // 2. Entrada / Atrib. valores
                    String nome = request.getParameter("nome");
                    String cpf = request.getParameter("cpf");
                    String senha = request.getParameter("senha");
                    String palavraChave = request.getParameter("palavra_chave");

                    // 3. Validação
                    if (nome == null || cpf == null || senha == null || palavraChave == null ||
                        nome.trim().isEmpty() || cpf.trim().isEmpty() || 
                        senha.trim().isEmpty() || palavraChave.trim().isEmpty()) {
                        
                        errorMessage = "Todos os campos são obrigatórios.";
                        
                    } else {
                        
                        // 4. Criptografia (Hashing)
                        String senhaHash = HashUtil.toSHA256(senha);
                        String palavraChaveHash = HashUtil.toSHA256(palavraChave);
                        
                        // 5. Preenche o objeto model.Usuario
                        usuario.setNome(nome);
                        usuario.setCpf(cpf.replaceAll("[^0-9]", "")); // Garante apenas números
                        usuario.setSenhaHash(senhaHash);
                        usuario.setPalavraChaveHash(palavraChaveHash);

                        // 6. Salvar no Banco
                        UsuarioDAO usuarioDAO = new UsuarioDAO();
                        
                        // 7. Feedback
                        if (usuarioDAO.insertUsuario(usuario)) {
                            // SUCESSO
                            out.println("<h2 class='text-2xl font-bold text-brand-green mb-4'>Cadastro Realizado!</h2>");
                            out.println("<p class='text-gray-700'>Sua conta foi criada com sucesso.</p>");
                            out.println("<a href='../login_cadastro.html' class='mt-6 block w-full p-3 bg-brand-purple text-white rounded-lg font-bold text-center'>Ir para o Login</a>");
                        } else {
                            // ERRO (Ex: CPF Duplicado)
                            errorMessage = "Não foi possível realizar o cadastro. O CPF informado já pode existir no sistema.";
                        }
                    }

                // =================================================================
                // ATUALIZADO: Bloco catch simplificado.
                // O DAO agora trata SQLException e ClassNotFoundException internamente.
                // Este 'catch' pega qualquer outro erro (ex: NullPointerException).
                // =================================================================
                } catch (Exception e) {
                    // ERRO INESPERADO
                    errorMessage = "Erro no Servidor: " + e.getMessage();
                    e.printStackTrace(); // Loga o erro completo no console do Tomcat
                }

                // Bloco de Erro (se houver)
                if (errorMessage != null) {
                    out.println("<h2 class='text-2xl font-bold text-red-600 mb-4'>Erro ao Cadastrar</h2>");
                    out.println("<p class='text-gray-700'>" + errorMessage + "</p>");
                    out.println("<a href='../login_cadastro.html' class='mt-6 block w-full p-3 bg-brand-purple text-white rounded-lg font-bold text-center'>Tentar Novamente</a>");
                }
            %>
        </div>
    </body>
</html>