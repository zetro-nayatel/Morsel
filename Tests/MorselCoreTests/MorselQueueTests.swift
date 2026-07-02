import Testing
@testable import MorselCore

@Suite("MorselQueue")
struct MorselQueueTests {

    @Test("A new queue is empty")
    func startsEmpty() {
        let queue = MorselQueue()
        #expect(queue.isEmpty)
        #expect(queue.current == nil)
    }

    @Test("Enqueue makes the first morsel current")
    func firstBecomesCurrent() {
        let queue = MorselQueue()
        let a = Morsel(message: "A")
        queue.enqueue(a)
        #expect(queue.current == a)
        #expect(queue.count == 1)
    }

    @Test("Later morsels wait behind the current one")
    func laterOnesWait() {
        let queue = MorselQueue()
        let a = Morsel(message: "A")
        let b = Morsel(message: "B")
        queue.enqueue(a)
        queue.enqueue(b)
        #expect(queue.current == a)   // still showing the first
        #expect(queue.count == 2)
    }

    @Test("Dismissing advances to the next morsel in order")
    func dismissAdvances() {
        let queue = MorselQueue()
        let a = Morsel(message: "A")
        let b = Morsel(message: "B")
        queue.enqueue(a)
        queue.enqueue(b)

        let next = queue.dismissCurrent()
        #expect(next == b)
        #expect(queue.current == b)
        #expect(queue.count == 1)
    }

    @Test("Dismissing the last one empties the queue")
    func dismissLast() {
        let queue = MorselQueue()
        queue.enqueue(Morsel(message: "only"))
        let next = queue.dismissCurrent()
        #expect(next == nil)
        #expect(queue.isEmpty)
    }

    @Test("Remove by id takes a morsel out wherever it is")
    func removeByID() {
        let queue = MorselQueue()
        let a = Morsel(message: "A")
        let b = Morsel(message: "B")
        queue.enqueue(a)
        queue.enqueue(b)
        queue.remove(id: b.id)
        #expect(queue.count == 1)
        #expect(queue.current == a)
    }

    @Test("Clear empties everything")
    func clearAll() {
        let queue = MorselQueue()
        queue.enqueue(Morsel(message: "A"))
        queue.enqueue(Morsel(message: "B"))
        queue.clear()
        #expect(queue.isEmpty)
    }
}
