/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import model.DAO.SolicitacaoDAO;
import model.LegadoDTO;
import model.LegadoAgrupado;
import model.Usuario;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "LegadoServlet", urlPatterns = {"/LegadoServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class LegadoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null) {
            response.sendRedirect("index.html");
            return;
        }

        SolicitacaoDAO dao = new SolicitacaoDAO();
        // Busca TODOS os legados (antigos e novos) vinculados ao CPF do herdeiro
        List<LegadoDTO> listaBruta = dao.listarLegadosDoHerdeiro(usuarioLogado.getId(), usuarioLogado.getCpf());
        
        // --- LÓGICA DE AGRUPAMENTO INTELIGENTE ---
        Map<Integer, LegadoAgrupado> mapaGrupos = new HashMap<>();
        
        for (LegadoDTO item : listaBruta) {
            int idTit = item.getIdTitular();
            
            // 1. Cria ou recupera o grupo do Titular
            if (!mapaGrupos.containsKey(idTit)) {
                LegadoAgrupado grupo = new LegadoAgrupado();
                grupo.setIdTitular(idTit);
                grupo.setNomeTitular(item.getNomeTitular());
                grupo.setFotoTitularBase64(item.getFotoTitularBase64());
                // Começamos como "APROVADO" (otimista) e vamos mudando conforme encontramos itens pendentes ou bloqueados
                grupo.setStatusGeral("APROVADO"); 
                mapaGrupos.put(idTit, grupo);
            }
            
            LegadoAgrupado grupoAtual = mapaGrupos.get(idTit);
            grupoAtual.adicionarAtivo(item);
            
            // 2. Define o Status do Grupo com base na prioridade
            // Prioridade: PENDENTE > BLOQUEADO > APROVADO
            
            String stItem = item.getStatusSolicitacao(); // Status individual do item (vem do banco)
            String stGrupo = grupoAtual.getStatusGeral(); // Status atual do grupo

            if ("PENDENTE".equals(stItem)) {
                // Se tem QUALQUER item pendente, o grupo todo fica pendente (aguardando admin)
                grupoAtual.setStatusGeral("PENDENTE");
            } 
            else if ("BLOQUEADO".equals(stItem) && !"PENDENTE".equals(stGrupo)) {
                // Se achou um item BLOQUEADO (novo) e o grupo não está pendente:
                // Muda o grupo para BLOQUEADO. Isso faz o botão "Solicitar Liberação" aparecer
                // para que o usuário possa desbloquear esse novo item.
                grupoAtual.setStatusGeral("BLOQUEADO");
            }
            // Se o item for APROVADO, não fazemos nada, pois o grupo já iniciou como APROVADO.
            // Se depois aparecer um bloqueado, ele cai no 'else if' acima e muda o status corretamente.
        }
        
        List<LegadoAgrupado> listaAgrupada = new ArrayList<>(mapaGrupos.values());
        
        request.setAttribute("listaAgrupada", listaAgrupada);
        request.getRequestDispatcher("2 - ativodigital/1 - ativodigital.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuarioLogado == null) {
            response.sendRedirect("index.html");
            return;
        }
        
        try {
            // 1. Recebe o ID do Titular
            int idTitular = Integer.parseInt(request.getParameter("id_titular"));
            
            // 2. Recebe o Arquivo PDF (Certidão)
            Part filePart = request.getPart("certidao");
            byte[] certidaoBytes = null;
            
            if (filePart != null && filePart.getSize() > 0) {
                // Conversão nativa do PDF para bytes
                try (InputStream inputStream = filePart.getInputStream();
                     java.io.ByteArrayOutputStream buffer = new java.io.ByteArrayOutputStream()) {
                    
                    int nRead;
                    byte[] data = new byte[4096];
                    while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    certidaoBytes = buffer.toByteArray();
                }
            }
            
            // 3. Envia para o DAO
            SolicitacaoDAO dao = new SolicitacaoDAO();
            
            // O DAO vai identificar quais itens desse titular ainda estão bloqueados e criar solicitação APENAS para eles.
            // Os itens antigos (já aprovados) serão ignorados pela query "NOT IN".
            dao.solicitarDesbloqueioPorTitular(idTitular, usuarioLogado.getId(), certidaoBytes);
            
            // Recarrega a página
            response.sendRedirect("LegadoServlet");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("LegadoServlet?erro=upload");
        }
    }
}