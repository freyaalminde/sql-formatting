import JavaScriptCore

/// A formatter that pretty prints and minifies SQL source code.
@available(macOS 10.10, iOS 8, tvOS 9, *)
public class SQLFormatter {
  // TODO: use JS build system & package.json instead of committing these libs to Git
  static let pgMinify = Bundle.module.path(forResource: "PGMinify", ofType: "js")!
  static let sqlFormatter = Bundle.module.path(forResource: "SQLFormatter", ofType: "js")!
  
  /// Formats a string of SQL source code.
  /// - Parameters:
  ///   - from: The string to format.
  ///   - indent: String to use for indentation.
  ///   - uppercase: Whether to uppercase keywords.
  public static func formattedString(from string: String, indent: String = "  ", uppercase: Bool = false) -> String {
    let context = JSContext()!
    context.evaluateScript("var window = {}")
    context.evaluateScript(try! String(contentsOfFile: Self.sqlFormatter))
    return context
      .evaluateScript("window.sqlFormatter.format")!
      .call(withArguments: [string, ["indent": indent, "uppercase": uppercase]])
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
