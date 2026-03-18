// 租賃歸還邏輯單元測試與邊際案例
// 使用方式：在 Xcode 中新增 Unit Test Target (HikBikTests)，將此文件加入該 Target，並設 Host Application 為 HikBik
import XCTest
@testable import HikBik

final class RentalLogicTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // 確保使用共享 Mock 數據源（與 App 一致）
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - 歸還流程與押金退款

    /// 模擬帶 $50 押金的 Rent 訂單，調用 startMockReturnFlow，在約 16 秒後檢查狀態為 .completed 且 isDepositRefunded == true
    func testReturnFlowAndDepositRefund() {
        let api = MockAPIService.shared
        let viewModel = OrdersViewModel(api: api)

        guard let rentalOrder = api.orders.first(where: { $0.orderType == .rent && $0.status == .renting }) else {
            XCTFail("Mock 數據中應存在一筆 Renting 租賃訂單")
            return
        }
        XCTAssertEqual(rentalOrder.status, .renting)
        XCTAssertNil(rentalOrder.isDepositRefunded)

        let orderId = rentalOrder.id
        let exp = expectation(description: "Return flow completes with completed + refunded")
        viewModel.startMockReturnFlow(for: orderId)

        // 流程為 0s -> .returning, 5s -> .received, 15s -> .completed + isDepositRefunded
        DispatchQueue.main.asyncAfter(deadline: .now() + 16.0) {
            let updated = api.orders.first(where: { $0.id == orderId })
            let statusOk = updated?.status == .completed
            let refundOk = updated?.isDepositRefunded == true
            XCTAssertTrue(statusOk, "訂單狀態應為 .completed，實際: \(String(describing: updated?.status))")
            XCTAssertTrue(refundOk, "isDepositRefunded 應為 true，實際: \(String(describing: updated?.isDepositRefunded))")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 20.0)
    }

    // MARK: - 邊際案例：買斷訂單不可歸還

    /// Buy 模式訂單調用歸還邏輯時應被攔截，訂單狀態不變、不報錯
    func testBuyOrderReturnIsIgnored() {
        let api = MockAPIService.shared
        let viewModel = OrdersViewModel(api: api)

        guard let buyOrder = api.orders.first(where: { $0.orderType == .buy }) else {
            XCTFail("Mock 數據中應存在 Buy 訂單")
            return
        }
        let orderId = buyOrder.id
        let originalStatus = buyOrder.status

        viewModel.startMockReturnFlow(for: orderId)

        let exp = expectation(description: "Buy order unchanged after return attempt")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let after = api.orders.first(where: { $0.id == orderId })
            XCTAssertEqual(after?.status, originalStatus, "Buy 訂單狀態不應被歸還邏輯修改")
            XCTAssertEqual(after?.orderType, .buy)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }
}
