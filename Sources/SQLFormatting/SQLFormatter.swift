import JavaScriptCore

// TODO: consider splitting up the API like: SQLFormatter, PGFormatter, PGMinifier

/// A formatter that pretty prints and minifies SQL source code.
@available(macOS 10.10, iOS 8, tvOS 9, *)
public class SQLFormatter {
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
  public enum SQLDialect: String {
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
  public static func formattedString(
    from string: String,
    dialect: SQLDialect? = nil,
    indent: String = "  ",
    uppercase: Bool = false
  ) -> String {
    let context = JSContext()!
    context.evaluateScript("var window = {}")
    context.evaluateScript(try! String(contentsOfFile: Self.sqlFormatter))
    return context
      .evaluateScript("window.sqlFormatter.format")!
      .call(withArguments: [string, [
        "language": dialect?.rawValue ?? "sql",
        "indent": indent,
        "uppercase": uppercase
      ]])
      .toString() + "\n"
  }
  
  /// Minifies and optionally compresses a string of SQL source code.
  /// - Parameters:
  ///   - from: The string to minify.
  ///   - compress: Whether to compress the minified source code to the shortest possible version.
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

#if os(macOS)
import PerlCore
#endif

#if canImport(PerlCore)

extension SQLFormatter {
  static let pgFormatter = Bundle.module.path(forResource: "PGFormatter", ofType: "pm")!
  static var perlInterpreter: PerlInterpreter!
  
  public static func extendedFormattedString(from string: String) -> String {
    if perlInterpreter == nil {
      PerlInterpreter.initialize()
      perlInterpreter = PerlInterpreter()
      perlInterpreter.evaluateScript(try! String(contentsOfFile: Self.pgFormatter))
    }
    
    perlInterpreter.scalarValue("string", true)!.asString = string
    
    return perlInterpreter.evaluateScript(
      """
      # my %args;
      # $args{ 'uc_keywords' } = 1;
      
      my $beautifier = pgFormatter::Beautify->new(%args);
      $beautifier->query($string);
      $beautifier->beautify();
      $beautifier->content;
      """
    ).asString
  }
}

#endif
