/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet para processar o logout do usuário.
 * Anotação @WebServlet("/LogoutServlet") define a URL de acesso.
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Pega a sessão atual
        HttpSession session = request.getSession(false); // 'false' não cria uma nova sessão se não existir
        
        if (session != null) {
            // 2. Invalida (destrói) a sessão
            session.invalidate();
        }
        
        // 3. Redireciona o usuário de volta para a tela de login
        // Usamos 'request.getContextPath()' para garantir o caminho correto do projeto
        response.sendRedirect(request.getContextPath() + "/login_cadastro.html");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para logout de usuário";
    }
}