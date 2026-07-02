import Testing
@testable import SnackbarCore

@Suite("Snackbar model")
struct SnackbarModelTests {

    @Test("Default snackbar is info + short + no action")
    func defaults() {
        let snackbar = Snackbar(message: "Hello")
        #expect(snackbar.style == .info)
        #expect(snackbar.duration == .short)
        #expect(snackbar.action == nil)
        #expect(!snackbar.id.isEmpty)
    }

    @Test("Durations map to the expected seconds")
    func durationValues() {
        #expect(SnackbarDuration.short.timeInterval == 2.0)
        #expect(SnackbarDuration.long.timeInterval == 3.5)
        #expect(SnackbarDuration.seconds(10).timeInterval == 10)
        #expect(SnackbarDuration.indefinite.timeInterval == nil)
    }

    @Test("Each style has a distinct SF Symbol")
    func styleIcons() {
        let names = Set(SnackbarStyle.allCases.map(\.systemImageName))
        #expect(names.count == SnackbarStyle.allCases.count)
    }

    @Test("Action handler runs when invoked")
    func actionHandlerRuns() {
        var tapped = false
        let action = SnackbarAction(title: "Undo") { tapped = true }
        action.handler()
        #expect(tapped)
    }
}
