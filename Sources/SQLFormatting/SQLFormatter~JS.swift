#if canImport(JavaScriptCore)

import JavaScriptCore

@available(macOS 10.10, iOS 9, tvOS 9, *)
extension SQLFormatter {
  // TODO: use JS build system & package.json instead of committing these libs to Git
  static let pgMinify = Bundle.module.path(forResource: "PGMinify", ofType: "js")!
  static let sqlFormatter = Bundle.module.path(forResource: "SQLFormatter", ofType: "js")!
  
//  /// The engine used for formatting.
//  public enum FormattingEngine: String {
//    /// SQL Formatter.
//    case sqlFormatter
//    /// pgFormatter.
//    @available(macOS 10.10, *)
//    case pgFormatter
//  }
  
  /// The SQL dialect used for formatting.
  public enum Dialect: String {
    /// MariaDB.
    case mariadb
    /// MySQL.
    case mysql
    /// PostgreSQL.
    case postgresql
    /// IBM DB2.
    case db2
    /// Oracle PL/SQL.
    case plsql
    /// Couchbase N1QL.
    case n1ql
    /// Amazon Redshit.
    case redshift
    /// Spark.
    case spark
    /// SQL Server Transact-SQL.
    case tsql
  }
  
  /// Formats a string of SQL source code.
  /// - Parameters:
  ///   - from: The string to format.
  ///   - dialect: SQL dialect used for formatting.
  ///   - indent: String to use for indentation.
  ///   - uppercase: Whether to uppercase keywords.
  /// - Returns: The formatted string.
  public static func formattedString(
    from string: String,
    dialect: Dialect? = nil,
    indent: String = "  ",
    uppercase: Bool = false
  ) -> String {
    let arguments: [String: Any] = [
      "language": dialect?.rawValue ?? "sql",
      "indent": indent,
      "uppercase": uppercase
    ]

    let context = JSContext()!
    context.evaluateScript("var window = {}")
    context.evaluateScript(try! String(contentsOfFile: Self.sqlFormatter))
    return context
      .evaluateScript("window.sqlFormatter.format")!
      .call(withArguments: [string, arguments])
      .toString() + "\n"
  }
  
  /// Minifies and optionally compresses a string of SQL source code.
  /// - Parameters:
  ///   - from: The string to minify.
  ///   - compress: Whether to compress the minified source code to the shortest possible version.
  /// - Returns: The minified string.
  public static func minifiedString(from string: String, compress: Bool = false) -> String {
    let context = JSContext()!
    context.evaluateScript("var window = {}")
    context.evaluateScript(try! String(contentsOfFile: Self.pgMinify))
    return context
      .evaluateScript("window.pgMinify")!
      .call(withArguments: [string, ["compress": compress]])
      .toString()
  }
}

#endif
