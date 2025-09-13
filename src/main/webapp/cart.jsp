<%@ page import="java.sql.*" %>
<%@ page import="code.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = 0;
    double balance = 0;
    try (Connection con = DBConnection.getConnection();
         PreparedStatement psUser = con.prepareStatement("SELECT id, balance FROM users WHERE username=?")) {
        psUser.setString(1, username);
        ResultSet rsUser = psUser.executeQuery();
        if (rsUser.next()) {
            userId = rsUser.getInt("id");
            balance = rsUser.getDouble("balance");
        }
        rsUser.close();
        PreparedStatement psCart = con.prepareStatement(
            "SELECT c.id, p.name, p.price, c.quantity, (p.price * c.quantity) as total " +
            "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?"
        );
        psCart.setInt(1, userId);
        ResultSet rsCart = psCart.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Cart</title>
    <style>
        body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    margin: 0; 
    padding: 20px; 
    background: linear-gradient(135deg, #141E30, #243B55);
    color: #f1f1f1;
}

h2 { 
    text-align: center; 
    color: #ffffff; 
    font-size: 28px;
    margin-bottom: 15px;
}

.balance { 
    font-weight: bold; 
    margin-bottom: 20px; 
    text-align: center; 
    font-size: 18px; 
    color: #ffc107;
}

table { 
    width: 85%; 
    margin: auto; 
    border-collapse: collapse; 
    background: #2b2b3c; 
    box-shadow: 0 6px 20px rgba(0,0,0,0.6); 
    border-radius: 12px;
    overflow: hidden;
}

th, td { 
    padding: 14px; 
    border-bottom: 1px solid #444; 
    text-align: center; 
    font-size: 15px;
    color: #f1f1f1;
}

th { 
    background: linear-gradient(90deg, #007bff, #0056b3); 
    color: white; 
    font-size: 16px;
}

tr:nth-child(even) { 
    background: #3a3a4d; 
}

.actions button { 
    padding: 8px 14px; 
    border: none; 
    background: linear-gradient(90deg, #dc3545, #b52a37); 
    color: white; 
    cursor: pointer; 
    border-radius: 6px; 
    font-size: 14px; 
    transition: background 0.3s ease, transform 0.2s ease;
}
.actions button:hover { 
    background: linear-gradient(90deg, #b52a37, #921d29); 
    transform: scale(1.05);
}

.buy-now { 
    display: block; 
    margin: 25px auto; 
    padding: 14px 28px; 
    background: linear-gradient(90deg, #28a745, #218838); 
    color: white; 
    border: none; 
    font-size: 18px; 
    border-radius: 8px; 
    cursor: pointer; 
    font-weight: 600;
    transition: background 0.3s ease, transform 0.2s ease;
}
.buy-now:hover { 
    background: linear-gradient(90deg, #218838, #1e7e34); 
    transform: scale(1.07);
}

.grand-total { 
    text-align: center; 
    font-size: 20px; 
    margin-top: 20px; 
    font-weight: bold; 
    color: #ffc107;
}

.message { 
    text-align: center; 
    margin: 10px; 
    color: #00e676; 
    font-weight: bold; 
    font-size: 16px;
}

.error { 
    text-align: center; 
    margin: 10px; 
    color: #ff4d4d; 
    font-weight: bold; 
    font-size: 16px;
}

.top-buttons { 
    text-align: center; 
    margin-bottom: 25px; 
}

.top-buttons button { 
    padding: 10px 18px; 
    margin: 6px; 
    font-size: 14px; 
    cursor: pointer; 
    border-radius: 6px; 
    border: none; 
    font-weight: 600;
    transition: background 0.3s ease, transform 0.2s ease;
}

.home-btn { 
    background: linear-gradient(90deg, #007bff, #0056b3); 
    color: white; 
}
.home-btn:hover { 
    background: linear-gradient(90deg, #0056b3, #004099); 
    transform: scale(1.05);
}

.add-money-btn { 
    background: linear-gradient(90deg, #ffc107, #e0a800); 
    color: white; 
}
.add-money-btn:hover { 
    background: linear-gradient(90deg, #e0a800, #c69500); 
    transform: scale(1.05);
}

    </style>
</head>
<body>
    <h2>Your Cart</h2>
    <div class="balance">Balance: <%= balance %></div>

    <% 
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        if (msg != null) { %>
            <div class="message"><%= msg %></div>
    <% } else if (error != null) { %>
            <div class="error"><%= error %></div>
    <% } %>

    <!-- Top Buttons -->
    <div class="top-buttons">
        <form action="home.jsp" method="get" style="display:inline;">
            <button type="submit" class="home-btn">Go to Home</button>
        </form>
        <form action="AddMoneyServlet" method="post" style="display:inline;">
            <button type="submit" class="add-money-btn">Add Money</button>
        </form>
    </div>
    <table>
        <tr><th>Product</th><th>Price</th><th>Quantity</th><th>Total</th><th>Action</th></tr>
        <%
            double grandTotal = 0;
            while (rsCart.next()) {
                grandTotal += rsCart.getDouble("total");
        %>
        <tr>
            <td><%= rsCart.getString("name") %></td>
            <td><%= rsCart.getDouble("price") %></td>
            <td><%= rsCart.getInt("quantity") %></td>
            <td><%= rsCart.getDouble("total") %></td>
            <td class="actions">
                <form action="RemoveCartServlet" method="post">
                    <input type="hidden" name="cartId" value="<%= rsCart.getInt("id") %>">
                    <button type="submit">Remove</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <div class="grand-total">Grand Total: <%= grandTotal %></div>
    <form action="BuyServlet" method="post">
        <button type="submit" class="buy-now">Buy Now</button>
    </form>
</body>
</html>
<%
        rsCart.close();
        psCart.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("cart.jsp?error=" + e.getMessage());
    }
%>
