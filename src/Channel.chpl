

use Semaphore;

record chan {
  type eltType;
  var size:   int;
  var buffer: [0..size-1] eltType;
  
  var full: Semaphore.semaphore;
  var empty: Semaphore.semaphore;
  var sendX: int = 0;
  var recvX: int = 0;

  var mutex$: sync bool = true;

  proc init(type eltType, size: int){
    this.eltType = eltType;
    this.size = size;
    this.full = new Semaphore.semaphore(0);
    this.empty = new Semaphore.semaphore(size);
  }

  proc send(el:eltType) {
    empty.wait();
    mutex$.readFE();
    buffer[recvX] = el;
    recvX = (recvX + 1) % size;
    mutex$.writeEF(true);
    full.signal();
  }

  proc read() {
    full.wait();
    mutex$.readFE();
    var res:eltType = buffer[sendX];
    sendX = (sendX + 1) % size;
    mutex$.writeEF(true);
    empty.signal();
    return res;
  }
}


proc >>= (const val:?t, ref ch:chan(t,?n)){
    ch.send(val);
}

proc <<= (ref ch:chan(?t,?n), const val:t){
    ch.send(val);
}

proc >>= (ref ch:chan(?t,?n), ref ret:t){
  ret = ch.read();
}

proc <<= (ref ret:?t, ref ch:chan(t,?n)){
  ret = ch.read();
}
