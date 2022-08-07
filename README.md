# SQL Formatting

Format SQL source on Apple platforms using [SQL Formatter](https://github.com/zeroturnaround/sql-formatter), [pgFormatter](https://github.com/darold/pgFormatter), and [pg-minify](https://github.com/vitaly-t/pg-minify).


## Installation

```swift
.package(url: "https://github.com/freyaalminde/sql-formatting.git", branch: "main")
```

```swift
import SQLFormatting
```


## Usage

```swift
SQLFormatter.formattedString(from: "…")

SQLFormatter.formattedString(from: "…", indent: "\t", uppercase: true)

SQLFormatter.extendedFormattedString(from: "…")

SQLFormatter.minifiedString(from: "…")

SQLFormatter.minifiedString(from: "…", compress: true)
```

