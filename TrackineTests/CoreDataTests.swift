//
//  CoreDataTests.swift
//  TrackineTests
//
//  Created by Dayton on 23/04/21.
//

import XCTest
@testable import Trackine

class CoreDataTests: XCTestCase {
   
    var testTool:(String, Int16)!
    var testFriend:String!

    override func setUp() {
      super.setUp()
        
        testTool = ("tool123", 3)
        testFriend = "friend123"
    }

    override func tearDown() {
        
        testTool = nil
        testFriend = nil
        CoreDataHelper.removeAll()
        
      super.tearDown()
    }

    func testCreateAndReadTool() {
        PrefillData.createStarterTools(name: testTool.0, itemCount: testTool.1)
        let tool = CoreDataHelper.readTool(queryType: .dominicTools, testTool.0)
        
        guard let name = tool?.name else { return }
          XCTAssertEqual("tool123", name)
          XCTAssertEqual(3, tool?.itemCount)
    }
    
    func testCreateAndReadFriend() {
        PrefillData.createStarterFriends(name: testFriend)
        let friend = CoreDataHelper.readFriend(name: testFriend)
        
        guard let name = friend?.name else { return }
        XCTAssertEqual("friend123", name)
    }

    func testcreateToolsForFriend() {
        PrefillData.createStarterTools(name: testTool.0, itemCount: testTool.1)
        PrefillData.createStarterFriends(name: testFriend)
        
        guard let tool = CoreDataHelper.readTool(queryType: .dominicTools, testTool.0),
              let name = tool.name,
              let friend = CoreDataHelper.readFriend(name: testFriend) else { return }
        
        CoreDataHelper.createToolsForFriend(toolName: name, itemCount: tool.itemCount, forFriend: friend)
        
        guard let borrowedTools = friend.tools?.allObjects as? [CDTools],
              let borrowedtool = borrowedTools.first
              else { return }
        
        XCTAssertEqual("tool123", borrowedtool.name)
        XCTAssertEqual(3, borrowedtool.itemCount)
        XCTAssertEqual(friend, borrowedtool.ofFriend)
    }
    
    func testCreateTools() {
        PrefillData.createStarterTools(name: testTool.0, itemCount: testTool.1)
        PrefillData.createStarterTools(name: "anotherTest", itemCount: 1)
        
        let tools = CoreDataHelper.readTools(queryType: ToolQuery.dominicTools)
        
        XCTAssertEqual(2, tools.count)
        assert((tools as Any) is [CDTools])
    }
    
    func createLoanModel() -> Loan? {
        PrefillData.createStarterTools(name: testTool.0, itemCount: testTool.1)
        
        PrefillData.createStarterFriends(name: testFriend)
        
        guard let originTool = CoreDataHelper.readTool(queryType: .dominicTools, testTool.0),
              let friend = CoreDataHelper.readFriend(name: testFriend)
              else { return nil}
        
        return Loan(tools: originTool, byFriend: friend, value: 1, toolQuery: .transaction)
    }
    
    func testUpdateTool() {
        guard let model = createLoanModel() else { return }

        CoreDataHelper.updateTool(model)
        
        guard let friendTools = model.byFriend.tools?.allObjects as? [CDTools],
              let friendTool = friendTools.first else { return }
        
        XCTAssertEqual(2, model.tools.itemCount)
        XCTAssertEqual(1, friendTool.itemCount)
    }
    
    func testDeleteToolFromFriend() {
        guard let model = createLoanModel(),
              let friendName = model.byFriend.name,
              let toolName = model.tools.name else { return }
        
        CoreDataHelper.updateTool(model)
        
        CoreDataHelper.deleteToolFromFriend(toolQuery: ToolQuery.transaction, friendName: friendName, toolName: toolName)
        
        let tools = model.byFriend.tools?.allObjects as? [CDTools]
        XCTAssertEqual(0, tools?.count)
    }
    
    func testReadFriends() {
        PrefillData.createStarterFriends(name: testFriend)
        PrefillData.createStarterFriends(name: "anotherFriend")
        
        let friends = CoreDataHelper.readFriends()
        
        XCTAssertEqual(2, friends.count)
        assert((friends as Any) is [CDFriends])
    }
    
    func testRemoveAll() {
        PrefillData.createStarterTools(name: testTool.0, itemCount: testTool.1)
        PrefillData.createStarterTools(name: "anotherTest", itemCount: 1)
        PrefillData.createStarterFriends(name: testFriend)
        PrefillData.createStarterFriends(name: "anotherFriend")
        CoreDataHelper.removeAll()
        
        let friends = CoreDataHelper.readFriends()
        let tools = CoreDataHelper.readTools(queryType: .dominicTools)
        XCTAssertEqual(0, friends.count)
        XCTAssertEqual(0, tools.count)
    }
}
