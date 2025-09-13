package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/cartServlet")
public class cartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if(username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try {
            Connection con = DBConnection.getConnection();

                 PreparedStatement ps1 = con.prepareStatement("SELECT id FROM users WHERE username=?");
            ps1.setString(1, username);
            ResultSet rsUser = ps1.executeQuery();
            int userId = 0;
            if(rsUser.next()) userId = rsUser.getInt("id");

            
            PreparedStatement psStock = con.prepareStatement("SELECT stock FROM products WHERE id=?");
            psStock.setInt(1, productId);
            ResultSet rsStock = psStock.executeQuery();
            int stock = 0;
            if(rsStock.next()) stock = rsStock.getInt("stock");

            if(stock <= 0) {
                
                response.sendRedirect("cart.jsp?error=Product out of stock!");
                return;
            }

            
            PreparedStatement ps2 = con.prepareStatement("SELECT * FROM cart WHERE user_id=? AND product_id=?");
            ps2.setInt(1, userId);
            ps2.setInt(2, productId);
            ResultSet rsCart = ps2.executeQuery();

            if(rsCart.next()) {
                int existingQty = rsCart.getInt("quantity");
                int newQty = existingQty + quantity;

                if(newQty > stock) newQty = stock; // cannot exceed stock

                PreparedStatement psUpdate = con.prepareStatement(
                        "UPDATE cart SET quantity=? WHERE user_id=? AND product_id=?"
                );
                psUpdate.setInt(1, newQty);
                psUpdate.setInt(2, userId);
                psUpdate.setInt(3, productId);
                psUpdate.executeUpdate();
            } else {
               
                if(quantity > stock) quantity = stock;

                PreparedStatement psInsert = con.prepareStatement(
                        "INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,?)"
                );
                psInsert.setInt(1, userId);
                psInsert.setInt(2, productId);
                psInsert.setInt(3, quantity);
                psInsert.executeUpdate();
            }

            response.sendRedirect("cart.jsp");
        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=Something went wrong!");
        }
    }
}
