package filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import model.users.User;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class SessionFilter implements Filter {

    // Pages that don't require authentication
    private static final List<String> PUBLIC_PAGES = Arrays.asList(
            "/",
            "/login.jsp",
            "/register.jsp",
            "/index.jsp",
            "/contact.jsp",
            "/rooms.jsp",
            "/logout.jsp",
            "/success.jsp",
            "/css/",
            "/js/",
            "/images/",
            "/login",
            "/register",
            "/logout",
            "/check-email" // required to bypass session filtering while checking if an email is already registered

    );

    // Admin-only pages
    private static final List<String> ADMIN_PAGES = Arrays.asList(
            "/admin.jsp"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Get the requested URI and context path
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Handle the case when the URI is just the context path (root of the application)
        if (path.equals("") || path.equals("/")) {
            // Redirect to index.jsp explicitly
            httpResponse.sendRedirect(contextPath + "/index.jsp");
            return;
        }

        // Allow access to public resources
        if (isPublicResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        if (!isLoggedIn) {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?unauthorized=true");
            return;
        }

        // User is logged in, check if session has been invalidated elsewhere
        Boolean sessionInvalidated = (Boolean) session.getAttribute("sessionInvalidated");
        if (sessionInvalidated != null && sessionInvalidated) {
            // Clear session and redirect to login
            session.invalidate();
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?sessionExpired=true");
            return;
        }

        // For admin pages, check if user is admin
        if (isAdminResource(path)) {
            User user = (User) session.getAttribute("user");
            boolean isAdmin = user.getClass().getSimpleName().equals("Admin");
            if (!isAdmin) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?adminRequired=true");
                return;
            }
        }

        // All checks passed, proceed with the request
        chain.doFilter(request, response);
    }


    private boolean isPublicResource(String path) {
        return PUBLIC_PAGES.stream().anyMatch(path::startsWith);
    }

    private boolean isAdminResource(String path) {
        return ADMIN_PAGES.stream().anyMatch(path::startsWith);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
