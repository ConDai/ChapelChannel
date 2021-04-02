use Channel;

proc producer(ref ch:chan, id: int){
  coforall i in 0..9 with (ref ch) {
    var sendVal: int = id * 10 + i;
    writeln("Worker ", i , " will send ", sendVal);
    sendVal >>= ch;
  }
}

proc consumer(ref ch: chan, id: int){
  coforall i in 0..9 with (ref ch) {
    var v:int;
    v <<= ch;
    writeln("Consumer ", i , " received ", v);
  }
}

proc producers(ref ch: chan){
  coforall i in 0..9 with (ref ch){
    producer(ch,i);
  } 
}

proc consumers(ref ch:chan){
  coforall i in 0..9 with (ref ch){
    consumer(ch,i);
  }
}

proc main(){
  var ch = new chan(int, 10);

  coforall i in 1..2 with (ref ch) {  
    if i%2 == 0 then
      consumers(ch);
    else
      producers(ch);
  }
  writeln("Finished!");
}