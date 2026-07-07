# safety_json_serializable

[![Pub Package](https://img.shields.io/pub/v/safety_json_serializable.svg)](https://pub.dev/packages/safety_json_serializable)

A drop-in replacement for [`package:json_serializable`] that generates
**null-safe, exception-free** `fromJson`/`toJson` code.

## Why

`json_serializable` generates deserialization code using Dart's `as` cast
(e.g. `json['id'] as int?`). If the backend ever changes the type of a field
— say `id` switches from `int` to `String` — that cast throws a
`TypeError` at runtime and crashes the app.

`safety_json_serializable` is a fork of `json_serializable` that replaces
those unsafe `as` casts with tolerant parsing (`toString()` + `tryParse`,
type checks before casting, etc.), so a type mismatch from the backend
degrades to `null` / an empty value instead of crashing the app.

## Supported types (exception-free, nullable)

[`BigInt`], [`bool`], [`DateTime`], [`double`], [`int`],
[`List`], [`Map`], [`Object`], [`String`], [`Uri`]

> **Note:** the safe, exception-free parsing above only applies to
> **nullable** fields (`int?`, `String?`, `User?`, `List<User>?`, etc.). Non-nullable
> fields (`int`, `String`, `User`, `List<User>`, etc.) fall back to the exact same
> behavior as upstream `json_serializable` — a type mismatch on a
> non-nullable field will still throw a `TypeError` and can crash the app.
> If you want a field to be crash-safe, declare it as nullable.

## Example

Left: `json_serializable` — Right: `safety_json_serializable`

![diff](https://raw.githubusercontent.com/minhtritc97/safety_json_serializable/refs/heads/master/json_serializable/resources/diff.png)

## Installation

```yaml
dependencies:
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.0
  safety_json_serializable: ^<latest_version>
```

Run the generator exactly as you would with `json_serializable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Migrating from json_serializable

Migration is **zero-config**. `safety_json_serializable` is built as a
drop-in replacement, so nothing in your existing code needs to change —
no new annotations, no changed imports, no different `build.yaml`.

**Step 1** — Open `pubspec.yaml` and replace the dependency:

```diff
 dev_dependencies:
-  json_serializable: ^6.11.3
+  safety_json_serializable: ^<latest_version>
```

**Step 2** — Get packages and regenerate:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

That's it. Your models, `@JsonSerializable()` annotations, `@JsonKey()`
customizations, `part '*.g.dart'` declarations, and `build.yaml` options
all stay exactly as they are — `safety_json_serializable` only changes
*how* the generator emits the parsing code inside `.g.dart`, not the
public API you use to configure it.

### What changes in generated code

```dart
// json_serializable
id: json['id'] as int?,

// safety_json_serializable
id: json['id'] == null ? null : int.tryParse(json['id'].toString()),
```

```dart
// json_serializable
users: (json['users'] as List<dynamic>?)
    ?.map((e) => User.fromJson(e as Map<String, dynamic>))
    .toList(),

// safety_json_serializable
users: json['users'] is List
    ? (json['users'] as List<dynamic>)
        .map((e) => e == null || e is! Map
            ? null
            : User.fromJson(e as Map<String, dynamic>))
        .toList()
    : [],
```

### Compatibility notes

- `safety_json_serializable` tracks a specific upstream `json_serializable`
  version (see the package's `pubspec.yaml` for the exact base version).
  When upgrading, check the [CHANGELOG](CHANGELOG.md) to confirm which
  upstream version a release is rebased on.
- Because this package intercepts the generator's own cast/list/map
  helpers, it must be kept in sync with upstream `json_serializable`
  releases; see [CHANGELOG](CHANGELOG.md) for parity status.
- `json_annotation` stays as your regular dependency — only the
  `dev_dependencies` entry for the generator changes.
- Migrating does **not** retroactively make every field crash-safe. Only
  fields declared as nullable get the tolerant parsing; non-nullable
  fields keep the original `as` cast behavior and can still throw. Review
  your models and mark fields nullable where you want the safety net.


[`package:json_serializable`]: https://pub.dev/packages/json_serializable
[`BigInt`]: https://api.dart.dev/stable/dart-core/BigInt-class.html
[`bool`]: https://api.dart.dev/stable/dart-core/bool-class.html
[`DateTime`]: https://api.dart.dev/stable/dart-core/DateTime-class.html
[`double`]: https://api.dart.dev/stable/dart-core/double-class.html
[`int`]: https://api.dart.dev/stable/dart-core/int-class.html
[`List`]: https://api.dart.dev/stable/dart-core/List-class.html
[`Map`]: https://api.dart.dev/stable/dart-core/Map-class.html
[`Object`]: https://api.dart.dev/stable/dart-core/Object-class.html
[`String`]: https://api.dart.dev/stable/dart-core/String-class.html
[`Uri`]: https://api.dart.dev/stable/dart-core/Uri-class.html