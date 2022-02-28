#if canImport(PerlCore)

import PerlCore

extension SQLFormatter {
  static var perlInterpreter: PerlInterpreter!
  
  /// Formats a string of SQL source code using Perl.
  /// - Parameters:
  ///   - from: The string to format.
  ///   - indent: String to use for indentation.
  ///   - uppercase: Whether to uppercase keywords.
  /// - Returns: The formatted string.
  public static func extendedFormattedString(
    from string: String,
    indent: String = "  ",
    uppercase: Bool = false
  ) -> String {
    if perlInterpreter == nil {
      perlInterpreter = PerlInterpreter.shared
      perlInterpreter.evaluateScript(PGFormatter)
    }

    perlInterpreter["string"]!.asString = string
    perlInterpreter["space"]!.asString = indent

    // 0 - do not change
    // 1 - change to lower case
    // 2 - change to upper case
    // 3 - change to capitalized
    // TODO: consider supporting 0 and 3 also
    perlInterpreter["uc_keywords"]!.asInt = uppercase ? 2 : 1

    // TODO: add all remaining args
    return perlInterpreter.evaluateScript(
      """
      my %args;
      $args{ 'spaces' } = 1;
      $args{ 'space' } = $space;
      $args{ 'uc_keywords' } = $uc_keywords;
      
      my $beautifier = pgFormatter::Beautify->new(%args);
      $beautifier->query($string);
      $beautifier->beautify();
      $beautifier->content;
      """
    ).asString
  }
}

#endif
