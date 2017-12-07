
class valuePairs {
  public String theKey_ = "";
  public String theValue_ = "";

  valuePairs() {
    theKey_ = "theKey";
    theValue_ = "theValue";
  };

  valuePairs(String theKey, String theValue) {
    theKey_ = theKey;
    theValue_ = theValue;
  };
}


String getProgramName(String queryWithSlash)
{
  // Removes trailing slash 
  String query = queryWithSlash.substring(1);
  int queryStartIndex = query.indexOf('?');
  String programName = query.substring(0, queryStartIndex);
  return programName;
}
///////// !!!!!!!!!!!
void getValuePair(String queryWithSlash, valuePairs thevaluePairs)
{
  String query = queryWithSlash.substring(1);
  int queryStartIndex = query.indexOf('?');
  String paramPair = queryWithSlash.substring(queryStartIndex+1, query.length());
  int splitIndex = paramPair.indexOf('=');
  String varName = paramPair.substring(0, splitIndex);
  String value = paramPair.substring(splitIndex +1, paramPair.length());
  thevaluePairs.theKey_ = varName;
  thevaluePairs.theValue_ = value;
};

void setup()
{

  String queryslash = "/program1name?var1=11&var2=22&var3=33&var4=44";
  //String query = "/program1name?var1=11&var2=22";
  //String query = "/program1name?var1=11";
  //println("Query with slash is: "  + queryslash);


  print("Program name: ");
  println(getProgramName(queryslash));


  int numParams = 0;
  String query = queryslash.substring(1);

  int splitIndex = 0;
  String paramPair = "";
  String varName = "";
  String value = "";

  int queryStartIndex = query.indexOf('?');

  int endParamIndex = query.indexOf('&');
  if (endParamIndex == -1)
  { // We have only one parameter pair
    numParams = 1;
    paramPair = query.substring(queryStartIndex+1, query.length());
    splitIndex = paramPair.indexOf('=');
    varName = paramPair.substring(0, splitIndex);
    value = paramPair.substring(splitIndex +1, paramPair.length());
    println("Only one param pair.");
    println("*** varName: " + varName + ", value: " + value);
    println("Total number of parameters: " + numParams);
  } else 
  {
    numParams = 1;
    // We know there is more than one paramPair
    println("Starting while loop. There is more than one paramPair.");
    while (endParamIndex != -1) 
    { 
      numParams++;
      //println("queryStartIndex is " + queryStartIndex + " and endParamIndex is: " + endParamIndex);
      paramPair = query.substring(queryStartIndex+1, endParamIndex);
      splitIndex = paramPair.indexOf('=');
      varName = paramPair.substring(0, splitIndex);
      value = paramPair.substring(splitIndex +1, paramPair.length());
      println("*** varName: " + varName + ", value: " + value);
      queryStartIndex = endParamIndex;
      endParamIndex = query.indexOf('&', queryStartIndex+1);
    };
    println("Finished while loop. Now for the last paramPair");
    paramPair = query.substring(queryStartIndex+1, query.length());
    splitIndex = paramPair.indexOf('=');
    varName = paramPair.substring(0, splitIndex);
    value = paramPair.substring(splitIndex +1, paramPair.length());
    println("*** varName: " + varName + ", value: " + value);
    println("Total number of parameters: " + numParams);
  }
}