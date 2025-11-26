<%-- 
    Document   : 1-telageral
    Created on : 22 de nov. de 2025, 11:31:04
    Author     : TIAGO KAUAN , DIEGO HENRIQUE , NICOLY MARTINELI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Usuario"%>
<%@page import="model.DAO.HerdeiroDAO"%>
<%@page import="model.DAO.AtivoDigitalDAO"%>
<%@page import="model.Herdeiro"%>
<%@page import="model.AtivoDigital"%>
<%@page import="java.util.List"%>

<%-- ======================================================================= --%>
<%-- ===== INÍCIO DO BLOCO DE SEGURANÇA E SESSÃO ===== --%>
<%-- ======================================================================= --%>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    String nomeUsuario = "Visitante"; 
    boolean temFoto = false; 
    int quantidadeHerdeiros = 0; 
    int quantidadeAtivosDigitais = 0; 
    List<Herdeiro> listaH = null; 
    List<AtivoDigital> listaAD = null;

    if (usuarioLogado == null) {
        response.sendRedirect("../login_cadastro.html?loginErro=true");
        return; 
    } else {
        nomeUsuario = usuarioLogado.getNome().split(" ")[0];
        if (usuarioLogado.getFotoPerfil() != null && usuarioLogado.getFotoPerfil().length > 0) {
            temFoto = true;
        }
        HerdeiroDAO hDao = new HerdeiroDAO();
        listaH = hDao.listarPorUsuario(usuarioLogado.getId());
        quantidadeHerdeiros = listaH.size();
        
        AtivoDigitalDAO adDao = new AtivoDigitalDAO();
        listaAD = adDao.listarAtivosDigitaisDoTitular(usuarioLogado.getId());
        quantidadeAtivosDigitais = listaAD.size();
    }
%>
<%-- ======================================================================= --%>
<%-- ===== FIM DO BLOCO DE SEGURANÇA E SESSÃO ===== --%>
<%-- ======================================================================= --%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Principal</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        @keyframes wave {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(15deg); }
            75% { transform: rotate(-15deg); }
        }
        .wave {
            display: inline-block;
            animation: wave 1s infinite;
            transform-origin: 70% 70%;
        }
    </style>
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
                <div class="flex items-center gap-4"> 
                    <% if (temFoto) { %>
                        <img src="../CarregarFotoServlet" alt="Foto de Perfil" class="w-16 h-16 rounded-full object-cover border-2 border-brand-purple">
                    <% } else { %>
                        <span class="flex items-center justify-center w-16 h-16 rounded-full bg-brand-purple-faded border-2 border-brand-purple-medium">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-brand-purple" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                            </svg>
                        </span>
                    <% } %>
                    <h1 class="text-3xl font-bold text-brand-purple-text">
                        Olá, <%= nomeUsuario %>! 
                        <span class="wave"><img src="../imagens/mao-acenando.png" alt="Mão acenando" class="inline h-8 w-8"/></span>
                    </h1>
                </div>
                <div class="flex items-center gap-3">
                    <a href="2 - tela geral.jsp" class="text-gray-400 hover:text-brand-purple transition-colors" title="Configurações">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.573-1.066z" />
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                    </a>
                    <a href="../LogoutServlet" title="Sair" class="flex items-center gap-1.5 text-gray-500 hover:text-brand-purple font-medium transition-colors p-2 rounded-lg hover:bg-brand-purple-faded">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                        </svg>
                        <span class="text-base hidden sm:inline">Sair</span>
                    </a>
                </div>
            </header>
            
            <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-white p-4 rounded-xl shadow-lg">
                    <span class="text-4xl font-bold text-brand-purple"><%= quantidadeAtivosDigitais %></span>
                    <p class="text-gray-600 font-medium">Contas Conectadas</p>
                </div>
                <div class="bg-white p-4 rounded-xl shadow-lg">
                    <span class="text-4xl font-bold text-brand-purple"><%= quantidadeHerdeiros %></span>
                    <p class="text-gray-600 font-medium">Herdeiros</p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                
                <div class="bg-white p-4 rounded-xl shadow-lg flex items-center justify-between border-l-4 border-green-500">
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase">Dólar (USD)</p>
                        <p id="cotacao-usd" class="text-lg font-bold text-gray-700">R$ --,--</p>
                    </div>
                    <div class="p-2 bg-green-100 rounded-full text-green-600">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    </div>
                </div>

                <div class="bg-white p-4 rounded-xl shadow-lg flex items-center justify-between border-l-4 border-orange-500">
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase">Bitcoin (BTC)</p>
                        <p id="cotacao-btc" class="text-lg font-bold text-gray-700">R$ --,--</p>
                    </div>
                    <div class="p-2 bg-orange-100 rounded-full text-orange-600">
                        <img src="<%= request.getContextPath() %>/imagens/ico_bitcoin.png" class="h-6 w-6" alt="BTC">
                    </div>
                </div>

                <div class="bg-white p-4 rounded-xl shadow-lg flex items-center justify-between border-l-4 border-purple-500">
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase">Ethereum (ETH)</p>
                        <p id="cotacao-eth" class="text-lg font-bold text-gray-700">R$ --,--</p>
                    </div>
                    <div class="p-2 bg-purple-100 rounded-full text-purple-600">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" /></svg>
                    </div>
                </div>

            </div>

            <script>
                // Função que consome o Web Service da AwesomeAPI
                async function buscarCotacoes() {
                    try {
                        const response = await fetch('https://economia.awesomeapi.com.br/last/USD-BRL,BTC-BRL,ETH-BRL');
                        const data = await response.json();

                        const formatarMoeda = (valor) => {
                            return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(valor);
                        };

                        if(document.getElementById('cotacao-usd'))
                            document.getElementById('cotacao-usd').innerText = formatarMoeda(data.USDBRL.bid);
                        
                        if(document.getElementById('cotacao-btc'))
                            document.getElementById('cotacao-btc').innerText = formatarMoeda(data.BTCBRL.bid);
                        
                        if(document.getElementById('cotacao-eth'))
                            document.getElementById('cotacao-eth').innerText = formatarMoeda(data.ETHBRL.bid);

                    } catch (error) {
                        console.error("Erro ao buscar cotações:", error);
                    }
                }

                document.addEventListener('DOMContentLoaded', () => {
                    buscarCotacoes();
                    setInterval(buscarCotacoes, 30000); 
                });
            </script>

            <div class="bg-white p-5 rounded-xl shadow-lg mb-6">
                <h2 class="text-xl font-bold text-brand-purple-text mb-4">Suas Contas</h2>
                
                <div class="flex flex-col space-y-3 mb-4">
                    <% 
                    if (listaAD == null || listaAD.isEmpty()) { 
                    %>
                        <p class="text-gray-400 text-sm italic">Nenhuma conta conectada ainda.</p>
                    <% 
                    } else {
                        for (AtivoDigital ad : listaAD) {
                            String tipo = ad.getTipoAtivoDigital();
                            String imgPath = ""; 
                            String nomeExibicao = tipo.substring(0, 1).toUpperCase() + tipo.substring(1); 

                            if("facebook".equals(tipo)){ imgPath = "ico_facebook.png"; } 
                            else if ("instagram".equals(tipo)){ imgPath = "ico_instagram.png"; } 
                            else if ("twitter".equals(tipo)){ imgPath = "ico_twitter.png"; } 
                            else if ("discord".equals(tipo)){ imgPath = "ico_discord.png"; } 
                            else if ("crypto".equals(tipo)){ imgPath = "ico_bitcoin.png"; nomeExibicao = "Carteira Cripto"; } 
                            else if ("mensagem".equals(tipo)){ imgPath = "ico_postuma.png"; nomeExibicao = "Mensagem Póstuma"; }
                            
                            String fullPath = request.getContextPath() + "/imagens/" + imgPath;
                    %>
                    
                    <div class="flex items-center justify-between p-3 bg-brand-purple-faded rounded-lg hover:bg-opacity-70 transition-all">
                        <div class="flex items-center gap-3">
                            <img src="<%= fullPath %>" class="w-8 h-8 object-contain" alt="<%= nomeExibicao %>">
                            <span class="font-bold text-brand-purple-text"><%= nomeExibicao %></span>
                        </div>
                        
                        <div class="flex items-center gap-3">
                            <div class="flex items-center gap-1 bg-green-100 text-brand-green px-2 py-1 rounded text-xs font-bold">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" viewBox="0 0 20 20" fill="currentColor">
                                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                                </svg>
                                Vinculado a <%= ad.getNomeHerdeiro() %>
                            </div>

                            <button type="button" onclick="openDeleteModal(<%= ad.getId() %>)" 
                               class="text-gray-400 hover:text-red-500 transition-colors flex-shrink-0" title="Excluir Conta">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                </svg>
                            </button>
                        </div>
                    </div>
                    <% 
                        } // Fim do for
                    } // Fim do else
                    %>
                </div>

                <div class="inline-flex items-center gap-1.5 bg-green-100 text-brand-green font-medium py-1 px-3 rounded-full mt-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 1.944A11.954 11.954 0 012.166 5.09.69.69 0 012.065 6.1v3.42c0 3.19 1.59 6.22 4.11 8.24.08.06.16.12.24.18a.69.69 0 00.916 0c.08-.06.16-.12.24-.18C10.06 19.34 11.4 17.5 11.4 15.52V6.1a.69.69 0 01-.1-1.01A11.954 11.954 0 0110 1.944zM10 3.7c.69 0 1.36.1 2 .29V6.1h-4V4c.64-.19 1.31-.29 2-.29zM8.6 15.52V9.52h2.8v6c0 1.29-.48 2.5-1.4 3.48-1-.98-1.4-2.19-1.4-3.48z" clip-rule="evenodd" />
                    </svg>
                    <span>Criptografadas</span>
                </div>
            </div>

            <div class="bg-brand-green text-white p-3 rounded-lg flex items-center justify-center gap-2 mb-6 text-sm font-medium shadow-lg">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944a11.954 11.954 0 007.834 3.055l-3.292 3.292a.5.5 0 01-.707 0L10 5.207l-4.546 4.547a.5.5 0 01-.707 0L2.166 4.999z" clip-rule="evenodd" />
                    <path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944a11.954 11.954 0 007.834 3.055l-3.292 3.292a.5.5 0 01-.707 0L10 14.793l4.546-4.547a.5.5 0 01.707 0l3.292 3.292A9.954 9.954 0 0110 18z" clip-rule="evenodd" />
                </svg>
                <span>Sistema seguro: AES-256 ativo | Iso 27001, 27701 ativo.</span>
            </div>

            <div class="flex flex-col space-y-3">
                <a href="<%= request.getContextPath() %>/HerdeiroServlet"
                   class="w-full p-4 bg-brand-purple-medium text-white rounded-lg font-bold text-lg hover:bg-opacity-90 transition-all flex items-center justify-center gap-2 shadow-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-2.874M17.323 14.123A3 3 0 1014.123 17.323M17 20h5v-2a3 3 0 00-5.356-2.874M9 20H4a2 2 0 01-2-2V6a2 2 0 012-2h1.172a2 2 0 001.414-.586l.828-.828A2 2 0 019.828 2h4.344a2 2 0 011.414.586l.828.828A2 2 0 0017.828 4H19a2 2 0 012 2v3.089m-11.823 6.034A3 3 0 107.123 17.323M9 20H4a2 2 0 01-2-2V6a2 2 0 012-2h1.172a2 2 0 001.414-.586l.828-.828A2 2 0 019.828 2h4.344a2 2 0 011.414.586l.828.828A2 2 0 0017.828 4H19a2 2 0 012 2v3.089" />
                    </svg>
                    Gerenciar Herdeiros
                </a>

                <button type="button" onclick="openModal()"
                    class="w-full p-4 bg-brand-purple-medium text-white rounded-lg font-bold text-lg hover:bg-opacity-90 transition-all flex items-center justify-center gap-2 shadow-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
                    </svg>
                    Conectar Nova Conta
                </button>
                
                <a href="<%= request.getContextPath() %>/LegadoServlet"
                    class="w-full p-4 bg-brand-purple text-white rounded-lg font-bold text-lg hover:bg-opacity-90 transition-all flex items-center justify-center gap-2 shadow-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                    </svg>
                    Meus Legados Recebidos
                </a>
            </div>
        </div>
    </main>

    <div id="modal-overlay" class="fixed inset-0 bg-black bg-opacity-60 hidden items-center justify-center p-4 z-40">
        <div id="modal-container" class="bg-white w-full max-w-lg rounded-2xl shadow-xl p-6 relative">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-2xl font-bold text-brand-purple-text">Conectar Nova Conta</h2>
                <button onclick="closeModal()" class="text-gray-400 hover:text-gray-700"><svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" /></svg></button>
            </div>
            <form id="form-conectar-conta" action="<%= request.getContextPath() %>/AtivoDigitalServlet" method="POST">
                <div class="space-y-4">
                    <div>
                        <label for="tipo-conta" class="block text-sm font-medium text-gray-700 mb-1">Tipo de Conta *</label>
                        <select id="tipo-conta" name="tipo-conta" required class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                            <option value="facebook">Facebook</option>
                            <option value="instagram">Instagram</option>
                            <option value="twitter">Twitter</option>
                            <option value="discord">Discord</option>
                            <option value="crypto">Carteira Cripto (Frases Chaves)</option>
                            <option value="mensagem">Mensagem Póstuma (Segredo)</option>
                        </select>
                    </div>
                    <div id="campos-padrao" class="space-y-4">
                        <div>
                            <label for="conta-login" class="block text-sm font-medium text-gray-700 mb-1">E-mail ou Usuário *</label>
                            <input type="text" name="conta-login" id="conta-login" class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                        </div>
                        <div>
                            <label for="conta-senha" class="block text-sm font-medium text-gray-700 mb-1">Senha *</label>
                            <input type="password" name="conta-senha" id="conta-senha" class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                        </div>
                    </div>
                    <div id="campo-frase-crypto" class="hidden">
                        <label for="conta-frase" class="block text-sm font-medium text-gray-700 mb-1">Palavras Chaves (Frase de Recuperação) *</label>
                        <textarea name="conta-frase" id="conta-frase" rows="4" class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple" placeholder="Digite as palavras separadas por espaço..."></textarea>
                        <p class="text-xs text-gray-500 mt-1">Seus dados são criptografados antes de serem salvos.</p>
                    </div>
                    <div id="campo-mensagem" class="hidden">
                        <label for="conta-mensagem" class="block text-sm font-medium text-gray-700 mb-1">Sua Mensagem Secreta *</label>
                        <textarea name="conta-mensagem" id="conta-mensagem" rows="6" class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 placeholder-brand-purple-medium text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple" placeholder="Escreva sua mensagem, conto ou segredo..."></textarea>
                        <p class="text-xs text-gray-500 mt-1">Esta mensagem será criptografada e entregue apenas ao herdeiro selecionado.</p>
                    </div>
                    <div>
                        <label for="herdeiro" class="block text-sm font-medium text-gray-700 mb-1">Atribuir ao Herdeiro *</label>
                        <select id="herdeiro" name="herdeiro" required class="w-full p-3 bg-brand-purple-faded rounded-lg border border-brand-purple-medium/30 text-brand-purple-text focus:outline-none focus:ring-2 focus:ring-brand-purple">
                            <option value="" disabled selected>Selecione um herdeiro...</option>
                            <% if (listaH != null) { for (Herdeiro h : listaH) { %>
                                <option value="<%= h.getId() %>"><%= h.getNome() %> (<%= h.getParentesco() != null ? h.getParentesco() : "Herdeiro" %>)</option>
                            <% } } %>
                        </select>
                    </div>
                </div>
                <div class="flex justify-end gap-3 mt-8">
                    <button type="button" onclick="closeModal()" class="p-3 px-6 bg-gray-200 text-gray-800 rounded-lg font-bold hover:bg-gray-300 transition-all">Cancelar</button>
                    <button type="submit" class="p-3 px-6 bg-brand-green text-white rounded-lg font-bold hover:bg-opacity-90 transition-all">Salvar Conta Segura</button>
                </div>
            </form>
        </div>
    </div>

    <div id="modal-delete-overlay" class="fixed inset-0 bg-black bg-opacity-60 hidden flex items-center justify-center p-4 z-50">
        <div class="bg-white w-full max-w-md rounded-2xl shadow-xl p-6 text-center">
            <div class="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-red-100 mb-6">
                <svg class="h-10 w-10 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
            </div>
            <h2 class="text-2xl font-bold text-gray-900 mb-2">Excluir Conta?</h2>
            <p class="text-gray-500 mb-8">Tem certeza que deseja remover este ativo digital? Essa ação não pode ser desfeita.</p>
            <div class="flex justify-center gap-3">
                <button onclick="closeDeleteModal()" class="px-5 py-3 bg-gray-200 text-gray-800 rounded-lg font-bold hover:bg-gray-300 transition-all">Cancelar</button>
                <a id="btn-confirmar-exclusao" href="#" class="px-5 py-3 bg-red-600 text-white rounded-lg font-bold hover:bg-red-700 transition-all shadow-md">Sim, Excluir</a>
            </div>
        </div>
    </div>

    <script>
        // --- Lógica Modal de Cadastro ---
        const modalOverlay = document.getElementById('modal-overlay');
        const tipoContaSelect = document.getElementById('tipo-conta');
        const camposPadrao = document.getElementById('campos-padrao');
        const campoFraseCrypto = document.getElementById('campo-frase-crypto');
        const campoMensagem = document.getElementById('campo-mensagem');
        const inputLogin = document.getElementById('conta-login');
        const inputSenha = document.getElementById('conta-senha');
        const inputFrase = document.getElementById('conta-frase');
        const inputMensagem = document.getElementById('conta-mensagem');

        function openModal() { modalOverlay.classList.remove('hidden'); modalOverlay.classList.add('flex'); }
        function closeModal() { modalOverlay.classList.add('hidden'); modalOverlay.classList.remove('flex'); }

        // --- Lógica Modal de Exclusão ---
        const deleteModalOverlay = document.getElementById('modal-delete-overlay');
        const deleteConfirmBtn = document.getElementById('btn-confirmar-exclusao');

        function openDeleteModal(id) {
            deleteConfirmBtn.href = "<%= request.getContextPath() %>/AtivoDigitalServlet?acao=excluir&id=" + id;
            deleteModalOverlay.classList.remove('hidden');
        }

        function closeDeleteModal() {
            deleteModalOverlay.classList.add('hidden');
        }

        // --- Alertas de URL ---
        const urlParams = new URLSearchParams(window.location.search);
        if(urlParams.has('erro') && urlParams.get('erro') === 'duplicado') {
            alert('ATENÇÃO: Esta conta já foi cadastrada para você! \nVocê não pode conectar a mesma conta duas vezes.');
        }

        tipoContaSelect.addEventListener('change', function() {
            const valor = this.value;
            camposPadrao.classList.add('hidden');
            campoFraseCrypto.classList.add('hidden');
            campoMensagem.classList.add('hidden');
            inputLogin.required = false; inputSenha.required = false; inputFrase.required = false; inputMensagem.required = false;

            if (valor === 'crypto') {
                campoFraseCrypto.classList.remove('hidden'); inputFrase.required = true;
            } else if (valor === 'mensagem') {
                campoMensagem.classList.remove('hidden'); inputMensagem.required = true;
            } else {
                camposPadrao.classList.remove('hidden'); inputLogin.required = true; inputSenha.required = true;
            }
        });

        document.addEventListener('DOMContentLoaded', () => {
            tipoContaSelect.dispatchEvent(new Event('change'));
            if (!modalOverlay.classList.contains('hidden')) { modalOverlay.classList.remove('flex'); }
        });
    </script>
</body>
</html>