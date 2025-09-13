package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RemoveCartServlet")
public class RemoveCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));

            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM cart WHERE id=?");
            ps.setInt(1, cartId);
            int deleted = ps.executeUpdate();

            if(deleted > 0) {
                response.sendRedirect("cart.jsp?msg=Item removed successfully");
            } else {
                response.sendRedirect("cart.jsp?error=Failed to remove item");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=Error removing item");
        }
    }
}
