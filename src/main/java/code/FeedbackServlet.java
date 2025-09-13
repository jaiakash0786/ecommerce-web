package code;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
	 private static final String XML_FILE = "D:/3yr/weblab/eclipse-workspace/ecom/src/main/webapp/feedback.xml";

	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        String name = request.getParameter("name");
	        String product = request.getParameter("product");
	        String rating = request.getParameter("rating");
	        String comments = request.getParameter("comments");

	        try {
	            File xmlFile = new File(XML_FILE);
	            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
	            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
	            Document doc;

	            if (xmlFile.exists()) {
	                doc = dBuilder.parse(xmlFile);
	                doc.getDocumentElement().normalize();
	            } else {
	                // create root element
	                doc = dBuilder.newDocument();
	                Element root = doc.createElement("feedbacks");
	                doc.appendChild(root);
	            }

	            Element root = doc.getDocumentElement();
	            Element feedback = doc.createElement("feedback");

	            Element e1 = doc.createElement("name");
	            e1.appendChild(doc.createTextNode(name));
	            feedback.appendChild(e1);

	            Element e2 = doc.createElement("product");
	            e2.appendChild(doc.createTextNode(product));
	            feedback.appendChild(e2);

	            Element e3 = doc.createElement("rating");
	            e3.appendChild(doc.createTextNode(rating));
	            feedback.appendChild(e3);

	            Element e4 = doc.createElement("comments");
	            e4.appendChild(doc.createTextNode(comments));
	            feedback.appendChild(e4);

	            root.appendChild(feedback);

	            
	            TransformerFactory transformerFactory = TransformerFactory.newInstance();
	            Transformer transformer = transformerFactory.newTransformer();
	            DOMSource source = new DOMSource(doc);
	            StreamResult result = new StreamResult(xmlFile);
	            transformer.transform(source, result);

	            response.sendRedirect("home.jsp?msg=Feedback Submitted Successfully");

	        } catch (Exception e) {
	            e.printStackTrace();
	            response.getWriter().println("Error saving feedback: " + e.getMessage());
	        }
	    }
}
