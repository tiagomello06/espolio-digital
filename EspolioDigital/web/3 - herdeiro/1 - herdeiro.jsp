<%-- 
    Document   : 1 - herdeiro
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Herdeiro"%>

<%
    List<Herdeiro> lista = (List<Herdeiro>) request.getAttribute("listaHerdeiros");
    if (lista == null) {
        response.sendRedirect(request.getContextPath() + "/HerdeiroServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Herdeiros</title>
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
                        'brand-purple-medium': '#a78bfa',
                        'brand-purple-faded': '#ede9fe',
                        'brand-purple-text': '#4c1d95',
                        'brand-green': '#22c55e',
                        'brand-blue': '#3b82f6',
                        'brand-orange': '#f97316',
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-brand-purple-light min-h-screen">

    <main class="flex items-start justify-center w-full p-4 py-8">
    <div class="w-full max-w-lg md:max-w-3xl mx-auto bg-transparent rounded-2xl">

        <header class="flex justify-between items-center mb-6 px-2">
            <h1 class="text-3xl font-bold text-brand-purple-text">Meus Herdeiros</h1>
            <a href="<%= request.getContextPath() %>/1 - usuario/1 - tela geral.jsp" class="text-gray-400 hover:text-brand-purple transition-colors" title="Voltar ao Dashboard">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M11 15l-3-3m0 0l3-3m-3 3h8M3 12a9 9 0 1118 0 9 9 0 01-18 0z" />
                </svg>
            </a>
        </header>

        <div class="flex flex-col space-y-4 mb-6">
            <% if (lista.isEmpty()) { %>
                <div class="text-center p-4 text-gray-500">Nenhum herdeiro cadastrado ainda.</div>
            <% } else {
                   for (Herdeiro h : lista) { %>

            <div class="bg-white p-5 rounded-xl shadow-lg flex flex-col">
                <div class="flex justify-between items-start gap-3">
                    <div class="flex items-center gap-3">
                        
                        <div class="relative">
                            <% if (h.getFotoPerfilBase64() != null && !h.getFotoPerfilBase64().isEmpty()) { %>
                                <img src="data:image/jpeg;base64,<%= h.getFotoPerfilBase64() %>" 
                                     alt="Foto de <%= h.getNome() %>"
                                     class="w-12 h-12 rounded-full object-cover border-2 border-brand-purple-faded shadow-sm">
                            <% } else { %>
                                <span class="w-12 h-12 flex items-center justify-center bg-brand-purple-faded rounded-full">
                                     <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-brand-purple" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                         <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                     </svg>
                                </span>
                            <% } %>
                            
                            <% if (h.isUsuarioCadastrado()) { %>
                                <span class="absolute bottom-0 right-0 block h-3 w-3 rounded-full ring-2 ring-white bg-green-400"></span>
                            <% } %>
                        </div>
                        <div>
                            <h2 class="text-lg font-bold text-brand-purple-text"><%= h.getNome() %></h2>
                            <p class="text-xs text-gray-400">CPF: <%= h.getCpf() %></p>
                            <% if (h.getParentesco() != null && !h.getParentesco().isEmpty()) { %>
                                <p class="text-xs text-brand-purple font-medium"><%= h.getParentesco() %></p>
                            <% } %>
                        </div>
                    </div>
                    
                    <a href="<%= request.getContextPath() %>/HerdeiroServlet?acao=excluir&id=<%= h.getId() %>" 
                       class="text-gray-400 hover:text-red-500 transition-colors flex-shrink-0" title="Excluir Herdeiro">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                    </a>
                </div>

                <div class="mt-4">
                    <% if (h.isUsuarioCadastrado()) { %>
                        <span class="inline-flex items-center gap-1.5 bg-green-100 text-brand-green font-medium py-1 px-3 rounded-full text-sm">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                            </svg>
                            Confirmado • Usuário Cadastrado
                        </span>
                    <% } else { %>
                        <span class="inline-flex items-center gap-1.5 bg-orange-100 text-brand-orange font-medium py-1 px-3 rounded-full text-sm">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.414-1.414L11 9.586V6z" clip-rule="evenodd" />
                            </svg>
                            Pendente • Usuário não cadastrado
                        </span>
                    <% } %>
                </div>
            </div>
            <% } } %> </div>

        <button type="button" onclick="openModal()"
            class="w-full p-4 bg-brand-purple text-white rounded-lg font-bold text-lg hover:bg-opacity-90 transition-all flex items-center justify-center gap-2 shadow-lg mb-6">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
            </svg>
            Adicionar Novo Herdeiro
        </button>

        <div class="bg-brand-blue text-white p-3 rounded-lg flex items-center justify-center gap-2 text-sm font-medium shadow-lg">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 1.944A11.954 11.954 0 012.166 5.09.69.69 0 012.065 6.1v3.42c0 3.19 1.59 6.22 4.11 8.24.08.06.16.12.24.18a.69.69 0 00.916 0c.08-.06.16-.12.24-.18C10.06 19.34 11.4 17.5 11.4 15.52V6.1a.69.69 0 01-.1-1.01A11.954 11.954 0 0110 1.944zM10 3.7c.69 0 1.36.1 2 .29V6.1h-4V4c.64-.19 1.31-.29 2-.29zM8.6 15.52V9.52h2.8v6c0 1.29-.48 2.5-1.4 3.48-1-.98-1.4-2.19-1.4-3.48z" clip-rule="evenodd" />
            </svg>
            <span>CPF será usado para vincular a conta do herdeiro.</span>
        </div>
    </div>
    </main>

    <div id="modal-overlay" class="fixed inset-0 bg-black bg-opacity-60 hidden flex items-center justify-center p-4 z-50">
        <div id="modal-container" class="bg-white w-full max-w-lg rounded-2xl shadow-xl p-6 relative">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-brand-purple-text">Adicionar Herdeiro</h2>
                <button onclick="closeModal()" class="text-gray-400 hover:text-gray-700">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <form action="<%= request.getContextPath() %>/HerdeiroServlet" method="POST">
                <div class="space-y-4">
                    <div>
                        <label for="herdeiro-nome" class="block text-sm font-medium text-gray-700 mb-1">Nome do Herdeiro *</label>
                        <input type="text" name="herdeiro-nome" id="herdeiro-nome" required
                            class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                    </div>
                    
                    <div>
                        <label for="herdeiro-cpf" class="block text-sm font-medium text-gray-700 mb-1">CPF do Herdeiro *</label>
                        <input type="text" name="herdeiro-cpf" id="herdeiro-cpf" placeholder="Apenas números (11 dígitos)" required
                            maxlength="11" 
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                            class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                    </div>
                    
                    <div>
                        <label for="herdeiro-parentesco" class="block text-sm font-medium text-gray-700 mb-1">Parentesco (opcional)</label>
                        <input type="text" name="herdeiro-parentesco" id="herdeiro-parentesco" placeholder="Ex: Mãe, Irmão, etc."
                            class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                    </div>
                </div>

                <div class="bg-brand-blue text-white p-3 rounded-lg flex items-start gap-3 my-6 text-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                    </svg>
                    <span><strong>Notificação:</strong> Se o CPF informado já possuir cadastro, o usuário será notificado no aplicativo.</span>
                </div>

                <div class="flex justify-end gap-3 mt-8">
                    <button type="button" onclick="closeModal()" class="p-3 px-6 bg-gray-200 text-gray-800 rounded-lg font-bold hover:bg-gray-300 transition-all">Cancelar</button>
                    <button type="submit" class="p-3 px-6 bg-brand-green text-white rounded-lg font-bold hover:bg-opacity-90 transition-all">Adicionar Herdeiro</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const modalOverlay = document.getElementById('modal-overlay');
        function openModal() {
            modalOverlay.classList.remove('hidden');
            modalOverlay.classList.add('flex');
        }
        function closeModal() {
            modalOverlay.classList.add('hidden');
            modalOverlay.classList.remove('flex');
        }
    </script>

</body>
</html>