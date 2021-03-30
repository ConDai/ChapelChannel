use semaphore;

record Channel {
  type t;
  var size:   int;
  var buffer: [0..size-1] t;
  
  var full: semaphore.Semaphore;
  var empty: semaphore.Semaphore;
  var sendX: int = 0;
  var recvX: int = 0;

  var mutex$: sync bool = true;

  proc init(type t, size: int){
    this.t = t;
    this.size = size;
    this.full = new semaphore.Semaphore(0);
    this.empty = new semaphore.Semaphore(size);
  }

  proc send(el:t) {
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
    var res:t = buffer[sendX];
    sendX = (sendX + 1) % size;
    mutex$.writeEF(true);
    empty.signal();
    return res;
  }
}