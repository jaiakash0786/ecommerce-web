package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/EditProductServlet")
public class EditProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String imagePath = request.getParameter("imagePath");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                response.sendRedirect("adminHome.jsp?error=DB connection failed!");
                return;
            }

            con.setAutoCommit(false); 

            String sql = "UPDATE products SET name=?, price=?, stock=?, image_path=? WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, stock);
            ps.setString(4, imagePath);
            ps.setInt(5, productId);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                con.commit(); 
                response.sendRedirect("adminHome.jsp?msg=Product updated successfully");
            } else {
                con.rollback(); 
                response.sendRedirect("adminHome.jsp?error=Product not found or update failed");
            }

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) { ex.printStackTrace(); }

            e.printStackTrace();
            response.sendRedirect("adminHome.jsp?error=Error updating product: " + e.getMessage());

        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
