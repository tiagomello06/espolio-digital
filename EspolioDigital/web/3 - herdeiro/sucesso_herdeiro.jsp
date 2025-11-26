<%-- 
    Document   : sucesso_herdeiro
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verifica o tipo de ação (cadastro ou exclusao)
    String tipo = request.getParameter("tipo");
    String titulo = "";
    String mensagem = "";
    String corBotao = "";
    
    if ("exclusao".equals(tipo)) {
        titulo = "Herdeiro Removido!";
        mensagem = "O herdeiro foi removido da sua lista com sucesso.";
        corBotao = "bg-red-600 hover:bg-red-700"; // Botão vermelho para exclusão
    } else {
        titulo = "Herdeiro Adicionado!";
        mensagem = "O novo herdeiro foi vinculado à sua conta com sucesso.";
        corBotao = "bg-brand-purple hover:bg-opacity-90"; // Botão roxo padrão
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sucesso</title>
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
        
        <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-green-100 mb-6">
            <svg class="h-10 w-10 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
        </div>

        <h2 class="text-2xl font-bold text-gray-900 mb-2"><%= titulo %></h2>
        <p class="text-gray-500 mb-8"><%= mensagem %></p>

        <a href="<%= request.getContextPath() %>/HerdeiroServlet" 
           class="block w-full py-3 px-4 rounded-lg text-white font-bold text-center transition-all shadow-md <%= corBotao %>">
            Voltar para Meus Herdeiros
        </a>
        
    </div>

</body>
</html>