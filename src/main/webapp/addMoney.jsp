<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Money</title>
    <style>
        body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    margin: 0; 
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #232526, #414345);
    color: #f1f1f1;
}

.form-box { 
    width: 340px; 
    padding: 30px; 
    background: #2b2b3c; 
    border-radius: 15px; 
    box-shadow: 0 8px 25px rgba(0,0,0,0.6); 
    animation: fadeIn 0.8s ease;
    text-align: center;
}

.form-box h2 {
    margin-bottom: 20px;
    color: #ffffff;
    font-size: 24px;
    letter-spacing: 1px;
}

input { 
    width: 100%; 
    padding: 12px; 
    margin: 12px 0; 
    border-radius: 8px; 
    border: 1px solid #444; 
    background: #3a3a4d; 
    color: #f1f1f1; 
    font-size: 15px;
    transition: border 0.3s ease, box-shadow 0.3s ease;
}
input:focus { 
    border: 1px solid #28a745; 
    box-shadow: 0 0 6px #28a745;
    outline: none;
}

button { 
    width: 100%; 
    padding: 12px; 
    margin-top: 15px; 
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

.success { 
    color: #28a745; 
    font-size: 14px; 
    margin-bottom: 10px; 
}
.error { 
    color: #dc3545; 
    font-size: 14px; 
    margin-bottom: 10px; 
}

a { 
    display: inline-block;
    margin-top: 15px;
    text-decoration: none;
    color: #ffc107;
    font-weight: 600;
    transition: color 0.3s ease;
}
a:hover { 
    color: #ff9800;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

    </style>
</head>
<body>
    <div class="form-box">
        <h2>Add Money</h2>
        <% String msg = (String) request.getAttribute("msg"); 
           String error = (String) request.getAttribute("error"); %>

        <% if (msg != null) { %>
            <div class="success"><%= msg %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="AddMoneyServlet" method="post">
            <input type="number" name="amount" placeholder="Enter Amount" min="1" required />
            <button type="submit">Add Money</button>
        </form>

        <p><a href="home.jsp">Back to Home</a></p>
    </div>
</body>
</html>
