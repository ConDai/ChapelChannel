use Channel;

proc worker(ref ch: chan){
  for i in 1..10 do{
    writeln("Will send ", i);
    i >>= ch;
  }
}

proc consumer(ref ch: chan){
  for i in 1..10 do{
    var val: int;
    ch >>= val;
    writeln("Read ", val);
  }
}

proc main(){
  var ch = new chan(int, 10);

  coforall i in 1..2 with (ref ch) {  
    if i%2 == 0 then
      consumer(ch);
    else
      worker(ch);
  }
  writeln("Finished!");
}