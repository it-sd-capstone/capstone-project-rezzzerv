package edu.cvtc.rezzzerv;

import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/info")   // or use "/info" if you still want index.html as your homepage
public class TestServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
          throws IOException {
    resp.setContentType("text/html");
    String serverInfo = getServletContext().getServerInfo();
    resp.getWriter().printf(
            "<h1>Project: Rezzzerv</h1>" + "<h2> TestServlet live on Tomcat </h2>" +
                    "<p>Servlet container: %s</p>",
            serverInfo
    );
  }
}