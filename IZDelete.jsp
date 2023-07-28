
<%@page import="com.matrixone.apps.common.Issue"%>
<%@page import="com.matrixone.apps.domain.DomainConstants"%>
<%@page import="com.matrixone.apps.domain.DomainObject"%>
<%@page import="com.matrixone.apps.domain.DomainRelationship"%>
<%@page import="com.matrixone.apps.common.util.FormBean"%>
<%@page import="com.matrixone.apps.domain.util.AccessUtil"%>
<%@page import="com.matrixone.apps.domain.util.ContextUtil"%>
<%@page import="com.matrixone.apps.domain.util.MapList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="matrix.util.StringList"%>

<%@include file = "../common/emxNavigatorTopErrorInclude.inc"%>
<%@include file = "emxComponentsCommonInclude.inc" %>
<%@include file = "../emxUICommonAppInclude.inc"%>
<%@include file = "../emxUICommonHeaderBeginInclude.inc"%>
<%@include file = "../components/emxComponentsTreeUtilInclude.inc" %>
<%@include file = "../common/enoviaCSRFTokenValidation.inc"%>
<jsp:useBean id="tableBean" class="com.matrixone.apps.framework.ui.UITable" scope="session"/>
<script language="Javascript" src="../common/scripts/emxUIConstants.js"></script>
<script language="Javascript" src="../common/scripts/emxUICore.js"></script>
<script language="Javascript" src="../common/scripts/emxUIUtility.js"></script>

<%
     boolean bIsError = false;
  	boolean isClassificationType=false;
  	String strTableRowId="";
    //Get the mode called
    String strMode = emxGetParameter(request, "mode");
   
    
    strMode = strMode!=null ? strMode : "";
   
    boolean isDeleteMode = strMode.equalsIgnoreCase("delete");
    boolean isDisconnectMode = strMode.equalsIgnoreCase("disconnect");
    boolean isDisconnectAssigneeMode = strMode.equalsIgnoreCase("disconnectAssignee");
    String lang = request.getHeader("Accept-Language");
    
     String appDirectory = (String)EnoviaResourceBundle.getProperty(context,"eServiceSuiteComponents.Directory");
     
    Map javaScriptHelperObjects = new HashMap(10);

 	Issue issueBean = new Issue();
 	FormBean formBean = new FormBean();
 	formBean.processForm(session, request);
    
          if (isDeleteMode) {

	      //delete Functionality
          //get the table row ids of the test case objects selected
          String[] arrTableRowIds = FrameworkUtil.getSplitTableRowIds(emxGetParameterValues(request, "emxTableRowId"));
          //get the object ids of the tablerow ids passed
          String strObjectIds[] = strObjectIds = Issue.getObjectIds(arrTableRowIds);
          // check to see if user has "delete" access on the object

          System.out.println("custom jsp :"+strObjectIds);
          boolean isPushed = false;
          
              String deleteAccessCheck = "current.access[delete]";
              StringList selects = new StringList();
              selects.add(deleteAccessCheck);
              selects.add(DomainObject.SELECT_ID);
              selects.add(DomainObject.SELECT_TYPE);
              selects.add(DomainObject.SELECT_NAME);
              selects.add(DomainObject.SELECT_REVISION);
              
              MapList issueDelAccessInfo = DomainObject.getInfo(context, strObjectIds, selects);
              Map noDeleteAccessObjectList = new HashMap();
              Map hasDeleteAccessObjectList = new HashMap();
              
              for (int i = 0; i < issueDelAccessInfo.size(); i++) {
                  Map issueDelAccess = (Map)issueDelAccessInfo.get(i);
                  String access = (String)issueDelAccess.get(deleteAccessCheck);
                  if("TRUE".equalsIgnoreCase(access)) {
                      hasDeleteAccessObjectList.put(issueDelAccess.get(DomainObject.SELECT_ID), issueDelAccess);
                  } else {
                      noDeleteAccessObjectList.put(issueDelAccess.get(DomainObject.SELECT_ID), issueDelAccess);
                  }
              }
              
              //Call the deleteObjects method of IssueBean to delete the selected object
              //Use push/pop bcz, user may not have ToDisconnect/FromDisconnect access not on the connected
              // object to the Decision
              if (hasDeleteAccessObjectList.size() > 0) {
                  ContextUtil.pushContext(context);
                  isPushed = true;
                  String[] deletedIssues = (String []) hasDeleteAccessObjectList.keySet().toArray(new String[]{});
                  javaScriptHelperObjects.put("deletedIds", deletedIssues);
				  issueBean.deleteObjects(context, deletedIssues, false);
              }
              if(noDeleteAccessObjectList.size() > 0) {
                  StringBuffer buffer = new StringBuffer(noDeleteAccessObjectList.size() * 20);
                  Iterator itr = noDeleteAccessObjectList.keySet().iterator();
                  buffer.append(i18nNow.getI18nString("emxComponents.Message.ObjectsNotDeleted", "emxComponentsStringResource", lang)).append("\n");
                  while (itr.hasNext()) {
                      String id = (String) itr.next();
                      Map map = (Map) noDeleteAccessObjectList.get(id);
                      buffer.append(map.get(DomainObject.SELECT_TYPE)).append(' ').
                      		 append(DomainObject.SELECT_NAME).append(' ').
                      		 append(DomainObject.SELECT_REVISION).append("\n");
                  }
                  throw new Exception(buffer.toString());
              }
      
  } 
  

 
%>


<%@include file = "../common/emxNavigatorBottomErrorInclude.inc"%>

<script language="javascript" type="text/javaScript">


var contentFrame = openerFindFrame(getTopWindow(),"content");

	

<framework:ifExpr expr="<%=isDeleteMode%>">

var detailsDisplay = openerFindFrame(parent.getTopWindow(), "detailsDisplay");

  contentFrame.getTopWindow().refreshTablePage();


</framework:ifExpr>


</script>

<%@include file = "../emxUICommonHeaderEndInclude.inc"%>
<%@include file = "../emxUICommonEndOfPageInclude.inc"%>
