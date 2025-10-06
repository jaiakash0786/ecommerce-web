<!DOCTYPE html>
<html>
<head>
<title>Verification Page</title>
<style>
body { 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    margin: 0; 
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #1f1c2c, #928dab);  
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
    border: 1px solid #ff9800; 
    box-shadow: 0 0 6px #ff9800;
}

button { 
    width: 100%; 
    padding: 12px; 
    background: linear-gradient(90deg, #ff5722, #e64a19); 
    color: white; 
    border: none; 
    border-radius: 8px; 
    font-size: 16px; 
    font-weight: 600;
    cursor: pointer; 
    transition: transform 0.2s ease, background 0.3s ease;
}
button:hover { 
    background: linear-gradient(90deg, #e64a19, #d84315); 
    transform: scale(1.05);
}

#status { 
    margin-top: 15px; 
    font-size: 14px; 
    font-weight: 500; 
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>

<script>
function verifyLogin() {
    var uname = document.getElementById("uname").value;
    var pass = document.getElementById("pass").value;
    if (uname.length == 0 || pass.length == 0) {
        document.getElementById("status").innerHTML = "⚠ Please enter username and password.";
        document.getElementById("status").style.color = "yellow";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "VerifyLoginServlet", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("status").innerHTML = xhr.responseText;
        }
    };
    xhr.send("uname=" + encodeURIComponent(uname) + "&pass=" + encodeURIComponent(pass));
}
</script>
</head>
<body>
    <div class="form-box">
        <h2>AJAX User Verification</h2>
        <form onsubmit="return false;">
            <input type="text" id="uname" placeholder="Enter Username" />
            <input type="password" id="pass" placeholder="Enter Password" />
            <button type="button" onclick="verifyLogin()">Verify</button>
        </form>
        <div id="status"></div>
    </div>
</body>
</html>
