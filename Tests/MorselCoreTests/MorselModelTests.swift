import Testing
@testable import MorselCore

@Suite("Morsel model")
struct MorselModelTests {

    @Test("Default morsel is info + short + no action")
    func defaults() {
        let morsel = Morsel(message: "Hello")
        #expect(morsel.style == .info)
        #expect(morsel.duration == .short)
        #expect(morsel.action == nil)
        #expect(!morsel.id.isEmpty)
    }

    @Test("Durations map to the expected seconds")
    func durationValues() {
        #expect(MorselDuration.short.timeInterval == 2.0)
        #expect(MorselDuration.long.timeInterval == 3.5)
        #expect(MorselDuration.seconds(10).timeInterval == 10)
        #expect(MorselDuration.indefinite.timeInterval == nil)
    }

    @Test("Each style has a distinct SF Symbol")
    func styleIcons() {
        let names = Set(MorselStyle.allCases.map(\.systemImageName))
        #expect(names.count == MorselStyle.allCases.count)
    }

    @Test("Action handler runs when invoked")
    func actionHandlerRuns() {
        var tapped = false
        let action = MorselAction(title: "Undo") { tapped = true }
        action.handler()
        #expect(tapped)
    }
}
