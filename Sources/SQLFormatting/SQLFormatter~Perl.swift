#if canImport(PerlCore)

import PerlCore

extension SQLFormatter {
//  static let pgFormatter = Bundle.module.path(forResource: "PGFormatter", ofType: "pm")!
  static var perlInterpreter: PerlInterpreter!
  
  /// Formats a string of SQL source code using Perl.
  /// - Parameters:
  ///   - from: The string to format.
  /// - Returns: The formatted string.
  public static func extendedFormattedString(from string: String) -> String {
    if perlInterpreter == nil {
      PerlInterpreter.initialize()
      perlInterpreter = PerlInterpreter.shared
      perlInterpreter.evaluateScript(PGFormatter)
      print(perlInterpreter.exception)
    }
    
    perlInterpreter["string"]!.asString = string
    
    // TODO: add all args
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
