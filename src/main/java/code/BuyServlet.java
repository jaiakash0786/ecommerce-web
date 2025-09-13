package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/BuyServlet")
public class BuyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                response.sendRedirect("cart.jsp?error=DB connection failed!");
                return;
            }

            con.setAutoCommit(false); // Start transaction

            PreparedStatement psUser = con.prepareStatement(
                    "SELECT id, balance FROM users WHERE username=?"
            );
            psUser.setString(1, username);
            ResultSet rsUser = psUser.executeQuery();

            int userId = 0;
            double balance = 0;
            if (rsUser.next()) {
                userId = rsUser.getInt("id");
                balance = rsUser.getDouble("balance");
            } else {
                response.sendRedirect("cart.jsp?error=User not found!");
                return;
            }

            PreparedStatement psCart = con.prepareStatement(
                    "SELECT c.id as cartId, p.id as productId, p.price, c.quantity, p.stock " +
                    "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?"
            );
            psCart.setInt(1, userId);
            ResultSet rsCart = psCart.executeQuery();

            double total = 0;
            boolean stockIssue = false;
            List<int[]> cartItems = new ArrayList<>();

            while (rsCart.next()) {
                int qty = rsCart.getInt("quantity");
                int stock = rsCart.getInt("stock");
                int productId = rsCart.getInt("productId");
                int cartId = rsCart.getInt("cartId");
                double price = rsCart.getDouble("price");

                if (qty > stock) {
                    stockIssue = true;
                    break;
                }

                total += price * qty;
                cartItems.add(new int[]{cartId, productId, qty});
            }

            if (stockIssue) {
                con.rollback();
                response.sendRedirect("cart.jsp?error=Some items exceed stock!");
                return;
            }

            if (cartItems.isEmpty()) {
                con.rollback();
                response.sendRedirect("cart.jsp?error=Cart is empty!");
                return;
            }

            if (total > balance) {
                con.rollback();
                response.sendRedirect("cart.jsp?error=Insufficient balance!");
                return;
            }

            PreparedStatement psUpdateBalance = con.prepareStatement(
                    "UPDATE users SET balance=? WHERE id=?"
            );
            psUpdateBalance.setDouble(1, balance - total);
            psUpdateBalance.setInt(2, userId);
            psUpdateBalance.executeUpdate();

            for (int[] item : cartItems) {
                int cartId = item[0];
                int productId = item[1];
                int qty = item[2];

                PreparedStatement psUpdateStock = con.prepareStatement(
                        "UPDATE products SET stock = stock - ? WHERE id=?"
                );
                psUpdateStock.setInt(1, qty);
                psUpdateStock.setInt(2, productId);
                psUpdateStock.executeUpdate();

                PreparedStatement psRemoveCart = con.prepareStatement(
                        "DELETE FROM cart WHERE id=?"
                );
                psRemoveCart.setInt(1, cartId);
                psRemoveCart.executeUpdate();
            }

            con.commit();
            response.sendRedirect("home.jsp?msg=Purchase successful! Balance left: " + (balance - total));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=Purchase failed! " + e.getMessage());
        }
    }
}
