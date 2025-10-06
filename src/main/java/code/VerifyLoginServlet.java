package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class VerifyLoginServlet
 */@WebServlet("/VerifyLoginServlet")
 public class VerifyLoginServlet extends HttpServlet {
	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String uname = request.getParameter("uname");
	        String pass = request.getParameter("pass");

	        response.setContentType("text/html");
	        PrintWriter out = response.getWriter();

	        try (Connection con = DBConnection.getConnection()) {
	            PreparedStatement ps = con.prepareStatement(
	                "SELECT * FROM users WHERE username=? AND password=?"
	            );
	            ps.setString(1, uname);
	            ps.setString(2, pass);

	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                out.print("<span style='color:green;'>✔ Login Successful! Welcome, " + uname + "</span>");
	            } else {
	                out.print("<span style='color:red;'>❌ Invalid Username or Password</span>");
	            }
	        } catch (Exception e) {
	            out.print("Error: " + e.getMessage());
	        }
	    }
	}
