import XCTest
@testable import SQLFormatting

final class SQLFormatterTests: XCTestCase {
  func testFormattedString() throws {
    XCTAssertEqual(
      SQLFormatter.formattedString(from: "select * from a_table"),
      """
      select
        *
      from
        a_table
      
      """
    )
  }
  
  func testFormattedStringWithIndentWidth8() throws {
    XCTAssertEqual(
      SQLFormatter.formattedString(from: "select * from a_table", indent: "    "),
      """
      select
          *
      from
          a_table
      
      """
    )
  }
  
  func testFormattedStringWithUppercase() throws {
    XCTAssertEqual(
      SQLFormatter.formattedString(from: "select * from a_table", uppercase: true),
      """
      SELECT
        *
      FROM
        a_table
      
      """
    )
  }

  func testMinifiedString() throws {
    XCTAssertEqual(
      SQLFormatter.minifiedString(from: "select     *  from   a_table"),
      "select * from a_table"
    )
  }
  
  func testMinifiedStringWithCompression() throws {
    XCTAssertEqual(
      SQLFormatter.minifiedString(from: "select * from a_table", compress: true),
      "select*from a_table"
    )
  }
}
