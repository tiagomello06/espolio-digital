/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import model.DAO.HerdeiroDAO;
import model.Herdeiro;
import model.Usuario; 
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HerdeiroServlet", urlPatterns = {"/HerdeiroServlet"})
public class HerdeiroServlet extends HttpServlet {

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
        HerdeiroDAO dao = new HerdeiroDAO();

        if ("excluir".equals(acao)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                dao.excluirHerdeiro(id);
                
                // MUDANÇA AQUI: Redireciona para a tela de sucesso com tipo=exclusao
                response.sendRedirect("3 - herdeiro/sucesso_herdeiro.jsp?tipo=exclusao");
                return; // Para a execução aqui para não carregar a lista abaixo
            }
        }

        // Listagem padrão
        List<Herdeiro> herdeiros = dao.listarPorUsuario(usuarioLogado.getId());
        request.setAttribute("listaHerdeiros", herdeiros);
        request.getRequestDispatcher("3 - herdeiro/1 - herdeiro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        String nome = request.getParameter("herdeiro-nome");
        String cpf = request.getParameter("herdeiro-cpf");
        String parentesco = request.getParameter("herdeiro-parentesco");

        Herdeiro h = new Herdeiro(usuarioLogado.getId(), nome, cpf, parentesco);
        HerdeiroDAO dao = new HerdeiroDAO();
        
        dao.cadastrarHerdeiro(h);

        // MUDANÇA AQUI: Redireciona para a tela de sucesso com tipo=cadastro
        response.sendRedirect("3 - herdeiro/sucesso_herdeiro.jsp?tipo=cadastro");
    }
}