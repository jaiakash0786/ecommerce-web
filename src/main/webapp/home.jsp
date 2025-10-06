<%@ page session="true" %>
<%@ page import="java.sql.*, code.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null) response.sendRedirect("login.jsp");

    Connection con = DBConnection.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM products");
%>
<!DOCTYPE html>
<html>
<head>
<title>Home</title>
<style>
body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0; 
    background: linear-gradient(135deg, #1f1c2c, #928dab);  /* Deep purple to soft gray gradient */
    color: #f1f1f1;
}

/* Navbar */
.navbar { 
    background: linear-gradient(90deg, #141E30, #243B55); 
    padding: 15px 30px; 
    color: white; 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    box-shadow: 0 4px 10px rgba(0,0,0,0.6);
    position: sticky;
    top: 0;
    z-index: 1000;
}
.navbar a { 
    color: #f1f1f1; 
    text-decoration: none; 
    margin-left: 20px; 
    font-weight: 500;
    transition: color 0.3s ease, transform 0.2s ease;
}
.navbar a:hover { 
    color: #ff9800;   /* Orange glow hover */
    transform: translateY(-2px);
}

/* Content Grid */
.content {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    padding: 30px;
    gap: 25px;
}

/* Product Card */
.card { 
    background: #2b2b3c;   /* Dark card background */
    width: 240px; 
    border-radius: 15px; 
    box-shadow: 0 6px 20px rgba(0,0,0,0.4); 
    padding: 20px; 
    text-align: center; 
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.card:hover { 
    transform: translateY(-10px);
    box-shadow: 0 12px 30px rgba(0,0,0,0.6);
}
.card img {
    border-radius: 10px;
    margin-bottom: 15px;
    max-width: 100%;
}
.card h3 { 
    margin: 10px 0; 
    font-size: 18px; 
    color: #ffffff;
}
.card p {
    margin: 5px 0;
    color: #cfd8dc;
    font-size: 15px;
}

/* Button */
.card button { 
    padding: 10px 18px;       
    color: white; 
    background: linear-gradient(90deg, #ff5722, #e64a19); /* Bright orange gradient */
    border: none; 
    border-radius: 8px; 
    cursor: pointer; 
    font-size: 15px;          
    font-weight: 600;
    transition: background 0.3s ease, transform 0.2s ease; 
}
.card button:hover { 
    background: linear-gradient(90deg, #e64a19, #d84315);
    transform: scale(1.05);
}
.card button:disabled { 
    background: #757575;     
    cursor: not-allowed; 
    opacity: 0.8;              
}

</style>
</head>
<body>
<div class="navbar">
    <div>Welcome, <b><%= username %></b></div>
    <div>
        <a href="home.jsp">Home</a>
        <a href="addMoney.jsp">Add Money</a>
        <a href="cart.jsp">Cart</a>
        <a href="logout.jsp">Logout</a>
        <a href="feedback.jsp">Feedback</a>
        <a href="verification.jsp">Verify</a>
    </div>
</div>
<div class="content">

<%
    while(rs.next()) {
        int pid = rs.getInt("id");
        String pname = rs.getString("name");
        double price = rs.getDouble("price");
        int stock = rs.getInt("stock");
        String imagePath = rs.getString("image_path");
%>
<div class="card">
    <img src="<%=imagePath%>" width="150" height="100" alt="<%=pname%>">
    <h3><%= pname %></h3>
    <p>Price: <%= price %></p>
    <p>Stock: <%= stock %></p>
    <form action="cartServlet" method="post">
        <input type="hidden" name="productId" value="<%=pid%>">
        <input type="number" name="quantity" value="1" min="1" style="width:50px;">
        <button type="submit" <%= (stock == 0 ? "disabled" : "") %>>
            <%= (stock == 0 ? "Out of Stock" : "Add to Cart") %>
        </button>
    </form>
</div>
<% } %>
</div>
</body>
</html>
