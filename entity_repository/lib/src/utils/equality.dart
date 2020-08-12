part of entity_repository;

/// Copied from flutter collection, since otherwise this package cannot be used
/// when it is not in a flutter app. Also, renamed the names, to avoid
/// conflict with flutter/lib/src/foundation/collections.dart

/// Compares two lists for deep equality.
///
/// Returns true if the lists are both null, or if they are both non-null, have
/// the same length, and contain the same members in the same order. Returns
/// false otherwise.
///
/// The term "deep" above refers to the first level of equality: if the elements
/// are maps, lists, sets, or other collections/composite objects, then the
/// values of those elements are not compared element by element unless their
/// equality operators ([Object.==]) do so.
///
/// See also:
///
///  * [setEquality], which does something similar for sets.
///  * [mapEquality], which does something similar for maps.
bool listEquality<T>(List<T> a, List<T> b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}

/// Compares two sets for deep equality.
///
/// Returns true if the sets are both null, or if they are both non-null, have
/// the same length, and contain the same members. Returns false otherwise.
/// Order is not compared.
///
/// The term "deep" above refers to the first level of equality: if the elements
/// are maps, lists, sets, or other collections/composite objects, then the
/// values of those elements are not compared element by element unless their
/// equality operators ([Object.==]) do so.
///
/// See also:
///
///  * [listEquality], which does something similar for lists.
///  * [mapEquality], which does something similar for maps.
bool setEquality<T>(Set<T> a, Set<T> b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (final value in a) {
    if (!b.contains(value)) return false;
  }
  return true;
}

/// Compares two maps for deep equality.
///
/// Returns true if the maps are both null, or if they are both non-null, have
/// the same length, and contain the same keys associated with the same values.
/// Returns false otherwise.
///
/// The term "deep" above refers to the first level of equality: if the elements
/// are maps, lists, sets, or other collections/composite objects, then the
/// values of those elements are not compared element by element unless their
/// equality operators ([Object.==]) do so.
///
/// See also:
///
///  * [setEquality], which does something similar for sets.
///  * [listEquality], which does something similar for lists.
bool mapEquality<T, U>(Map<T, U> a, Map<T, U> b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  if (identical(a, b)) return true;
  for (final key in a.keys) {
    if (!b.containsKey(key) || b[key] != a[key]) {
      return false;
    }
  }
  return true;
}
