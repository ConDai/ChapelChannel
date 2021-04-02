
record semaphore{
  var mutex$: sync bool = true;
  var v: atomic int;

  proc init(initialValue: int){
    var _v: atomic int;
    this.v = _v;
    this.v.write(initialValue);
  }

  proc wait(){
    mutex$.readFE();
    while(v.read() <= 0){}
    v.sub(1);
    mutex$.writeXF(true);
  }

  proc signal(){
    v.add(1);
  }
}
