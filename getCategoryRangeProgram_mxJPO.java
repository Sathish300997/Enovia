

import java.util.HashMap;


import com.matrixone.apps.domain.util.FrameworkUtil;
import com.matrixone.apps.domain.util.PropertyUtil;

import matrix.db.Context;
import matrix.util.StringList;

public class getCategoryRangeProgram_mxJPO {
	
	public HashMap getCategoryRange(Context context, String args[])throws Exception {
        HashMap returnMap = new HashMap();
        try
        {
            String strRFQTypeAttr  = PropertyUtil.getSchemaProperty(context,"attribute_category");
            StringList strAttrRanges = FrameworkUtil.getRanges(context, strRFQTypeAttr);
            returnMap.put("field_choices", strAttrRanges);
            returnMap.put("field_display_choices", strAttrRanges);
        }
        catch(Exception e) {
            throw e;
        }
        return returnMap;
    }



}
