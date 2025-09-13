<%@ page session="true" %>
<%@ page import="java.sql.*, code.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if(username == null || !"ADMIN".equals(role)) response.sendRedirect("login.jsp");

    Connection con = DBConnection.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM products");
%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>
<style>
body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    margin: 0; 
    background: linear-gradient(135deg, #141E30, #243B55); 
    color: #f1f1f1;
}

.navbar { 
    background: #1c1c1c; 
    padding: 18px; 
    color: white; 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    box-shadow: 0 4px 12px rgba(0,0,0,0.5);
}

.navbar a { 
    color: #ffc107; 
    text-decoration: none; 
    margin-left: 15px; 
    font-weight: 600;
    transition: color 0.3s ease;
}
.navbar a:hover { 
    color: #ff9800;
}

.content h2 { 
    text-align: center; 
    margin: 20px 0; 
    font-size: 26px; 
    color: #ffffff; 
    letter-spacing: 1px;
}

form input { 
    width: 95%; 
    padding: 10px; 
    margin: 10px 0; 
    border-radius: 8px; 
    border: 1px solid #444; 
    background: #3a3a4d; 
    color: #f1f1f1; 
    font-size: 14px;
    transition: border 0.3s ease, box-shadow 0.3s ease;
}
form input:focus { 
    border: 1px solid #28a745; 
    box-shadow: 0 0 6px #28a745;
    outline: none;
}

form button { 
    margin-top: 8px;
}

.button { 
    padding: 8px 14px; 
    border: none; 
    border-radius: 6px; 
    cursor: pointer; 
    font-weight: 600; 
    font-size: 14px;
    transition: transform 0.2s ease, background 0.3s ease;
}

.add { 
    background: linear-gradient(90deg, #28a745, #218838); 
    color: white;
}
.add:hover { 
    background: linear-gradient(90deg, #218838, #1e7e34); 
    transform: scale(1.05);
}

.edit { 
    background: linear-gradient(90deg, #ffc107, #e0a800); 
    color: white;
}
.edit:hover { 
    background: linear-gradient(90deg, #e0a800, #c69500); 
    transform: scale(1.05);
}

.delete { 
    background: linear-gradient(90deg, #dc3545, #b52a37); 
    color: white;
}
.delete:hover { 
    background: linear-gradient(90deg, #b52a37, #921d29); 
    transform: scale(1.05);
}

.table { 
    width: 90%; 
    margin: 25px auto; 
    border-collapse: collapse; 
    background: #2b2b3c; 
    box-shadow: 0 6px 20px rgba(0,0,0,0.6); 
    border-radius: 12px;
    overflow: hidden;
}

.table th, .table td { 
    padding: 14px; 
    text-align: center; 
    font-size: 15px;
    border-bottom: 1px solid #444;
    color: #f1f1f1;
}

.table th { 
    background: linear-gradient(90deg, #007bff, #0056b3); 
    font-size: 16px;
}

.table tr:nth-child(even) { 
    background: #3a3a4d; 
}

</style>
</head>
<body>
<div class="navbar">
    <div>Admin: <b><%=username%></b></div>
    <div><a href="logout.jsp">Logout</a></div>
    <div><a href="viewFeedback.jsp">View Feedback</a></div>
</div>

<div class="content">
<h2 style="text-align:center;">Manage Products</h2>

<!-- Add Product Form -->
<div style="width:400px; margin:20px auto; padding:10px; background:white; border-radius:10px;">
    <h3>Add New Product</h3>
    <form action="AddProductServlet" method="post">
        <input type="text" name="name" placeholder="Product Name" required><br><br>
        <input type="number" name="price" placeholder="Price" min="1" required><br><br>
        <input type="number" name="stock" placeholder="Stock" min="0" required><br><br>
        <input type="text" name="imagePath" placeholder="Image Path" required><br><br>
        <button class="button add" type="submit">Add Product</button>
    </form>
</div>

<!-- Products Table -->
<table class="table">
<tr><th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Image</th><th>Actions</th></tr>
<%
    while(rs.next()) {
        int pid = rs.getInt("id");
        String pname = rs.getString("name");
        double price = rs.getDouble("price");
        int stock = rs.getInt("stock");
        String img = rs.getString("image_path");
%>
<tr>
    <td><%= pid %></td>
    <td><%= pname %></td>
    <td><%= price %></td>
    <td><%= stock %></td>
    <td><img src="<%= img %>" width="50"></td>
    <td>
        <a href="editProduct.jsp?id=<%= pid %>"><button class="button edit">Edit</button></a>

        <form action="DeleteProductServlet" method="post" style="display:inline;">
            <input type="hidden" name="productId" value="<%=pid%>">
            <button class="button delete">Delete</button>
        </form>
    </td>
</tr>
<% } %>
</table>
</div>
</body>
</html>
