<%@page import="com.matrixone.apps.common.Issue"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.domain.util.MapList"%>
<%@page import="java.util.*"%>
<%@page import="matrix.util.StringList"%>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@page import="com.matrixone.apps.domain.*"%>

<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="java.io.FileOutputStream"%>

<%@page import="java.text.SimpleDateFormat"%>





<%
   String strMode = emxGetParameter(request, "mode");
   strMode = strMode!=null ? strMode : "";
   boolean pdfgenerate = strMode.equalsIgnoreCase("izpdf");
  
     
          if (pdfgenerate) {

          String[] arrTableRowIds = FrameworkUtil.getSplitTableRowIds(emxGetParameterValues(request, "emxTableRowId"));
		  
		  System.out.println(" arrTableRowIds "+arrTableRowIds);
          String strObjectIds[] = strObjectIds = Issue.getObjectIds(arrTableRowIds);
		 
              StringList selects = new StringList();
              selects.add(DomainObject.SELECT_ID);
              MapList oid = DomainObject.getInfo(context, strObjectIds, selects);
              ArrayList obj1=new ArrayList();
			  ArrayList obj=new ArrayList();
	         Date timestamp = new Date();
             String type=null;
              SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
             String formattedTime = dateFormat.format(timestamp);
			 
			    for (int i = 0; i < oid.size(); i++) {
			    Map oidmap = (Map)oid.get(i);
              	 String objectid = (String)oidmap.get(DomainObject.SELECT_ID);
                  obj1.add(objectid);
				  
				  
			   }
			   
			    for (int i = 0; i < obj1.size(); i++) {
		          String objectIDA= (String) obj1.get(i);
	              System.out.println(objectIDA);
		          DomainObject getDetails=new DomainObject(objectIDA);
	               type= getDetails.getType(context);
	              String name= getDetails.getName(context);
				  System.out.println(type);
				  System.out.println(name);
				  obj.add("Type:"+type+" Name:"+name+" ObjectId:"+objectIDA);
				  
	          	
	        }                                            
			
			 Document document = new Document();
      PdfWriter.getInstance(document, new FileOutputStream("D:/IZpdfOutput/IZdemo"+type+".pdf"));
      document.open();

      for (int i = 0; i < obj.size(); i++) {
    	  String demo=(String) obj.get(i);
    	  document.add(new Paragraph(demo));
	}
      
  		 document.add(new Paragraph(formattedTime));
     
      document.close();
			    
			
                   
	                
  }


  
  

 
%>



