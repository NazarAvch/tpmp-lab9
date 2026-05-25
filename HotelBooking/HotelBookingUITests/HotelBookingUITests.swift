import XCTest

final class HotelBookingUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    // MARK: - 1. Проверка наличия главного экрана
    func testMainScreenExists() {
        let title = app.staticTexts["main_title"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
    }

    // MARK: - 2. Переход к списку отелей
    func testNavigateToHotelList() {
        app.buttons["hotels_tab"].tap()
        let hotelsList = app.collectionViews["hotels_list"]
        XCTAssertTrue(hotelsList.waitForExistence(timeout: 2))
    }

    // MARK: - 3. Выбор конкретного отеля
    func testSelectHotel() {
        app.buttons["hotels_tab"].tap()
        let firstHotel = app.cells.element(boundBy: 0)
        firstHotel.tap()
        let detailScreen = app.staticTexts["hotel_detail_name"]
        XCTAssertTrue(detailScreen.waitForExistence(timeout: 2))
    }

    // MARK: - 4. Заполнение формы бронирования (даты + гости)
    func testBookingFormFilling() {
        app.buttons["hotels_tab"].tap()
        app.cells.firstMatch.tap()
        app.buttons["book_now_button"].tap()

        let checkInPicker = app.datePickers["check_in_picker"]
        checkInPicker.tap()
        app.buttons["Confirm"].tap()

        let checkOutPicker = app.datePickers["check_out_picker"]
        checkOutPicker.tap()
        app.buttons["Confirm"].tap()

        let guestsField = app.textFields["guests_count"]
        guestsField.tap()
        guestsField.typeText("2")

        app.buttons["confirm_booking"].tap()

        let successAlert = app.alerts["booking_success"]
        XCTAssertTrue(successAlert.waitForExistence(timeout: 3))
    }

    // MARK: - 5. Выбор вида транспорта после бронирования
    func testTransportSelectionScreenAppears() {
        testBookingFormFilling()
        app.alerts["booking_success"].buttons["OK"].tap()

        let transportScreen = app.staticTexts["choose_transport_title"]
        XCTAssertTrue(transportScreen.waitForExistence(timeout: 2))

        XCTAssertTrue(app.buttons["plane_button"].exists)
        XCTAssertTrue(app.buttons["train_button"].exists)
        XCTAssertTrue(app.buttons["bus_button"].exists)
    }

    // MARK: - 6. Выбор маршрута на карте
    func testRouteSelectionOnMap() {
        testTransportSelectionScreenAppears()
        app.buttons["map_route_button"].tap()

        let mapView = app.maps["route_map"]
        XCTAssertTrue(mapView.waitForExistence(timeout: 3))

        mapView.tap(at: CGVector(dx: 0.5, dy: 0.5))
        let confirmRoute = app.buttons["confirm_route_button"]
        XCTAssertTrue(confirmRoute.waitForExistence(timeout: 2))
    }

    // MARK: - 7. Отображение списка рейсов после выбора маршрута
    func testFlightListDisplay() {
        testRouteSelectionOnMap()
        app.buttons["confirm_route_button"].tap()

        let flightsTable = app.tables["flights_list"]
        XCTAssertTrue(flightsTable.waitForExistence(timeout: 3))
        XCTAssertGreaterThan(flightsTable.cells.count, 0)
    }

    // MARK: - 8. Фильтрация рейсов по типу транспорта
    func testFilterFlightsByPlane() {
        testFlightListDisplay()
        app.buttons["filter_plane"].tap()

        let flightsTable = app.tables["flights_list"]
        let planeCells = flightsTable.cells.containing(.staticText, identifier:"plane_icon")
        XCTAssertGreaterThan(planeCells.count, 0)
    }

    // MARK: - 9. Проверка локализации (переключение на русский)
    func testRussianLocalization() {
        app.terminate()
        app.launchArguments = ["-AppleLanguages", "(ru)"]
        app.launch()

        let bookingButton = app.buttons["booking_button_title"]
        XCTAssertEqual(bookingButton.label, "Забронировать")
    }

    // MARK: - 10. Сквозной сценарий: бронирование + транспорт + выбор рейса
    func testEndToEndBookingAndFlightSelection() {
        testFlightListDisplay()
        let firstFlight = app.tables["flights_list"].cells.firstMatch
        firstFlight.tap()
        let confirmationScreen = app.staticTexts["booking_final_title"]
        XCTAssertTrue(confirmationScreen.waitForExistence(timeout: 2))

        let finishButton = app.buttons["finish_button"]
        finishButton.tap()
        let mainTitle = app.staticTexts["main_title"]
        XCTAssertTrue(mainTitle.waitForExistence(timeout: 2))
    }
}

