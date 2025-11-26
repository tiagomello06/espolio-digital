/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import model.DAO.AtivoDigitalDAO;
import model.AtivoDigital;
import model.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AtivoDigitalServlet", urlPatterns = {"/AtivoDigitalServlet"})
public class AtivoDigitalServlet extends HttpServlet {

    // MÉTODO GET: Listar OU Excluir
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null) {
            response.sendRedirect("index.html");
            return;
        }

        String acao = request.getParameter("acao");
        AtivoDigitalDAO dao = new AtivoDigitalDAO();

        // --- LÓGICA DE EXCLUSÃO ---
        if ("excluir".equals(acao)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int idAtivo = Integer.parseInt(idParam);
                
                // TODO: Seria bom verificar se esse ativo pertence mesmo ao usuário logado por segurança
                boolean excluiu = dao.excluirAtivoDigital(idAtivo); // Você precisará criar este método no DAO (veja Passo 3)
                
                if (excluiu) {
                    // REDIRECIONA PARA A NOVA TELA DE SUCESSO
                    response.sendRedirect("1 - usuario/sucesso_usuario.jsp?msg=ativoExcluido");
                    return;
                }
            }
        }
        // ---------------------------

        // Lógica padrão de listagem (usada pela tela 2 - ativodigital)
        List<AtivoDigital> lista = dao.listarAtivosDigitaisDoTitular(usuarioLogado.getId());
        request.setAttribute("listaAtivos", lista);
        request.getRequestDispatcher("2 - ativodigital/1 - ativodigital.jsp").forward(request, response);
    }

    // MÉTODO POST: Cadastrar
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
        
        if (usuarioLogado == null) {
            response.sendRedirect("index.html");
            return;
        }

        String tipo = request.getParameter("tipo-conta");
        String idHerdeiroStr = request.getParameter("herdeiro");
        
        if(idHerdeiroStr == null || idHerdeiroStr.isEmpty()) {
             // Erro de validação - redireciona para tela de erro (opcional)
             response.sendRedirect("1 - usuario/sucesso_usuario.jsp?erro=falhaCriar");
             return;
        }
        
        int idHerdeiro = Integer.parseInt(idHerdeiroStr); 

        AtivoDigital ad = new AtivoDigital();
        ad.setIdUsuarioTitular(usuarioLogado.getId());
        ad.setIdHerdeiro(idHerdeiro);
        ad.setTipoAtivoDigital(tipo);

        if ("crypto".equals(tipo)) {
            ad.setFraseRecuperacao(request.getParameter("conta-frase"));
        } else if ("mensagem".equals(tipo)) {
            ad.setMensagem(request.getParameter("conta-mensagem"));
        } else {
            ad.setLogin(request.getParameter("conta-login"));
            ad.setSenha(request.getParameter("conta-senha"));
        }

        AtivoDigitalDAO dao = new AtivoDigitalDAO();

        // Validação de Duplicidade
        if (ad.getLogin() != null && !ad.getLogin().isEmpty()) {
            if (dao.verificarDuplicidade(usuarioLogado.getId(), ad.getTipoAtivoDigital(), ad.getLogin())) {
                // REDIRECIONA PARA A NOVA TELA COM ERRO DE DUPLICIDADE
                response.sendRedirect("1 - usuario/sucesso_usuario.jsp?erro=duplicado");
                return; 
            }
        }

        boolean sucesso = dao.cadastrarAtivoDigital(ad);

        if (sucesso) {
            // REDIRECIONA PARA A NOVA TELA DE SUCESSO (CADASTRO)
            response.sendRedirect("1 - usuario/sucesso_usuario.jsp?msg=ativoCriado");
        } else {
            response.sendRedirect("1 - usuario/sucesso_usuario.jsp?erro=falhaCriar");
        }
    }
}