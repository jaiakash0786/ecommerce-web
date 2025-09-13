<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    margin: 0; 
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #141E30, #243B55); 
}

.form-box { 
    width: 350px; 
    padding: 30px;
    background: #2b2b3c; 
    border-radius: 15px; 
    box-shadow: 0 6px 25px rgba(0,0,0,0.6); 
    text-align: center;
    color: #f1f1f1;
    animation: fadeIn 0.8s ease;
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
    outline: none;
    border: 1px solid #28a745; 
    box-shadow: 0 0 6px #28a745;
}

button { 
    width: 100%; 
    padding: 12px; 
    background: linear-gradient(90deg, #28a745, #218838); 
    color: white; 
    border: none; 
    border-radius: 8px; 
    font-size: 16px; 
    font-weight: 600;
    cursor: pointer; 
    transition: transform 0.2s ease, background 0.3s ease;
}
button:hover { 
    background: linear-gradient(90deg, #218838, #1e7e34); 
    transform: scale(1.05);
}

.form-box p { 
    margin-top: 15px; 
    font-size: 14px; 
    color: #ddd;
}
.form-box a { 
    color: #28a745; 
    text-decoration: none; 
    font-weight: 500;
}
.form-box a:hover { 
    text-decoration: underline; 
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

    </style>
</head>
<body>
    <div class="form-box">
        <h2>Register</h2>
        <form action="RegisterServlet" method="post">
            <input type="text" name="username" placeholder="Enter Username" required />
            <input type="password" name="password" placeholder="Enter Password" required />
            <button type="submit">Register</button>
        </form>
        <p>Already have an account? <a href="login.jsp">Login</a></p>
    </div>
</body>
</html>
