<%-- 
    Document   : 1- ativodigital
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.LegadoAgrupado"%>
<%@page import="model.LegadoDTO"%>
<%@page import="config.CryptoUtil"%>

<%
    List<LegadoAgrupado> lista = (List<LegadoAgrupado>) request.getAttribute("listaAgrupada");
    if (lista == null) {
        response.sendRedirect(request.getContextPath() + "/LegadoServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Legados Recebidos</title>
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
                        'brand-purple-text': '#4c1d95',
                        'brand-green': '#22c55e',
                        'brand-orange': '#f97316',
                        'brand-blue': '#3b82f6',
                    }
                }
            }
        }
        
        // --- CONTROLE DO MODAL ---
        function abrirModalUpload(idTitular) {
            document.getElementById('id_titular_modal').value = idTitular;
            document.getElementById('modalUpload').classList.remove('hidden');
            document.getElementById('modalUpload').classList.add('flex');
            
            // Reseta visual do input ao abrir
            resetarInputVisual();
        }

        function fecharModalUpload() {
            document.getElementById('modalUpload').classList.add('hidden');
            document.getElementById('modalUpload').classList.remove('flex');
        }

        // --- NOVO: FEEDBACK VISUAL AO SELECIONAR ARQUIVO ---
        function atualizarNomeArquivo(input) {
            const container = document.getElementById('upload-container');
            const texto = document.getElementById('texto-arquivo');
            const icone = document.getElementById('icone-upload');
            const subtexto = document.getElementById('subtexto-arquivo');

            if (input.files && input.files[0]) {
                const arquivo = input.files[0];
                
                // Muda borda para verde
                container.classList.remove('border-gray-300');
                container.classList.add('border-brand-green', 'bg-green-50');
                
                // Muda ícone e texto
                texto.innerText = "Arquivo selecionado: " + arquivo.name;
                texto.classList.add('text-brand-green');
                subtexto.innerText = "Pronto para enviar!";
                
                // Troca icone para um Check
                icone.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />';
                icone.classList.remove('text-brand-purple');
                icone.classList.add('text-brand-green');
            }
        }

        function resetarInputVisual() {
            const container = document.getElementById('upload-container');
            const texto = document.getElementById('texto-arquivo');
            const icone = document.getElementById('icone-upload');
            const subtexto = document.getElementById('subtexto-arquivo');
            const input = document.getElementById('input-file');

            input.value = ""; // Limpa o arquivo selecionado internamente
            
            container.classList.add('border-gray-300');
            container.classList.remove('border-brand-green', 'bg-green-50');
            
            texto.innerText = "Clique para selecionar o PDF";
            texto.classList.remove('text-brand-green');
            subtexto.innerText = "Apenas arquivos .pdf";
            
            icone.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />';
            icone.classList.add('text-brand-purple');
            icone.classList.remove('text-brand-green');
        }
    </script>
</head>
<body class="bg-brand-purple-light min-h-screen relative">

    <main class="flex items-start justify-center w-full p-4 py-8">
    <div class="w-full max-w-lg md:max-w-3xl mx-auto bg-transparent rounded-2xl">

        <header class="flex justify-between items-center mb-6 px-2">
            <h1 class="text-3xl font-bold text-brand-purple-text">Legados Recebidos</h1>
            <a href="<%= request.getContextPath() %>/1 - usuario/1 - tela geral.jsp" class="text-gray-400 hover:text-brand-purple transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M11 15l-3-3m0 0l3-3m-3 3h8M3 12a9 9 0 1118 0 9 9 0 01-18 0z" />
                </svg>
            </a>
        </header>

        <div class="bg-brand-blue text-white p-4 rounded-lg flex gap-3 mb-8 shadow-lg text-sm">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            <span>Envie a Certidão de Óbito uma única vez por titular para liberar todos os ativos.</span>
        </div>

        <div class="flex flex-col space-y-6">
            
            <% if (lista.isEmpty()) { %>
                <div class="text-center p-10 bg-white rounded-xl shadow text-gray-500">
                    <p>Você ainda não possui legados vinculados.</p>
                </div>
            <% } else {
                for (LegadoAgrupado grupo : lista) {
                    String status = grupo.getStatusGeral();
                    String statusCor = "text-green-600";
                    String statusTexto = "Em vida. Legado bloqueado.";
                    String bolinhaCor = "bg-green-500";
                    
                    if ("PENDENTE".equals(status)) {
                        statusCor = "text-brand-orange";
                        statusTexto = "Análise Pendente";
                        bolinhaCor = "bg-brand-orange";
                    } else if ("APROVADO".equals(status)) {
                        statusCor = "text-gray-600";
                        statusTexto = "Legado Liberado";
                        bolinhaCor = "bg-gray-600";
                    }
            %>

            <div class="bg-white p-6 rounded-xl shadow-lg flex flex-col relative overflow-hidden border border-gray-100">
                
                <div class="flex justify-between items-center mb-6 border-b border-gray-100 pb-4">
                    <div class="flex items-center gap-4">
                        <div class="relative">
                            <% if (grupo.getFotoTitularBase64() != null) { %>
                                <img src="data:image/jpeg;base64,<%= grupo.getFotoTitularBase64() %>" class="w-16 h-16 rounded-full object-cover border-2 border-brand-purple shadow-sm">
                            <% } else { %>
                                <div class="w-16 h-16 rounded-full bg-brand-purple-light flex items-center justify-center border-2 border-brand-purple">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-brand-purple" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                                </div>
                            <% } %>
                            <div class="absolute bottom-0 right-0 h-4 w-4 rounded-full <%= bolinhaCor %> ring-2 ring-white"></div>
                        </div>
                        
                        <div>
                            <h2 class="text-xl font-bold text-brand-purple-text"><%= grupo.getNomeTitular() %></h2>
                            <p class="text-sm font-medium <%= statusCor %>"><%= statusTexto %></p>
                        </div>
                    </div>
                </div>

                <div class="space-y-3 mb-6">
                    <h3 class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Ativos Digitais Recebidos:</h3>
                    
                    <% for (LegadoDTO item : grupo.getAtivos()) { 
                           String labelTipo = item.getTipoAtivo();
                           String dadosExibicao = "Conteúdo Protegido *********";
                           
                           if ("APROVADO".equals(status)) {
                               if ("crypto".equals(labelTipo)) dadosExibicao = CryptoUtil.descriptografar(item.getFraseCripto());
                               else if ("mensagem".equals(labelTipo)) dadosExibicao = CryptoUtil.descriptografar(item.getMensagemCripto());
                               else dadosExibicao = "Login: " + item.getLogin() + " | Senha: " + CryptoUtil.descriptografar(item.getSenhaCripto());
                           }
                    %>
                    <div class="bg-brand-purple-light p-3 rounded-lg border border-brand-purple/10">
                        <div class="flex items-center gap-2 mb-1">
                            <% if("facebook".equals(labelTipo)) { %> <img src="<%= request.getContextPath() %>/imagens/ico_facebook.png" class="w-5 h-5"> <% } 
                               else if("instagram".equals(labelTipo)) { %> <img src="<%= request.getContextPath() %>/imagens/ico_instagram.png" class="w-5 h-5"> <% } 
                               else if("crypto".equals(labelTipo)) { %> <img src="<%= request.getContextPath() %>/imagens/ico_bitcoin.png" class="w-5 h-5"> <% } 
                               else { %> <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-brand-purple" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" /></svg> <% } %>
                            
                            <span class="font-bold text-brand-purple capitalize text-sm"><%= labelTipo %></span>
                        </div>
                        <p class="text-gray-600 text-xs font-mono break-all pl-7"><%= dadosExibicao %></p>
                    </div>
                    <% } %>
                </div>

                <% if ("BLOQUEADO".equals(status)) { %>
                    <button onclick="abrirModalUpload('<%= grupo.getIdTitular() %>')" class="w-full py-3 bg-brand-purple text-white font-bold rounded-lg hover:bg-opacity-90 transition-all shadow flex justify-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" /></svg>
                        Solicitar Liberação (Anexar Certidão)
                    </button>
                <% } else if ("PENDENTE".equals(status)) { %>
                    <div class="flex items-center gap-2 justify-center text-brand-orange font-medium bg-orange-50 p-3 rounded-lg animate-pulse">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                        Aguardando análise da documentação...
                    </div>
                <% } %>

            </div>
            <% } } %>

        </div>
    </div>
    </main>

    <div id="modalUpload" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 items-center justify-center p-4 backdrop-blur-sm">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all scale-100">
            
            <div class="bg-brand-purple p-4 flex justify-between items-center">
                <h3 class="text-white font-bold text-lg">Enviar Certidão de Óbito</h3>
                <button onclick="fecharModalUpload()" class="text-white hover:text-gray-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                </button>
            </div>

            <div class="p-6">
                <p class="text-gray-600 mb-4 text-sm">Para liberar os ativos digitais, por favor anexe a <strong>Certidão de Óbito</strong> (formato PDF). Este documento será enviado para análise dos administradores.</p>
                
                <form action="<%= request.getContextPath() %>/LegadoServlet" method="POST" enctype="multipart/form-data" class="space-y-4">
                    
                    <input type="hidden" name="id_titular" id="id_titular_modal">
                    
                    <div id="upload-container" class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:bg-gray-50 transition-colors cursor-pointer relative">
                        <input type="file" id="input-file" name="certidao" accept="application/pdf" required 
                               class="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                               onchange="atualizarNomeArquivo(this)">
                        
                        <svg id="icone-upload" xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-brand-purple mx-auto mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" /></svg>
                        <p id="texto-arquivo" class="text-sm text-gray-500 font-medium">Clique para selecionar o PDF</p>
                        <p id="subtexto-arquivo" class="text-xs text-gray-400 mt-1">Apenas arquivos .pdf</p>
                    </div>

                    <div class="flex gap-3 mt-6">
                        <button type="button" onclick="fecharModalUpload()" class="flex-1 py-2 border border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50">Cancelar</button>
                        <button type="submit" class="flex-1 py-2 bg-brand-purple text-white rounded-lg font-bold hover:bg-brand-purple-text shadow-md">Enviar para Análise</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>