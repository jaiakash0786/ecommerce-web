<%@ page session="true" %>
<%@ page import="java.sql.*, code.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null) response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<title>Submit Feedback</title>
<style>
body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0; 
    background: linear-gradient(135deg, #1f1c2c, #928dab);
    color: #f1f1f1;
}


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
    color: #ff9800;  
    transform: translateY(-2px);
}


h2 { 
    text-align: center; 
    margin-top: 40px; 
    font-size: 28px;
    text-shadow: 2px 2px 5px rgba(0,0,0,0.5);
}

.feedback-card {
    background: #2b2b3c;
    width: 450px;
    margin: 30px auto 50px auto;
    padding: 30px 40px;
    border-radius: 15px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.5);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.feedback-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.7);
}

.feedback-card label {
    display: block;
    margin: 15px 0 5px 0;
    font-weight: 500;
}
.feedback-card input[type="text"],
.feedback-card input[type="number"],
.feedback-card textarea {
    width: 100%;
    padding: 10px 12px;
    border-radius: 8px;
    border: none;
    margin-bottom: 10px;
    font-size: 15px;
    background: #3a3a50;
    color: #f1f1f1;
}
.feedback-card input[type="number"]::-webkit-inner-spin-button, 
.feedback-card input[type="number"]::-webkit-outer-spin-button { 
    -webkit-appearance: none; 
    margin: 0; 
}
.feedback-card textarea { resize: none; }

.feedback-card button {
    width: 100%;
    padding: 12px;
    margin-top: 10px;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    color: #fff;
    background: linear-gradient(90deg, #ff5722, #e64a19);
    transition: transform 0.2s ease, background 0.3s ease;
}
.feedback-card button:hover {
    transform: scale(1.05);
    background: linear-gradient(90deg, #e64a19, #d84315);
}


@media (max-width: 500px) {
    .feedback-card { width: 90%; padding: 25px; }
}
</style>
</head>
<body>
<div class="navbar">
    <div>Welcome, <b><%= username %></b></div>
    <div>
        <a href="home.jsp">Home</a>
        <a href="cart.jsp">Cart</a>
        <a href="logout.jsp">Logout</a>
        <a href="feedback.jsp">Feedback</a>
    </div>
</div>

<h2>Submit Your Feedback</h2>
<div class="feedback-card">
    <form action="FeedbackServlet" method="post">
        <label>Name:</label>
        <input type="text" name="name" required>
        
        <label>Product Name:</label>
        <input type="text" name="product" required>
        
        <label>Rating (1 to 5):</label>
        <input type="number" name="rating" min="1" max="5" required>
        
        <label>Comments:</label>
        <textarea name="comments" rows="4"></textarea>
        
        <button type="submit">Submit Feedback</button>
    </form>
</div>

</body>
</html>
