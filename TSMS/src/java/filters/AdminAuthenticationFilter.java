/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filters;

/**
 *
 * @author Astersa
 */
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter(filterName = "AdminAuthenticationFilter", urlPatterns = {"/sa-home"})
public class AdminAuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (httpRequest.getSession().getAttribute("adminId") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/sa-login");
        } else {
            chain.doFilter(request, response); 
        }
        
        
    }

    @Override
    public void destroy() {
        // Cleanup logic (if needed)
    }
}