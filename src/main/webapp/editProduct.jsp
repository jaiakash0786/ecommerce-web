<%@ page import="java.sql.*, code.DBConnection" %>
<%
    String productId = request.getParameter("id");
    String name = "";
    double price = 0;
    int stock = 0;
    String imagePath = "";

    if (productId != null) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id=?")) {
            ps.setInt(1, Integer.parseInt(productId));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                price = rs.getDouble("price");
                stock = rs.getInt("stock");
                imagePath = rs.getString("image_path");
            }
        } catch(Exception e) { e.printStackTrace(); }
    }
%>

<html>
<head>
<title>Edit Product</title>
<style>body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    margin: 0; 
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #232526, #414345);
    color: #f1f1f1;
}

.container { 
    width: 420px; 
    padding: 30px;
    background: #2b2b3c; 
    border-radius: 15px; 
    box-shadow: 0 8px 25px rgba(0,0,0,0.6); 
    animation: fadeIn 0.8s ease;
}

.container h2 {
    margin-bottom: 20px;
    color: #ffffff;
    text-align: center;
    font-size: 24px;
    letter-spacing: 1px;
}

label { 
    display: block; 
    margin-top: 15px; 
    font-weight: 600; 
    color: #ddd;
}

input[type="text"], 
input[type="number"] { 
    width: 100%; 
    padding: 12px; 
    margin-top: 8px; 
    border-radius: 8px; 
    border: 1px solid #444; 
    background: #3a3a4d; 
    color: #f1f1f1; 
    font-size: 15px;
    transition: border 0.3s ease, box-shadow 0.3s ease;
}
input:focus { 
    outline: none;
    border: 1px solid #28a745; 
    box-shadow: 0 0 6px #28a745;
}

button { 
    margin-top: 25px; 
    width: 100%; 
    padding: 12px; 
    background: linear-gradient(90deg, #28a745, #218838); 
    color: white; 
    border: none; 
    border-radius: 8px; 
    cursor: pointer; 
    font-size: 16px; 
    font-weight: 600;
    transition: transform 0.2s ease, background 0.3s ease;
}
button:hover { 
    background: linear-gradient(90deg, #218838, #1e7e34); 
    transform: scale(1.05);
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

</style>
</head>
<body>
<div class="container">
<h2>Edit Product</h2>
<form action="EditProductServlet" method="post">
    <input type="hidden" name="productId" value="<%= productId %>">
    <label>Name</label>
    <input type="text" name="name" value="<%= name %>" required>
    <label>Price</label>
    <input type="number" name="price" step="0.01" value="<%= price %>" required>
    <label>Stock</label>
    <input type="number" name="stock" value="<%= stock %>" required>
    <label>Image Path</label>
    <input type="text" name="imagePath" value="<%= imagePath %>" required>
    <button type="submit">Update Product</button>
</form>
</div>
</body>
</html>
