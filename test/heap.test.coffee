Heap = require '..'
assert = require 'assert'
{random} = Math

describe 'Heap#push, Heap#pop', ->
  it 'should sort an array using push and pop', ->
    heap = new Heap
    heap.push(random()) for i in [1..10]
    sorted = (heap.pop() until heap.empty())
    sorted.slice().sort()+"" == sorted+""

  it 'should work with custom comparison function', ->
    cmp = (a, b) ->
      return -1 if a > b
      return 1 if a < b
      0
    heap = new Heap(cmp)
    heap.push(random()) for i in [1..10]
    sorted = (heap.pop() until heap.empty())
    sorted.slice().sort().reverse()+"" is sorted+""

describe 'Heap#replace', ->
  it 'should behave like pop() followed by push()', ->
    heap = new Heap
    heap.push(v) for v in [1..5]
    heap.replace(3) == 1 and
    heap.toArray().sort()+"" is [2,3,3,4,5]+""

describe 'Heap#pushpop', ->
  it 'should behave like push() followed by pop()', ->
    heap = new Heap
    heap.push(v) for v in [1..5]
    heap.pushpop(6) is 1 and
      heap.toArray().sort() is [2..6]

describe 'Heap#contains', ->
  it 'should return whether it contains the value', ->
    heap = new Heap
    heap.push(v) for v in [1..5]
    [1..5].every( (v) -> heap.contains(v) ) and not
      heap.contains(0) and not
      heap.contains(6)

describe 'Heap#peek', ->
  it 'should return the top value', ->
    heap = new Heap
    heap.push(1)
    assert.equal(
      heap.peek(), 1
    )
    heap.push(2)
    assert.equal(
      heap.peek(), 1
    )

    heap.pop()
    assert.equal(
      heap.peek(), 2
    )


describe 'Heap#clone', ->
  it 'should return a cloned heap', ->
    a = new Heap
    a.push(v) for v in [1..5]
    b = a.clone()
    a.toArray()+"" is b.toArray()+""

describe 'Heap.nsmallest', ->
  it 'should return exactly n elements when size() >= n', ->
    assert.equal(
      Heap.nsmallest([1..10], 3)+"",
      [1..3]+""
    )

    array = [1,3,2,1,3,4,4,2,3,4,5,1,2,3,4,5,2,1,3,4,5,6,7,2]
    assert.equal(
      Heap.nsmallest(array, 2)+"",
      [1,1]+""
    )

  it 'should return size() elements when size() <= n', ->
    assert.equal(
      Heap.nsmallest([3..1], 10)+"",
      [1..3]+""
    )

describe 'Heap.nlargest', ->
  it 'should return exactly n elements when size() >= n', ->
    assert.equal(
      Heap.nlargest([1..10], 3)+"",
      [10..8]+""
    )

  it 'should return size() elements when size() <= n', ->
    Heap.nlargest([3..1], 10)+"" is [3..1]+""

describe 'Heap#updateItem', ->
  it 'should return correct order', ->
    a = x: 1
    b = x: 2
    c = x: 3
    h = new Heap (m, n) -> m.x - n.x
    h.push(a)
    h.push(b)
    h.push(c)
    c.x = 0
    h.updateItem(c)
    h.pop() is c
  it 'should return correct order when used statically', ->
    a = x: 1
    b = x: 2
    c = x: 3
    h = []
    cmp = (m, n) -> m.x - n.x
    Heap.push(h, a, cmp)
    Heap.push(h, b, cmp)
    Heap.push(h, c, cmp)
    c.x = 0
    Heap.updateItem(h, c, cmp)
    Heap.pop(h, cmp) is c
