import envoy
import filepath
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

pub type BaseDirectory {
  BaseDirectory(
    data_home: String,
    config_home: String,
    cache_home: String,
    state_home: String,
    data_dirs: List(String),
    config_dirs: List(String),
    runtime_dir: Option(String),
  )
}

pub type Error {
  Error(kind: ErrorKind)
}

pub type ErrorKind {
  AnyError
}

/// Reads the process environment, determines the XDG base directories,
/// and returns a value that can be used for lookup.
/// The following environment variables are examined:
///
///   * `HOME`; if not set: use the same fallback as `std::env::home_dir()`;
///     if still not available: return an error.
///   * `XDG_DATA_HOME`; if not set: assumed to be `$HOME/.local/share`.
///   * `XDG_CONFIG_HOME`; if not set: assumed to be `$HOME/.config`.
///   * `XDG_CACHE_HOME`; if not set: assumed to be `$HOME/.cache`.
///   * `XDG_STATE_HOME`; if not set: assumed to be `$HOME/.local/state`.
///   * `XDG_DATA_DIRS`; if not set: assumed to be `/usr/local/share:/usr/share`.
///   * `XDG_CONFIG_DIRS`; if not set: assumed to be `/etc/xdg`.
///   * `XDG_RUNTIME_DIR`; if not accessible or permissions are not `0700`:
///     record as inaccessible (can be queried with
///     [has_runtime_directory](method.has_runtime_directory)).
///
/// As per specification, if an environment variable contains a relative path,
/// the behavior is the same as if it was not set.
pub fn new() -> BaseDirectory {
  // Reads $HOME
  let home_directory: String =
    read_home()
    |> result.unwrap("")

  // Reads $XDG_CONFIG_DIRS
  let config_directories: List(String) =
    read_config_dirs()
    |> result.unwrap(["/etc/xdg"])

  // Reads $XDG_DATA_DIRS
  let data_directories: List(String) =
    read_data_dirs()
    |> result.unwrap(["/usr/local/share", "/usr/share"])

  let runtime_directory: Option(String) =
    read_runtime_dirs()
    |> result.unwrap(None)

  BaseDirectory(
    data_home: filepath.join(home_directory, ".local/share"),
    config_home: filepath.join(home_directory, ".config"),
    cache_home: filepath.join(home_directory, ".cache"),
    state_home: filepath.join(home_directory, ".local/state"),
    data_dirs: data_directories,
    config_dirs: config_directories,
    runtime_dir: runtime_directory,
  )
}

/// Reads $HOME
pub fn read_home() -> Result(String, Nil) {
  let value =
    envoy.get("HOME")
    |> result.unwrap("")

  Ok(value)
}

/// Reads $XDG_CONFIG_DIRS
pub fn read_config_dirs() -> Result(List(String), Nil) {
  let value =
    envoy.get("XDG_CONFIG_DIRS")
    |> result.unwrap("")

  Ok(
    value
    |> string.split(":"),
  )
}

/// Reads $XDG_CONFIG_DIRS
pub fn read_data_dirs() -> Result(List(String), Nil) {
  let value =
    envoy.get("XDG_DATA_DIRS")
    |> result.unwrap("")

  Ok(
    value
    |> string.split(":"),
  )
}

/// Reads $XDG_RUNTIME_DIR
pub fn read_runtime_dirs() -> Result(Option(String), Nil) {
  let value =
    envoy.get("XDG_RUNTIME_DIR")
    |> result.unwrap("")

  Ok(Some(value))
}
