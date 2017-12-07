// parse parameters, with argument= the expected number of parameters.
// First count number of parameters, then parse them. Doesnt matter if this is inefficient.
// If the program is given the wrong number of parameters, it must return error. 
// where to store values and keys? as an array that is created with new and delete
// perhaps each query could be the instance of a class
// so this 'query' class parses the query as soon as the constructor is called.
// it has String programname(int index), int numberofargs(), valuePair returnvaluepair(int index)
// if numberOfArgs is -1, that means that not even the program name could be determined
// if numberOfArgs is 0, the program name is still valid to be queried
// if numberOfArgs is >= 1, then there is at least one valuePair in the array of valuePairs.
//constructor takes string (which is the query) or nothing. In the latter case it
// remains with numberOfArgs at -1, until parse(String) is called, and that parses a string.


public class valuePair 
{
  public  String theKey_ = "";
  public String theValue_ = "";

  public valuePair()
  {
    theKey_ = "";
    theValue_ = "";
  };

  public valuePair(String theKey, String theValue) {
    theKey_ = theKey;
    theValue_ = theValue;
  };

  public String getParam()
  {
    return theKey_;
  };

  public String getValue()
  {
    return theValue_;
  };
}

public class query 
{
  public boolean parsed_ = false;
  public int numberOfArgs_ = -1;
  public String queryWithSlash_ = "";
  public String queryWithoutSlash_ = "";
  public String programName_ = "";
  public int argStartIndex_ = 0;  
  public ArrayList<valuePair> valuePairs_ = new ArrayList<valuePair>();

  public query()
  {
  }

  public query(String initQuery)
  {
    queryWithSlash_ = initQuery;
    parse();
  }

  public String getProgramName()
  {
    return programName_;
  }

  public int getNumberOfArgs()
  {
    return numberOfArgs_;
  }

  public valuePair getValuePair(int index)
  {
    if ( (index >= 0)||(index < numberOfArgs_))
    {
      return (valuePair) valuePairs_.get(index);
    };
    return new valuePair();
  }

  private int parse()
  {
    println("Starting parse().");
    print("Query is: ");
    println(queryWithSlash_);

    // When parsing, reset all internal members.

    parsed_ = false;
    numberOfArgs_ = -1;
    programName_ = "";
    for (int i = valuePairs_.size() - 1; i >= 0; i--) 
    {
      valuePairs_.remove(i);
    }

    // Cases: 
    // good
    //   /program1name
    //   /program1name?var1=11
    //   /program1name?var1=11&var2=22&var3=33&var4=44

    // malformed
    //   program1name?var1=11&var2
    //   /program1name?var1=
    //   /program1name?var1 // there is a
    //   /program1name?    // there is a ? but nothing else


    // If there is no preceding slash, or if we are not starting with a slash, this does not look like a query for us
    int slashindex = queryWithSlash_.indexOf('/');
    print("Index of /: ");
    println(slashindex);
    if ((slashindex == -1)||(slashindex !=0))
    {
      println("ERROR: The first character in the query is not a slash.");
      println((slashindex !=0));
      parsed_ = false;
      programName_ = "";
      return -1;
    };

    // Remove trailing slash 
    queryWithoutSlash_ = queryWithSlash_.substring(1);

    // Check for args. If there is a ?, there may be args.
    argStartIndex_ = queryWithoutSlash_.indexOf('?');

    // If there is no ?, we're done.
    if (argStartIndex_ == -1)
    {
      // Example:   /program1name
      parsed_ = true;
      numberOfArgs_ = 0;
      programName_ = queryWithoutSlash_;
      return 0;
    }
    // If there is a ? but not at least one =, then it is malformed. We wil keep the programName, though.
    if (queryWithSlash_.indexOf('=') == -1)
    {
      //  Example   /program1name?var1
      // programName is up to ?
            println("ERROR: There is a ? but no parameter,value pair.");
      programName_ = queryWithoutSlash_.substring(0, argStartIndex_);
      parsed_ = false;
      return -1;
    };
    // Else, there are args because there is a ? and a =.
    programName_ = queryWithoutSlash_.substring(0, argStartIndex_);

    int splitIndex = 0;
    String paramPair = "";
    String varName = "";
    String value = "";


    int endParamIndex = queryWithoutSlash_.indexOf('&');
    // If there is no &, there is only one parameter pair
    if (endParamIndex == -1)
    { 
      // We have only one parameter pair
      numberOfArgs_ = 1;
      // take everything after ?. There is no &.
      paramPair = queryWithoutSlash_.substring(argStartIndex_+1, queryWithoutSlash_.length());
      splitIndex = paramPair.indexOf('='); 
      varName = paramPair.substring(0, splitIndex);
      value = paramPair.substring(splitIndex +1, paramPair.length());

      println("Only one param pair.");
      println("*** varName: " + varName + ", value: " + value);
      println("Total number of parameters: " + numberOfArgs_);
      parsed_ = true;
      return 0;
    } else // there is at least one &
    {
      numberOfArgs_ = 1;
      // We know there is more than one paramPair
      println("Starting while loop. There is more than one paramPair.");
      while (endParamIndex != -1) 
      { 
        numberOfArgs_++;
        //println("argStartIndex_ is " + argStartIndex_ + " and endParamIndex is: " + endParamIndex);
        // paramPair will contain everything after ? and before &
        paramPair = queryWithoutSlash_.substring(argStartIndex_ + 1, endParamIndex);
        splitIndex = paramPair.indexOf('=');
        varName = paramPair.substring(0, splitIndex);
        value = paramPair.substring(splitIndex +1, paramPair.length());
        println("*** varName: " + varName + ", value: " + value);
        valuePairs_.add(new valuePair(varName, value));
        argStartIndex_ = endParamIndex;
        endParamIndex = queryWithoutSlash_.indexOf('&', argStartIndex_+1);
      };
      println("Finished while loop. Now for the last paramPair");
      paramPair = queryWithoutSlash_.substring(argStartIndex_+1, queryWithoutSlash_.length());
      splitIndex = paramPair.indexOf('=');
      varName = paramPair.substring(0, splitIndex);
      value = paramPair.substring(splitIndex +1, paramPair.length());
      valuePairs_.add(new valuePair(varName, value));
      println("*** varName: " + varName + ", value: " + value);
      println("Total number of parameters: " + numberOfArgs_);
      parsed_ = true;
      return 0;
    }
  }  // parse()
}; // class query


void setup()
{
//  String queryslash = "/program1name?var1=11&var2=22&var3=33&var4=44";
   String queryslash = "/program1name?";

  query theQuery = new query(queryslash);

  print("Program name: ");
  println(theQuery.getProgramName());
  for (int i = 0; i < theQuery.getNumberOfArgs(); i++)
  {
    print(theQuery.getValuePair(i).getParam());
        print("  ");
        println(theQuery.getValuePair(i).getValue());
  }
}