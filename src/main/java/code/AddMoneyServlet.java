package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 * Servlet implementation class AddMoneyServlet
 */
@WebServlet("/AddMoneyServlet")
public class AddMoneyServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        jakarta.servlet.http.HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String amountStr = request.getParameter("amount");
        try {
            double amount = Double.parseDouble(amountStr);
            if (amount <= 0) {
                request.setAttribute("error", "Amount must be greater than 0");
            } else {
                Connection con = DBConnection.getConnection();
                
               
                PreparedStatement ps1 = con.prepareStatement("SELECT balance FROM users WHERE username=?");
                ps1.setString(1, username);
                ResultSet rs = ps1.executeQuery();
                double balance = 0;
                if (rs.next()) {
                    balance = rs.getDouble("balance");
                }
                double newBalance = balance + amount;
                PreparedStatement ps2 = con.prepareStatement("UPDATE users SET balance=? WHERE username=?");
                ps2.setDouble(1, newBalance);
                ps2.setString(2, username);
                ps2.executeUpdate();

                request.setAttribute("msg", "₹" + amount + " added successfully! New balance: ₹" + newBalance);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input");
            e.printStackTrace();
        }

        jakarta.servlet.RequestDispatcher rd = request.getRequestDispatcher("addMoney.jsp");
        rd.forward(request, response);
    }
}
