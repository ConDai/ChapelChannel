use Channel;
use UnitTest;

// Send elements of xs to the given channel
proc producer(ref ch:chan(int,?n)){
  for x in 1..100{
    writeln("Will send ", x);
    ch <<= x;
  }
}

// Read the elements from the channel
// n is the size of the list given to the producer
proc consumers(ref ch:chan(int,?n)) throws{
  var prev:int;
  var curr:int = 0;
  for i in 1..10{
    prev = curr;
    curr <<= ch;
    writeln("Received ",curr);
    if prev >= curr then 
      throw new Error();
  }
}

proc testFIFO(test: borrowed Test) throws{

  var ch:chan = new chan(int,10);
  
  coforall i in 1..10 with (ref ch) {
    if i == 1 then
      producer(ch);
    else
      consumers(ch);  
  } 
}


UnitTest.main();