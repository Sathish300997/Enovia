
 1) int a[]={1,3,4};
     long count=   Arrays.stream(a).count();  --->returns the length of an array
-------------------------------------------------------------------------------------------	 
	 
2)	 int a[]={100,50,30,10};
       Arrays.stream(a).sorted().forEach((x)->{           -->for ascending order sorting
          System.out.println(x);
     });
-----------------------------------------------------------------------------------------------	 
	 
3)	  int a[]={100,50,30,10};
       Arrays.stream(a).boxed().sorted(Comparator.reverseOrder()).forEach((x)->{
          System.out.println(x);                                                         -->for descending order sorting
     });                                                                                     
	 
	In collections object use Collections.reverseOrder()
----------------------------------------------------------------------------------------------------	
	
4)	 int a[]={100,50,30,10}; 
     int val=  Arrays.stream(a).sum();          --->returns the sum of array
    System.out.println(val);
	
-------------------------------------------------------------------------------------------------------	
5)	   int a[]={100,50,30,10};
     OptionalDouble val=  Arrays.stream(a).average(); -->return the average of array
    System.out.println(val);
	
---------------------------------------------------------------------------------------------------------------
	
6)	 int a[]={100,56,37,10};
       Arrays.stream(a).filter(x->x%2==0).forEach(x->System.out.println(x));   -->for filtering the logic
	   
--------------------------------------------------------------------------------------------------------------	   
7)	      int a[]={100,56,37,10};
    int min=   Arrays.stream(a).min().getAsInt();   ---->return the min value of an array
    System.out.println(min);
	
---------------------------------------------------------------------------------------------------------------------	
8)	      int a[]={100,56,37,10};
    int min=   Arrays.stream(a).max().getAsInt();   ---->return the max value of an array
    System.out.println(min);
----------------------------------------------------------------------------------------------------------------------
9)	 List<Integer> l=new ArrayList();
        l.add(1);
        l.add(2);
        l.add(3);
         l.add(4);
        l.add(5);
 Optional m=   l.stream().max((v1,v2)->v1.compareTo(v2));   --------------> return the max value of a given collection object
 System.out.println(m.get());
-------------------------------------------------------------------------------------------------------------------------	
10)	   int a[]={100,56,37,10,100,10};
      Arrays.stream(a).distinct().forEach(x->System.out.println(x));  ---->it remove the duplicate value
----------------------------------------------------------------------------------------------------------------------	  
	  
11)	  stream is divided into two types:
	  
	   a) sequential stream - by using Arrays.stream() or Collections.stream()
	   b) parallel stream
	To check which stream is used:
	    isParallel() ->returns true or false
		 false -> stream is   int a[]={100,56,37,10,100,10};
   boolean b=   Arrays.stream(a).isParallel();
    System.out.println(b);
		 true ->stream is parallel
		 
		                 Sequential stream
						 ------------------
		   int a[]={100,56,37,10,100,10};
   boolean b=   Arrays.stream(a).isParallel();  --->returns false
    System.out.println(b);
		 
		          Parallel Stream
				  -----------------
		 int a[]={100,56,37,10,100,10};
   boolean b=   Arrays.stream(a).parallel().isParallel();   ---->returns true
    System.out.println(b);
----------------------------------------------------------------------------------------------------------------------------	
	
12)	map:
	----
	
	   int a[]={2,2};
  long b=  Arrays.stream(a).mapToLong(x->(x*x)).sum();  ---> it returns the square of given number and sum
    System.out.println(b);

Note:
For Collection Object we must mention Generic. For Example: ArrayList<Integer> sb=new ArrayList<Integer>();
If you not mention Generic means.It throws an error.
------------------------------------------------------------------------------------------------------------------------
	
	                                                            Intermediate Operation -> it produce one stream
																----------------------
																
																filter()
                                                                map()
                                                                sorted(),distinct(),limit()and skip()

Terminal Operations: ->onestream(intermediate operation) ->input to the terminal operations
--------------------
forEach(),count(),min(),max(),toArray(),reduce(),findFirst(),findAny(),allMatch(),noneMatch()

Note:
more number of intermediate operation(lazy) but one terminal Operation
----------------------------------------------------------------
 	
collection will support object only not primitives
primitives ->wrapperclass ->object ->collection	

remove the duplicate, null value and sort the value in the collections object
-----------------------------------------

13) List l=new ArrayList();
        l.add("s");
        l.add("e");
        l.add("h");
        l.add(null);
		l.add("s");
        l.stream().distinct().filter(x->x!=null).sorted().forEach(x->System.out.println(x));
------------------------------------------------------------------------------------------------

14)Limit():
List l=new ArrayList();
        l.add("s");
        l.add("e");                                          output: s,e
        l.add("h");
         l.add("s");
        l.add(null);
       
        l.stream().limit(2).forEach(x->System.out.println(x));	
		 l.stream().skip(2).forEach(x->System.out.println(x));	 --->output: skip the first two elements (h,s)
-----------------------------------------------------------------------------------------------------------		 
15)reduce():
    List<Integer> l=new ArrayList();
        l.add(1);
        l.add(2);
        l.add(3);
         l.add(4);
        l.add(5);
    Optional val=   l.stream().reduce((x,y)->x+y);  ---->output: 15
    System.out.println(val.get());
-----------------------------------------------------------------------------------------------------------
16)collect(): this method converts stream into arraylist

  List<Integer> l=new ArrayList();
        l.add(1);
        l.add(2);
        l.add(3);
         l.add(4);
        l.add(5);
Object val=   l.stream().collect(Collectors.toList());
System.out.println(val);
----------------------------------------------------------------------------------------------------------------
        Given the user input for count of random number we generate between two digits using stream api


	/* Online Java Compiler and Editor */
import java.util.*;
public class HelloWorld{

     public static void main(String []args){
        System.out.println("Enter the count of random number you want");
        Scanner sc=new Scanner(System.in);
        int n= sc.nextInt();
        Random rb=new Random();
        rb.ints(10,99).limit(n).forEach(System.out::println);
     }
}
	output:

	Enter the count of random number you want
5

	
79
53
71
36
66
----------------------------------------------------------------------------------------------------------------------------
         To print a duplicate number in a given arraylist using streams

	List ls= Arrays.asList(1,2,3,4,5,5,10,10);
       Set s =  (Set) ls.stream().filter((i)->Collections.frequency(ls,i)>1).collect(Collectors.toSet());
       System.out.println(s);

output:
         5,10

---------------------------------------------------------------------------------------------------------------------------------
input: [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,4,5,6,7,8,9]

List<List<Integer>> listOfLists = Arrays.asList(
	            Arrays.asList(1, 2, 3),
	            Arrays.asList(4, 5, 6),
	            Arrays.asList(7, 8, 9)
	        );
	        System.out.println(listOfLists);
	        List singlelist = listOfLists.stream().flatMap((ls)->ls.stream()).collect(Collectors.toList());
	        System.out.println(singlelist);
