import Testing
@testable import SnackbarCore

@Suite("SnackbarQueue")
struct SnackbarQueueTests {

    @Test("A new queue is empty")
    func startsEmpty() {
        let queue = SnackbarQueue()
        #expect(queue.isEmpty)
        #expect(queue.current == nil)
    }

    @Test("Enqueue makes the first snackbar current")
    func firstBecomesCurrent() {
        let queue = SnackbarQueue()
        let a = Snackbar(message: "A")
        queue.enqueue(a)
        #expect(queue.current == a)
        #expect(queue.count == 1)
    }

    @Test("Later snackbars wait behind the current one")
    func laterOnesWait() {
        let queue = SnackbarQueue()
        let a = Snackbar(message: "A")
        let b = Snackbar(message: "B")
        queue.enqueue(a)
        queue.enqueue(b)
        #expect(queue.current == a)   // still showing the first
        #expect(queue.count == 2)
    }

    @Test("Dismissing advances to the next snackbar in order")
    func dismissAdvances() {
        let queue = SnackbarQueue()
        let a = Snackbar(message: "A")
        let b = Snackbar(message: "B")
        queue.enqueue(a)
        queue.enqueue(b)

        let next = queue.dismissCurrent()
        #expect(next == b)
        #expect(queue.current == b)
        #expect(queue.count == 1)
    }

    @Test("Dismissing the last one empties the queue")
    func dismissLast() {
        let queue = SnackbarQueue()
        queue.enqueue(Snackbar(message: "only"))
        let next = queue.dismissCurrent()
        #expect(next == nil)
        #expect(queue.isEmpty)
    }

    @Test("Remove by id takes a snackbar out wherever it is")
    func removeByID() {
        let queue = SnackbarQueue()
        let a = Snackbar(message: "A")
        let b = Snackbar(message: "B")
        queue.enqueue(a)
        queue.enqueue(b)
        queue.remove(id: b.id)
        #expect(queue.count == 1)
        #expect(queue.current == a)
    }

    @Test("Clear empties everything")
    func clearAll() {
        let queue = SnackbarQueue()
        queue.enqueue(Snackbar(message: "A"))
        queue.enqueue(Snackbar(message: "B"))
        queue.clear()
        #expect(queue.isEmpty)
    }
}
