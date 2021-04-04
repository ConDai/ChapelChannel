use Channel;
use UnitTest;

proc producer(ref ch:chan(int,?n)){
  for x in 1..100{
    ch <<= x;
  }
}

proc consumer(ref ch:chan(int,?n)) throws{
  var prev:int;
  var curr:int = 0;
  for i in 1..100{
    prev = curr;
    curr <<= ch;
    if prev >= curr then 
      throw new Error();
  }
}

proc singleProducerConsumerTestFIFO(test: borrowed Test) throws{
  var ch:chan = new chan(int,10);
  coforall i in 1..2 with (ref ch) {
    if i == 1 then
      producer(ch);
    else
      consumer(ch);  
  } 
}
