import java.util.Map;
import com.matrixone.apps.domain.DomainObject;
import matrix.db.Context;
import matrix.util.StringList;
import com.matrixone.apps.domain.util.MailUtil;
public class IZCheckDocumentData_mxJPO {
	
	
	public IZCheckDocumentData_mxJPO(Context context, String[] args)	throws Exception
	{

	}
	
	  public int IZCheckData(Context context ,String[] args )throws Exception
  {  
  
	   String id=args[0];
	    
	 DomainObject object = new DomainObject(id);
		 int dataReturn=0;
		 StringList busSelects = new StringList(2);
	     busSelects.add("format.file.size");
	     busSelects.add("format.file.name");
	     Map objMap=object.getInfo(context, busSelects);
	     StringList fileName = (StringList) objMap.get("format.file.name");
	     StringList fileSize = (StringList) objMap.get("format.file.size");
         String fileNameSize=fileName.get(0);
         System.out.println(fileSize);
	     System.out.println(fileName);
	     if( fileNameSize.isEmpty()) {
	    	 System.out.println("File is not present in the business object");
			 emxContextUtilBase_mxJPO.mqlNotice(context, "File is not present in the business object");
	    	 dataReturn=1;
	    	}

	     else 
	     {
	    	    String filesizeData=fileSize.get(0);
		        int filesizeinnumber=  Integer.parseInt(filesizeData);
	    		System.out.println(filesizeinnumber);
	    		
	    		if(filesizeinnumber==0)
	    		{
	    			 System.out.println("content is not present in the file");
  	   		   emxContextUtilBase_mxJPO.mqlNotice(context, "content is not present in the file");
	    			 dataReturn=1;
	    		}
	    		
	    	 
	     }
	    

          return dataReturn;
		 }

}
