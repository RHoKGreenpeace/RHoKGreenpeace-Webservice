module.exports = class PriorityQueue
    @MIN = 1
    @MAX = -1


    constructor: (@comparator, @direction = PriorityQueue.MIN) ->
        @heap = [null]

    isEmpty: ->
        @heap.length < 2

    size: ->
        @heap.length - 1

    top: ->
        return @heap[1]

    push: (elm) ->
        @heap[@heap.length] = elm
        @swim(@heap.length - 1)

        #console.log @isHeap(1)

    pop: ->
        @swap(1, @heap.length - 1) #Swap to end for deletion
        heapTop = @heap.pop() #remove last element
        @sink(1) #Sink swapped element

        #console.log @isHeap(1)

        heapTop

    toArray: ->
        copy = new PriorityQueue(@comparator, @direction)
        for item in @heap.slice(1)
            copy.heap.push item

        throw new Error 'Check that order is correct'
        (copy.shift() until copy.isEmpty())

    swim: (k) ->
        while k > 1 and @less((k/2 | 0), k) # k/2 | 0 is floor
            @swap(k, (k/2 | 0))
            k = (k/2 | 0)
            undefined

    sink: (k) ->
        N = @heap.length - 1

        while 2*k <= N
            j = 2*k
            j++     if j < N and @less(j, j+1)
            break   if not @less(k, j)

            @swap(k, j)
            k = j
            undefined


    less: (i, j) ->
        res = @comparator(@heap[i], @heap[j]) < 0

        if @direction == PriorityQueue.MAX
            res = not res

        res

    swap: (thisIdx, thatIdx) =>
        [@heap[thatIdx], @heap[thisIdx]] = [@heap[thisIdx], @heap[thatIdx]]


    isHeap: (k) ->
        N = @heap.length - 1

        return true if k > N

        left  = 2*k | 0
        right = 2*k + 1 | 0

        return false if left  <= N and @less k, left
        return false if right <= N and @less k, right

        return @isHeap(left) and @isHeap(right)


# Parent: K/2
# Children
#   Left:   K*2
#   Right:  K*2+1

# pq = new PriorityQueue ((i, j) -> j - i), PriorityQueue.MAX

# pq.push 2
# pq.push 1
# pq.push 1
# pq.push 10
# pq.push 12
# pq.push 20

# console.log pq.toArray()

# console.log pq.pop()

# console.log pq.pop()

# console.log pq.pop()
