import XCTest
@testable import SQLFormatting

final class SQLFormatterTests: XCTestCase {
#if canImport(JavaScriptCore)
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
  
  func testFormattedStringWithIndentWidth() throws {
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
  
  func testFormattedStringWithMySQLDialect() throws {
    XCTAssertEqual(
      SQLFormatter.formattedString(from: "select `a_database`.`a_column`, `a_database`.`another_column` from `a_table`", dialect: .mysql),
      """
      select
        `a_database`.`a_column`,
        `a_database`.`another_column`
      from
        `a_table`
      
      """
    )
  }
  
  func testFormattedStringWithTSQLDialect() throws {
    XCTAssertEqual(
      SQLFormatter.formattedString(from: "select [a_database].[a_column], [a_database].[another_column] from [a_table]", dialect: .tsql),
      """
      select
        [a_database].[a_column],
        [a_database].[another_column]
      from
        [a_table]
      
      """
    )
  }
#endif

#if canImport(PerlCore)
  func testExtendedFormattedString() throws {
    for _ in 1...3 {
      XCTAssertEqual(
        SQLFormatter.extendedFormattedString(from: "SELECT a,b,c from d where e = f"),
        """
        select
          a,
          b,
          c
        from
          d
        where
          e = f
        
        """
      )
    }
  }
  
  func testExtendedFormattedStringWithIndentWidth() throws {
    XCTAssertEqual(
      SQLFormatter.extendedFormattedString(from: "select a,b,c from d where e = f", indent: "    "),
      """
      select
          a,
          b,
          c
      from
          d
      where
          e = f
      
      """
    )
  }
  
  func testExtendedFormattedStringWithUppercase() throws {
    XCTAssertEqual(
      SQLFormatter.extendedFormattedString(from: "select a,b,c from d where e = f", uppercase: true),
      """
      SELECT
        a,
        b,
        c
      FROM
        d
      WHERE
        e = f
      
      """
    )
  }
#endif
}
