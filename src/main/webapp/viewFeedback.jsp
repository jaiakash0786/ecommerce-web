<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,java.io.File,java.util.*,javax.xml.xpath.*" %>
<%
    String xmlPath = "D:/3yr/weblab/eclipse-workspace/ecom/src/main/webapp/feedback.xml"; 
    File xmlFile = new File(xmlPath);
    if (!xmlFile.exists()) {
        out.println("<h3>No feedback submitted yet.</h3>");
        return;
    }
    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
    Document doc = dBuilder.parse(xmlFile);
    doc.getDocumentElement().normalize();
    String filter = request.getParameter("filter");
    if (filter == null) filter = "all";
    String productQuery = request.getParameter("product");
    XPathFactory xpf = XPathFactory.newInstance();
    XPath xpath = xpf.newXPath();
    NodeList list;
    String xpathExpr = "/feedbacks/feedback";
    List<String> conditions = new ArrayList<>();
    switch(filter) {
        case "high": conditions.add("rating>=4"); break;
        case "medium": conditions.add("rating=3"); break;
        case "low": conditions.add("rating<3"); break;
        case "greater3": conditions.add("rating>3"); break;
    }
    if (productQuery != null && !productQuery.trim().isEmpty()) {
        conditions.add("contains(product,'" + productQuery.trim() + "')");
    }
    if (!conditions.isEmpty()) {
        xpathExpr += "[" + String.join(" and ", conditions) + "]";
    }
    list = (NodeList) xpath.evaluate(xpathExpr, doc, XPathConstants.NODESET);
    class Fb {
        String name, product, comments;
        int rating;
        String category;
    }
    List<Fb> feedbacks = new ArrayList<>();
    for (int i = 0; i < list.getLength(); i++) {
        Element fb = (Element) list.item(i);
        Fb f = new Fb();
        f.name = fb.getElementsByTagName("name").item(0).getTextContent();
        f.product = fb.getElementsByTagName("product").item(0).getTextContent();
        f.rating = Integer.parseInt(fb.getElementsByTagName("rating").item(0).getTextContent());
        f.comments = fb.getElementsByTagName("comments").item(0).getTextContent();

        if (f.rating >= 4) f.category = "High";
        else if (f.rating == 3) f.category = "Medium";
        else f.category = "Low";

        feedbacks.add(f);
    }
    feedbacks.sort((a,b)->b.rating - a.rating);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Feedback</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1f1c2c, #928dab);
            color: #f1f1f1;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 28px;
            text-shadow: 2px 2px 5px rgba(0,0,0,0.5);
        }

        h3 {
            margin-top: 30px;
            margin-bottom: 10px;
            text-align: center;
            font-size: 22px;
        }

        /* Form */
        form {
            text-align: center;
            margin-bottom: 30px;
        }
        form select, form input[type="text"] {
            padding: 8px 12px;
            margin: 5px 10px;
            border-radius: 8px;
            border: none;
            background: #3a3a50;
            color: #f1f1f1;
            font-size: 15px;
        }
        form input[type="submit"] {
            padding: 10px 18px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(90deg, #ff5722, #e64a19);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, background 0.3s ease;
        }
        form input[type="submit"]:hover {
            background: linear-gradient(90deg, #e64a19, #d84315);
            transform: scale(1.05);
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #2b2b3c;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.5);
        }

        table th, table td {
            padding: 15px 12px;
            text-align: center;
        }

        table th {
            background: linear-gradient(90deg, #141E30, #243B55);
            font-size: 16px;
        }

        table td {
            border-bottom: 1px solid #444;
            font-size: 15px;
        }

        table tr:hover td {
            background: #3a3a50;
        }

        /* Back Link */
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            padding: 10px 18px;
            background: linear-gradient(90deg, #ff5722, #e64a19);
            color: #fff;
            font-weight: 600;
            border-radius: 10px;
            transition: transform 0.2s ease, background 0.3s ease;
        }
        a:hover {
            transform: scale(1.05);
            background: linear-gradient(90deg, #e64a19, #d84315);
        }

        /* Responsive */
        @media (max-width: 768px) {
            table th, table td {
                padding: 12px 6px;
                font-size: 14px;
            }
            form select, form input[type="text"] {
                width: 90%;
                margin: 5px 0;
            }
            form input[type="submit"] {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <h2>Customer Feedback</h2>

    <!-- Filter & Search Form -->
    <h3>View Options</h3>
    <form method="get">
        <label>Filter by rating:</label>
        <select name="filter">
            <option value="all" <%= "all".equals(filter) ? "selected" : "" %>>All Feedback</option>
            <option value="high" <%= "high".equals(filter) ? "selected" : "" %>>High Ratings (>=4)</option>
            <option value="medium" <%= "medium".equals(filter) ? "selected" : "" %>>Medium Ratings (=3)</option>
            <option value="low" <%= "low".equals(filter) ? "selected" : "" %>>Low Ratings (<3)</option>
            <option value="greater3" <%= "greater3".equals(filter) ? "selected" : "" %>>Rating > 3</option>
        </select>

        <label>Search by product:</label>
        <input type="text" name="product" value="<%= productQuery != null ? productQuery : "" %>">

        <input type="submit" value="Apply Filter">
    </form>

    <!-- Feedback Table -->
    <table>
        <tr>
            <th>Name</th>
            <th>Product</th>
            <th>Rating</th>
            <th>Comments</th>
            <th>Category</th>
        </tr>
        <%
            for (Fb f : feedbacks) {
        %>
        <tr>
            <td><%= f.name %></td>
            <td><%= f.product %></td>
            <td><%= f.rating %></td>
            <td><%= f.comments %></td>
            <td><%= f.category %></td>
        </tr>
        <% } %>
    </table>
    <a href="adminHome.jsp">Admin Home</a>
</body>
</html>
