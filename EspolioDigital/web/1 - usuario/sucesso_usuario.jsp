<%-- 
    Document   : 1- sucesso_usuario
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verifica o tipo de ação (ativoCriado ou ativoExcluido)
    String msg = request.getParameter("msg");
    String erro = request.getParameter("erro");
    
    String titulo = "";
    String mensagem = "";
    String corBotao = "";
    String iconeCor = "";
    
    // Lógica para definir as mensagens
    if ("ativoExcluido".equals(msg)) {
        titulo = "Conta Removida!";
        mensagem = "A conta ou ativo digital foi removido do seu painel com sucesso.";
        corBotao = "bg-red-600 hover:bg-red-700";
        iconeCor = "text-red-500";
    } else if ("ativoCriado".equals(msg)) {
        titulo = "Conta Conectada!";
        mensagem = "Novo ativo digital cadastrado e vinculado ao herdeiro com sucesso.";
        corBotao = "bg-brand-purple hover:bg-opacity-90"; 
        iconeCor = "text-green-500";
    } else if ("falhaCriar".equals(erro)) {
        titulo = "Erro ao Salvar!";
        mensagem = "Não foi possível salvar este ativo. Tente novamente.";
        corBotao = "bg-gray-600 hover:bg-gray-700";
        iconeCor = "text-gray-500";
    } else if ("duplicado".equals(erro)) {
        titulo = "Conta Duplicada!";
        mensagem = "Você já cadastrou esta conta. Não é permitido cadastrar o mesmo login duas vezes.";
        corBotao = "bg-yellow-600 hover:bg-yellow-700";
        iconeCor = "text-yellow-500";
    } else {
        // Padrão
        titulo = "Ação Concluída";
        mensagem = "Operação realizada.";
        corBotao = "bg-brand-purple";
        iconeCor = "text-green-500";
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Status da Operação</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
    <style> body { font-family: 'Inter', sans-serif; } </style>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'brand-purple-light': '#f2eefe',
                        'brand-purple': '#5b21b6',
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-brand-purple-light min-h-screen flex items-center justify-center p-4">

    <div class="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full text-center">
        
        <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 mb-6">
            <svg class="h-10 w-10 <%= iconeCor %>" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <% if ("duplicado".equals(erro) || "falhaCriar".equals(erro)) { %>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                <% } else { %>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                <% } %>
            </svg>
        </div>

        <h2 class="text-2xl font-bold text-gray-900 mb-2"><%= titulo %></h2>
        <p class="text-gray-500 mb-8"><%= mensagem %></p>

        <a href="<%= request.getContextPath() %>/1 - usuario/1 - tela geral.jsp" 
           class="block w-full py-3 px-4 rounded-lg text-white font-bold text-center transition-all shadow-md <%= corBotao %>">
            Voltar ao Dashboard
        </a>
        
    </div>

</body>
</html>