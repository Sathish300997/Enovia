Implementing static filtering in java:
--------------------------------------

Create a Pojo class:
---------------------

package com.javatpoint.server.main.filtering;  
import com.fasterxml.jackson.annotation.JsonIgnore;  
public class SomeBean   
{  
private  String name;  
private  String phone;  
//JsonIgnore indicates that the annotated method or field is to be ignored  
@JsonIgnore  
private  String salary;  
//generating constructor  
public SomeBean(String name, String phone, String salary)   
{  
super();  
this.name = name;  
this.phone = phone;  
this.salary = salary;  
}  
public String getName()   
{  
return name;  
}  
public void setName(String name)   
{  
this.name = name;  
}  
public String getPhone()   
{  
return phone;  
}  
public void setPhone(String phone)   
{  
this.phone = phone;  
}  
public String getSalary()   
{  
return salary;  
}  
public void setSalary(String salary)   
{  
this.salary = salary;  
}  
}  

In the above class we ignore the salary datatype.


step 2:

Create a controller class for implementing the filters
-------------------------------------------------------

package com.javatpoint.server.main.filtering;  
import java.util.Arrays;  
import java.util.List;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RestController;  
@RestController  
public class FilteringController   
{  
//returning a single bean as response  
@RequestMapping("/filtering")  
public SomeBean retrieveSomeBean()  
{  
return new SomeBean("Amit", "9999999999","39000");  
}  
//returning a list of SomeBeans as response  
@RequestMapping("/filtering-list")  
public List<SomeBean> retrieveListOfSomeBeans()  
{  
return Arrays.asList(new SomeBean("Saurabh", "8888888888","20000"), new SomeBean("Devesh", "1111111111","34000"));  
}  
}  

Implementing Dynamic filtering:
--------------------------------

1)create a pojo class:


package com.javatpoint.server.main.filtering;  
import com.fasterxml.jackson.annotation.JsonFilter;  
@JsonFilter("SomeBeanFilter")  
public class SomeBean   
{  
private  String name;  
private  String phone;  
//JsonIgnore indicates that the annotated method or field is to be ignored  
//@JsonIgnore  
private  String salary;  
//generating constructor  
public SomeBean(String name, String phone, String salary)   
{  
super();      
this.name = name;  
this.phone = phone;  
this.salary = salary;  
}  
public String getName()   
{  
return name;  
}  
public void setName(String name)   
{  
this.name = name;  
}  
public String getPhone()   
{  
return phone;  
}  
public void setPhone(String phone)   
{  
this.phone = phone;  
}  
public String getSalary()   
{  
return salary;  
}  
public void setSalary(String salary)   
{  
this.salary = salary;  
}  
}  

2)
create a controller class

package com.javatpoint.server.main.filtering;  
import java.util.Arrays;  
import java.util.List;  
import org.springframework.http.converter.json.MappingJacksonValue;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RestController;  
import com.fasterxml.jackson.databind.ser.impl.SimpleBeanPropertyFilter;  
import com.fasterxml.jackson.databind.ser.impl.SimpleFilterProvider;  
import com.fasterxml.jackson.databind.ser.FilterProvider;  
@RestController  
public class FilteringController   
{  
//returning a single bean as response  
//values to send name and salary                                                              
@RequestMapping("/filtering")  
public MappingJacksonValue retrieveSomeBean()  
{  
SomeBean someBean=new SomeBean("Amit", "9999999999","39000");  
//invoking static method filterOutAllExcept()  
SimpleBeanPropertyFilter filter=SimpleBeanPropertyFilter.filterOutAllExcept("name", "salary");  
//creating filter using FilterProvider class  
FilterProvider filters=new SimpleFilterProvider().addFilter("SomeBeanFilter",filter);  
//constructor of MappingJacksonValue class  that has bean as constructor argument  
MappingJacksonValue mapping = new MappingJacksonValue(someBean);  
//configuring filters  
mapping.setFilters(filters);  
return mapping;  
}  
//returning a list of SomeBeans as response  
//values to send name and phone  
@RequestMapping("/filtering-list")  
public MappingJacksonValue retrieveListOfSomeBeans()  
{  
List<SomeBean> list=Arrays.asList(new SomeBean("Saurabh", "8888888888","20000"), new SomeBean("Devesh", "1111111111","34000"));  
//invoking static method filterOutAllExcept()  
SimpleBeanPropertyFilter filter=SimpleBeanPropertyFilter.filterOutAllExcept("name", "phone");  
FilterProvider filters=new SimpleFilterProvider().addFilter("SomeBeanFilter",filter);  
//constructor of MappingJacksonValue class that has list as constructor argument  
MappingJacksonValue mapping = new MappingJacksonValue(list);  
//configuring filter  
mapping.setFilters(filters);  
return mapping;  
}  
}  